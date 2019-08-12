#!/usr/bin/env python3

import os
import re
import sys
import json
import subprocess
import tempfile
import atexit
import argparse
import logging
import errno
import textwrap
from subprocess import PIPE, Popen
from datetime import datetime

import urwid

# #############################################################################
# constants
# #############################################################################

DATA_FOLDER = os.getenv('XDG_DATA_HOME', os.path.expanduser('~/.local/share'))
CFG_FOLDER = os.getenv('XDG_CONFIG_HOME', os.path.expanduser('~/.config'))

SIGNALCLI_LEGACY_FOLDER = os.path.join(CFG_FOLDER, 'signal')
SIGNALCLI_LEGACY_DATA_FOLDER = os.path.join(SIGNALCLI_LEGACY_FOLDER, 'data')
SIGNALCLI_LEGACY_ATTACHMENT_FOLDER = os.path.join(SIGNALCLI_LEGACY_FOLDER, 'attachments')

SIGNALCLI_FOLDER = os.path.join(DATA_FOLDER, 'signal-cli')
SIGNALCLI_DATA_FOLDER = os.path.join(SIGNALCLI_FOLDER, 'data')
SIGNALCLI_ATTACHMENT_FOLDER = os.path.join(SIGNALCLI_FOLDER, 'attachments')

SCLI_DATA_FOLDER = os.path.join(DATA_FOLDER, 'scli')
SCLI_HISTORY_FILE = os.path.join(SCLI_DATA_FOLDER, 'history')
SCLI_CFG_FILE = os.path.join(CFG_FOLDER, 'sclirc')
SCLI_LOG_FILE = os.path.join(SCLI_DATA_FOLDER, 'log')

# #############################################################################
# coloring stuff
# #############################################################################

# TODO: make costumizable

PALETTE = [('normal', '', ''),
           ('box_normal', '', ''),
           ('box_focused', 'dark blue', ''),
           ('bold', 'bold', ''),
           ('italic', 'italics', ''),
           ('strikethrough', 'strikethrough', ''),
           ('bolditalic', 'italics,bold', ''),
           ('reversed', 'standout', '')]

LIST_FOCUS_MAP = { None:'reversed',
                   'normal': 'reversed',
                   'bold'  : 'reversed',
                   'italic': 'reversed',
                   'strikethrough': 'reversed',
                   'bolditalic': 'reversed'}

FORMAT_MAP = {'_': 'italic',
              '*': 'bold',
              '~': 'strikethrough'}

def ibtxt(txt): return ('bolditalic', txt)
def ntxt(txt): return ('normal', txt)
def btxt(txt): return ('bold', txt)
def itxt(txt): return ('italic', txt)
def to_txt(txt):
    if isinstance(txt, str):
        return txt
    elif isinstance(txt, tuple):
        return txt[1]
    else:
        return ''.join([to_txt(t) for t in txt])

# #############################################################################
# utility
# #############################################################################

def has_key(key, x):
    if x:
        return key in x
    return False

def get_urls(txt):
    return re.findall(r'(https?://[^\s]+)', txt)

def mk_call(cmd, rmap=None, disown=False):
    if not rmap:
        rmap = {}

    for key, val in rmap.items():
        cmd = cmd.replace(key, val)

    if disown:
        with open(os.devnull, 'w') as f:
            subprocess.Popen(cmd, shell=True, stdout=f, stderr=f, preexec_fn=os.setpgrp)
    else:
        pipe = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        out, err = pipe.communicate()
        logging.info('mk_call:%s', cmd)
        if pipe.returncode == 0:
            logging.info('mk_call:exit_0:%s', out.decode('utf-8'))
        else:
            logging.critical('mk_call:exit_%d:%s', pipe.returncode, err.decode('utf-8'))

        return out

# #############################################################################
# signal utility
# #############################################################################

def hash_contact(x):
    h = ''
    if x.get('number'):
        h = x['number']
    elif x.get('groupId'):
        h = x['groupId']
    else:
        logging.critical('hash_contact:No number or groupId')
    return h

def get_contact_name(x):
    if not x:
        logging.critical('get_contact_name:empty sender')
        return "NULL"

    name = x.get('name')
    if name or name.strip(' ') != '':
        return name

    number = x.get('number')
    if number:
        return number

    return "ERR"

def is_contact_group(contact):
    return has_key('groupId', contact)

def is_envelope_outgoing(envelope):
    try:
        envelope['target']
        return True
    except KeyError:
        return False

def is_envelope_group_message(envelope):
    try:
        envelope['dataMessage']['groupInfo']['groupId']
        return True
    except (KeyError, TypeError):
        return False

def get_envelope_msg(envelope):
    try:
        return envelope['dataMessage']['message']
    except (KeyError, TypeError):
        return None

def get_envelope_contact(envelope, signal):
    x = None
    if envelope.get('target'):
        x = envelope['target']
    elif is_envelope_group_message(envelope):
        x = get_envelope_group_id(envelope)
    else:
        x = envelope['source']

    contact = signal.get_contact(x)
    if not contact:
        logging.critical('NULL_CONTACT:%s', envelope)

    return contact

def get_envelope_group_id(envelope):
    try:
        return envelope['dataMessage']['groupInfo']['groupId']
    except (KeyError, TypeError):
        return None

def get_envelope_attachments(envelope):
    try:
        return envelope['dataMessage']['attachments']
    except (KeyError, TypeError):
        return []

def get_attachment_name(attachment):
    try:
        return attachment['contentType']
    except (KeyError, TypeError):
        return os.path.basename(attachment)

def get_attachment_path(attachment):
    if isinstance(attachment, dict):
        received_attachment = os.path.join(SIGNALCLI_ATTACHMENT_FOLDER, str(attachment['id']))
        if not os.path.exists(received_attachment):
            received_attachment = os.path.join(SIGNALCLI_LEGACY_ATTACHMENT_FOLDER, str(attachment['id']))
        return received_attachment
    elif isinstance(attachment, str) and os.path.exists(attachment):
        return attachment

# #############################################################################
# ui utility
# #############################################################################

def listbox_focus_prev(listbox):
    try: listbox.focus_position = listbox.focus_position - 1
    except IndexError: pass

def listbox_focus_next(listbox):
    try: listbox.focus_position = listbox.focus_position + 1
    except IndexError: pass


class FocusableText(urwid.AttrMap):
    def __init__(self, markup, **kwargs):
        super().__init__(urwid.Text(markup, **kwargs), None, focus_map=LIST_FOCUS_MAP)


class NiceBox(urwid.AttrMap):
    def __init__(self, w, title=''):
        box = urwid.AttrMap(urwid.LineBox(urwid.AttrMap(w, 'normal'), title_align='center', title=title), 'box_normal')
        super().__init__(box, None, focus_map={'box_normal':'box_focused'})

class PopUpWrapper(urwid.LineBox):
    signals = ['closed']

    def __init__(self, widget, buttons=True):
        self._widget = widget
        self._widget.result = None

        self._buttons = buttons
        if buttons:
            btn_ok = urwid.Button('OK')
            btn_cancel = urwid.Button('Cancel')
            self.buttons_grid = urwid.GridFlow([btn_ok, btn_cancel],
                                                10, 1, 1,
                                                ('relative', 100))
            super().__init__(urwid.Frame(widget, footer=self.buttons_grid))
        else:
            super().__init__(widget)

    def keypress(self, size, key):
        if self._buttons:
            if key == 'tab':
                if self.original_widget.focus_position == 'footer':
                    if self.buttons_grid.focus_position == 0:
                        self.buttons_grid.focus_position = 1
                    else:
                        self.original_widget.focus_position = 'body'
                else:
                    self.buttons_grid.focus_position = 0
                    self.original_widget.focus_position = 'footer'
            # I'm not sure why I need to do this:
            elif self.original_widget.focus_position == 'body':
                self.original_widget.keypress(size, key)
            elif key == 'enter':
                if self.buttons_grid.focus_position == 0:
                    self._emit('closed', True, self._widget.result)
                else:
                    self._emit('closed', False, None)
                self._emit('closed', False, None)

        if key == 'q':
            self._emit('closed', False, None)


class MessageInfo(urwid.ListBox):
    def __init__(self, state, envelope):
        self.state = state

        source = envelope['source']
        msg = get_envelope_msg(envelope)
        date = None
        try:
            date = datetime.utcfromtimestamp(envelope['timestamp'])
        except ValueError:
            date = datetime.utcfromtimestamp(envelope['timestamp'] / 1000)
        date = date.strftime('%H:%M (%Y-%m-%d)')

        txt_name = FocusableText([btxt('Name   : '),
                                  ntxt(get_contact_name(state.signal.get_contact(source)))])
        txt_source = FocusableText([btxt('Number : '),
                                    ntxt(source)])
        txt_date = FocusableText([btxt('Date   : '),
                                  ntxt(date)])
        txt_msg = FocusableText([btxt('Message: '),
                                 ntxt(msg)])
        txt_urls = FocusableText([btxt('Links')], align='center')

        urls = []
        for url in get_urls(msg):
            txt_url = FocusableText([ntxt(url)])
            txt_url.full_path = url
            urls.append(txt_url)

        txt_atchs = FocusableText(btxt('Attachments'), align='center')

        atchs = []
        for atch in get_envelope_attachments(envelope):
            txt_atch = FocusableText(ntxt(get_attachment_name(atch)))
            txt_atch.original_widget.full_path = get_attachment_path(atch)
            atchs.append(txt_atch)


        items = [txt_name, txt_source, txt_date, txt_msg, txt_urls, *urls, txt_atchs, *atchs]
        super().__init__(urwid.SimpleFocusListWalker(items))

    def keypress(self, size, key):
        item = self.body[self.focus_position].original_widget

        if key == 'j':
            listbox_focus_next(self)
        elif key == 'k':
            listbox_focus_prev(self)
        elif key == 'y':
            text, _ = item.get_text()
            try:
                clip.put(self.state, item.full_path)
            except AttributeError:
                try:
                    clip.put(self.state, text.split(": ")[1])
                except IndexError:
                    clip.put(self.state, text)
        elif key in ('enter', 'o'):
            try:
                commands.open_file(self.state, item.full_path)
            except (AttributeError, TypeError):
                pass


class HelpDialog(urwid.ListBox):
    def __init__(self):
        items = []
        items.append(urwid.Text(btxt("Keybindings")))
        items.append(urwid.Text(btxt("Commands")))
        super().__init__(urwid.SimpleFocusListWalker(items))

# #############################################################################
# clipboard
# #############################################################################

class clip:
    mime_order = ['image/png', 'image/jpeg', 'image/jpg', 'text/uri-list']

    @staticmethod
    def xrun(mime):
        p = Popen(['xclip', '-selection', 'clipboard', '-t', mime, '-o'], stdout=PIPE, stderr=PIPE)
        out, err = p.communicate()
        return out

    @staticmethod
    def xrun_lines(mime):
        out = clip.xrun(mime)
        if out:
            return out.decode('utf-8').split('\n')

    @staticmethod
    def xfiles():
        out = clip.xrun_lines('TARGETS')

        for otype in out:
            for mtype in clip.mime_order:
                if mtype == otype:
                    if mtype.startswith('image/'):
                        content = clip.xrun(mtype)
                        suffix = '.' + mtype.split('/')[1]
                        tmp = tempfile.NamedTemporaryFile(mode='w+b', suffix=suffix, delete=False)
                        tmp.write(content)
                        tmp.flush()
                        tmp.close()
                        return [tmp.name]
                    elif mtype == 'text/uri-list':
                        content = clip.xrun_lines(mtype)
                        return [x.replace('file://', '') for x in content[1:]]

    @staticmethod
    def xput(txt):
        if not txt:
            return

        p = Popen(['xclip', '-selection', 'clipboard'], stdout=PIPE, stderr=PIPE, stdin=PIPE)
        p.stdin.write(bytes(txt, 'utf-8'))
        p.stdin.close()
        p.wait()

    @staticmethod
    def put(state, txt):
        cmd = state.cfg.clipboard_put_command
        if cmd == "":
            return clip.xput(txt)

        return mk_call(cmd, {'%s': txt})

    @staticmethod
    def files(state):
        cmd = state.cfg.clipboard_get_command
        if cmd == "":
            return clip.xfiles()

        return mk_call(cmd).split('\n')

# #############################################################################
# commands
# #############################################################################

class commands:
    @staticmethod
    def exec(state, cmd, args):
        for (abbrvs, fn) in cmd_map:
            if cmd in [abbrv.lower() for abbrv in abbrvs]:
                fn(state, args)
                return

    @staticmethod
    def  open_file(state, path):
        if os.path.exists(path):
            if isinstance(path, dict):
                mk_call(state.cfg.open_command, path, True)
            mk_call(state.cfg.open_command, {'%u': path}, True)

    @staticmethod
    def attach(state, args):
        try:
            args[0]
        except IndexError:
            state.set_error(':attach takes at least one argument.')
            return

        attachment = os.path.expanduser(args[0])
        message = ' '.join(args[1:])
        if not os.path.exists(attachment):
            state.set_error('File does not exist: ' + attachment)
            return

        state.signal.send_message(state.current_contact, message, [attachment])

    @staticmethod
    def attach_clip(state, args):
        files = clip.files(state)
        message = ' '.join(args)

        if files:
            state.signal.send_message(state.current_contact, message, files)
        else:
            state.set_notification('Clipboard is empty.')

    @staticmethod
    def open_attach(state, envelope):
        result = False
        attachments = get_envelope_attachments(envelope)
        for attachment in attachments:
            file_path = get_attachment_path(attachment)
            if file_path:
                commands.open_file(state, file_path)
                result = True

        return result

    @staticmethod
    def open_last_attach(state, args):
        for txt in state.current_chat[::-1]:
            if commands.open_attach(state, txt.envelope): return

    @staticmethod
    def open_url(state, envelope):
        txt = get_envelope_msg(envelope)
        urls = get_urls(txt)
        if urls:
            mk_call(state.cfg.open_command, {'%u': urls[0]}, True)
            return True

        return False

    @staticmethod
    def open_last_url(state, args):
        for txt in state.current_chat[::-1]:
            if commands.open_url(state, txt.envelope): return

    @staticmethod
    def toggle_notifications(state, args):
        state.cfg.enable_notifications = not state.cfg.enable_notifications
        notif = 'Desktop notifications are '
        if state.cfg.enable_notifications: notif = notif + 'ON'
        else: notif = notif + 'OFF'
        state.set_notification(notif + '.')

    @staticmethod
    def send_notification(state, sender, message):
        if state.cfg.enable_notifications:
            mk_call(state.cfg.notification_command, {'%s': sender, '%m': message})

    @staticmethod
    def quit(state, args):
        raise urwid.ExitMainLoop()

cmd_map = [(['attach', 'a'], commands.attach),
           (['attachClip', 'c'], commands.attach_clip),
           (['openAttach', 'o'], commands.open_last_attach),
           (['openUrl', 'u'], commands.open_last_url),
           (['toggleNotifications', 'n'], commands.toggle_notifications),
           (['quit', 'q'], commands.quit)]

# #############################################################################
# signal
# #############################################################################

class Signal:
    signals = ['receive_message', 'send_message']

    def __init__(self, user):
        self.user = user
        self._path = os.path.join(SIGNALCLI_DATA_FOLDER, user)
        if not os.path.exists(self._path):
            self._path = os.path.join(SIGNALCLI_LEGACY_DATA_FOLDER, user)
            if not os.path.exists(self._path):
                raise Exception(self.user + " does not exist!")
        self._data = self.load_data()
        self._buffer = b''

    def load_data(self):
        with open(self._path) as f:
            return json.load(f)

    def start_daemon(self, loop):
        fd = loop.watch_pipe(self.daemon_handler)
        return Popen(['signal-cli', '-u', self.user, 'daemon', '--json'], stdout=fd, stderr=fd, close_fds=True)

    def daemon_handler(self, line):
        line = self._buffer + line
        lines = line.split(b'\n')
        if lines[-1] != b'':
            # Not a complete message. Store in buffer
            self._buffer = lines[-1]
        else:
            self._buffer = b''

        # The last item is either empty or an incomplete message, so we don't process it
        for line in lines[:-1]:
            if not line.strip():
                continue

            try:
                e = json.loads(line)
                urwid.emit_signal(self, 'receive_message', e['envelope'])
            except Exception as e:
                logging.error('input: %s', line)
                logging.exception(e)
                # TODO: display error to user
                continue



    def send_message(self, contact, message="", attachments=None):
        if not attachments:
            attachments = []

        args = ['signal-cli', '--dbus', 'send', '--message', message]
        target = None
        if contact.get('number'):
            target = contact['number']
        else:
            target = contact['groupId']
            args.append('--group')
        args.append(target)

        attachment_paths = [os.path.expanduser(attachment) for attachment in attachments]
        if all([os.path.exists(attachment_path) for attachment_path in attachment_paths]):
            if attachment_paths:
                args.append('--attachment')
            for attachment_path in attachment_paths:
                args.append(attachment_path)
        else:
            logging.warning('send_message: Attached file(s) does not exist.')
            return

        p = Popen(args, stdout=PIPE, stderr=PIPE)
        _out, error = p.communicate()
        if p.returncode != 0:
            logging.error('send_message: exit code=%d:err=%s', p.returncode, error)
            # https://github.com/AsamK/signal-cli/issues/73
            # return

        ts = datetime.now().timestamp()
        envelope = {'source':self.user,
                    'target': target,
                    'timestamp': ts,
                    'dataMessage': {'message': message,
                                    'attachments': attachments,
                                    'timestamp': ts}}

        urwid.emit_signal(self, 'send_message', envelope)

    def contacts(self):
        return list(filter(lambda x: bool(get_contact_name(x).strip(' ')),
                           self._data['contactStore']['contacts']))

    def groups(self):
        # Need to filter out any groups that where "active" == false
        return list(filter(lambda a: bool(a['active']),
                    (filter(lambda n: bool(n['name'].strip(' ')),
                     self._data["groupStore"]['groups']))))

    def get_contact(self, number_or_id):
        for contact in self.contacts():
            if contact['number'] == number_or_id:
                return contact

        for group in self.groups():
            if group['groupId'] == number_or_id:
                return group

    def get_all_contacts(self):
        xs = []
        xs.append('Groups')
        xs.append('---')
        xs.extend(self.groups())
        xs.append('---')
        xs.append('Contacts')
        xs.append('---')
        xs.extend(self.contacts())
        return xs

urwid.register_signal(Signal, Signal.signals)

# #############################################################################
# ContactsWindow
# #############################################################################

class ContactsWindow(urwid.ListBox):
    def __init__(self, state):
        self.state = state
        self._body = []
        super().__init__(urwid.SimpleFocusListWalker(self._body))
        self.set_contacts(self.state.signal.get_all_contacts())
        self.focus_next()

        urwid.connect_signal(self.state.signal, 'receive_message', self.on_receive_message)
        urwid.connect_signal(self.state, 'current_contact_changed', self.on_current_contact_changed)

    @classmethod
    def set_contact_notify_count(cls, w, count):
        w.notify_count = count
        if count > 0:
            w.original_widget.set_text([('bold', '({}) '.format(w.notify_count)), get_contact_name(w.contact)])
        else:
            w.original_widget.set_text(get_contact_name(w.contact))

    def on_current_contact_changed(self, _old, _current, _focus=False):
        self.set_contact_notify_count(self.focus, 0)

    def on_receive_message(self, envelope):
        contact = get_envelope_contact(envelope, self.state.signal)
        has_msg = get_envelope_msg(envelope)
        if contact == self.state.current_contact or not has_msg:
            return

        for w in self._body:
            if w.contact == contact:
                self.set_contact_notify_count(w, w.notify_count + 1)
                return

    def set_contacts(self, contacts):
        def mk_contact(x):
            widget = None
            contact = None
            if x == '---':
                widget = urwid.Divider('-')
            elif isinstance(x, str):
                widget = urwid.Text(('bold', '~~ ' + x + ' ~~'), align='center')
            else:
                widget = urwid.Text(get_contact_name(x))
                contact = x

            am = urwid.AttrMap(widget, None, focus_map='reversed')
            am.contact = contact
            am.notify_count = 0
            return am

        contacts = [mk_contact(x) for x in contacts]
        self._body.extend(contacts)
        try:
            self.focus_position = 2
        except IndexError:
            pass

    def get_focused_contact(self):
        return self.focus.contact

    def focus_next(self):
        try:
            self.focus_position = self.focus_position + 1
            if not self.get_focused_contact():
                self.focus_next()
        except IndexError:
            pass

    def focus_prev(self):
        try:
            if self.focus_position > 2:
                self.focus_position = self.focus_position - 1
                if not self.get_focused_contact():
                    self.focus_prev()
        except IndexError:
            pass

    def focus_first(self):
        try:
            self.focus_position = 2
        except IndexError:
            pass

    def focus_last(self):
        try:
            self.focus_position = len(self._body) - 1
        except IndexError:
            pass

    def keypress(self, size, key):
        key = super().keypress(size, key)
        if key in ('enter', 'l'):
            if self.get_focused_contact():
                self.state.set_current_contact(self.get_focused_contact(), key == 'enter')
        elif key in ('j', 'down'):
            self.focus_next()
        elif key in ('k', 'up'):
            self.focus_prev()
        elif key == 'g':
            self.focus_first()
        elif key == 'G':
            self.focus_last()
        elif key == 'r':
            pass # TODO: refresh
        return key

# #############################################################################
# ChatWindow
# #############################################################################

class ChatWindow(urwid.Frame):
    def __init__(self, state):
        self.state = state
        self.pop_up_action = None

        self.search_mode = False
        self.search_list = urwid.SimpleFocusListWalker([])

        self._wsearch = urwid.ListBox(self.search_list)
        self._wtitle = urwid.Text('')
        self._wline = urwid.Edit(('bold', '> '))
        self._wdiv = urwid.Divider('-')
        self._wlist = urwid.ListBox(self.state.current_chat)

        self._w = urwid.WidgetPlaceholder(self._wlist)
        wcontext = urwid.Frame(self._w,
                              header=urwid.Divider('-'))
        self._wcontext = urwid.Frame(wcontext,
                                     header=self._wtitle,
                                     footer=self._wdiv)

        super().__init__(self._wcontext,
                         footer=self._wline)

        urwid.connect_signal(self._wline, 'postchange', self.on_edit_text_changed)
        urwid.connect_signal(self.state, 'current_contact_changed', self.on_current_contact_changed)
        urwid.connect_signal(self.state, 'dialog_requested', self.show_pop_up)
        urwid.connect_signal(self.state.signal, 'receive_message', self.on_new_message)
        urwid.connect_signal(self.state.signal, 'send_message', self.on_new_message)

    def show_pop_up(self, widget):
        def on_pop_up_closed(sender, accepted, result):
            self.remove_pop_up()
            urwid.emit_signal(self.state, 'dialog_finished', accepted, result)

        wrapper = PopUpWrapper(widget)
        urwid.connect_signal(wrapper, 'closed', on_pop_up_closed)

        popup = urwid.Overlay(wrapper,
                              self._w.original_widget,
                              align='center',
                              valign='middle',
                              width=('relative', 85),
                              height=('relative', 75))

        self._w.original_widget = popup
        return wrapper

    def remove_pop_up(self, _sender=None):
        if self.search_mode:
            self._w.original_widget = self._wsearch
        else:
            self._w.original_widget = self._wlist

    def on_edit_text_changed(self, _sender, _old_text):
        txt = self.get_edit_text()
        if txt.startswith('/'):
            if not self.search_mode:
                self.search_mode = True
                self._w.original_widget = self._wsearch
            self.search_in_chat()
        elif self.search_mode:
            self.search_mode = False
            self._w.original_widget = self._wlist

    def search_in_chat(self):
        if not self.search_mode:
            return

        search_txt = self.get_edit_text()[1:]
        def setx(i, txt):
            txt.real_index = i
            return txt
        found = [setx(i, txt) for i, txt in enumerate(self.state.current_chat) if search_txt in txt.original_widget.text]
        self.search_list.clear()
        self.search_list.extend(found)

    def on_new_message(self, _envelope):
        self.focus_chatlast()

    def is_focused_input(self):
        return self.focus_position == 'footer'

    def is_focused_chat(self):
        return self.focus_position == 'body'

    def focus_input(self):
        self.focus_position = 'footer'

    def focus_chat(self):
        self.focus_position = 'body'

    def focus_chatfirst(self):
        try:
            self._w.original_widget.focus_position = 0
        except IndexError:
            pass

    def focus_chatlast(self):
        try:
            self._w.original_widget.focus_position = len(self._w.original_widget.body) - 1
        except IndexError:
            pass

    def get_edit_text(self):
        return self._wline.get_edit_text()

    def set_edit_text(self, txt):
        self._wline.set_edit_text(txt)

    def set_title(self, contact):
        num = contact.get("number")
        if not num:
            num = ', '.join([get_contact_name(self.state.signal.get_contact(number)) for number in contact['members']])

        self._wtitle.set_text([('bold', get_contact_name(contact)), ' (', num, ')'])

    def on_current_contact_changed(self, old, current, focus=False):
        self.state.backup_chat(old)
        self.state.clear_current_chat()
        self.set_title(current)

        chat = self.state.chats.get(hash_contact(current))
        if chat: self.state.current_chat.extend(chat)

        self.focus_chatlast()

    def get_current_envelope(self):
        try:
            if self.search_mode:
                return self.search_list[self._wsearch.focus_position].envelope
            return self.state.current_chat[self._wlist.focus_position].envelope
        except (IndexError, AttributeError):
            return None

    def keypress(self, size, key):
        key = super().keypress(size, key)

        if self.is_focused_input():
            if key == 'enter':
                txt = self.get_edit_text()
                if txt.startswith(':'):
                    elems = list(filter(lambda x: x != '', txt[1:].split(' ')))
                    cmd = elems[0].lower()
                    args = elems[1:]
                    commands.exec(self.state, cmd, args)
                elif txt.startswith('/'):
                    pass
                elif txt.strip(' ') != '' and self.state.current_contact:
                    self.state.signal.send_message(self.state.current_contact, txt)
                self.set_edit_text('')
        elif not self.state.current_chat:
            return key
        elif self.is_focused_chat():
            envelope = self.get_current_envelope()
            if key in ('enter', 'l'):
                if self.search_mode:
                    real_index = self.search_list[self._wsearch.focus_position].real_index
                    self.set_edit_text('')
                    self._wlist.focus_position = real_index
                else:
                    commands.open_attach(self.state, envelope) or commands.open_url(self.state, envelope)
            elif key == 'o':
                commands.open_url(self.state, envelope) or commands.open_attach(self.state, envelope)
            elif key == 'j':
                listbox_focus_next(self._w.original_widget)
            elif key == 'k':
                listbox_focus_prev(self._w.original_widget)
            elif key == 'g':
                self.focus_chatfirst()
            elif key == 'G':
                self.focus_chatlast()
            elif key == 'y':
                txt = get_envelope_msg(envelope)
                clip.put(self.state, txt)
            elif key == 'd':
                if self.search_mode:
                    item = self.search_list[self._wsearch.focus_position]
                    real_index = item.real_index
                    del self.search_list[self._wsearch.focus_position]
                    del self.state.current_chat[real_index]
                else:
                    del self.state.current_chat[self._wlist.focus_position]
            elif key == 'i':
                self.show_pop_up(MessageInfo(self.state, envelope))
            elif key == 'q':
                # TODO: quote (https://github.com/AsamK/signal-cli/issues/151)
                pass
        return key

# #############################################################################
# MainWindow
# #############################################################################

class MainWindow(urwid.Frame):
    def __init__(self, state):
        self.state = state

        # ui
        self.current_focus = 'contacts'
        self._wcontacts = ContactsWindow(self.state)
        self._wchat = ChatWindow(self.state)
        self._wstatus = urwid.Text("...")

        wrapped_contacts = NiceBox(self._wcontacts)
        wrapped_chat = NiceBox(self._wchat)
        self._widgets = [('weight', 1, wrapped_contacts), ('weight', 3, wrapped_chat)]
        self._wcontext = urwid.Columns(widget_list=self._widgets, dividechars=0, focus_column=0)
        super().__init__(self._wcontext, footer=self._wstatus)

        # signals
        urwid.connect_signal(self.state, 'current_contact_changed', self.on_current_contact_changed)
        urwid.connect_signal(self.state, 'status_changed', self.on_status_changed)
        urwid.connect_signal(self.state, 'notification_changed', self.on_notification_changed)
        urwid.connect_signal(self.state, 'error_changed', self.on_error_changed)

    def set_status(self, txt):
        self._wstatus.set_text(txt)

    def set_contacts(self, contacts):
        self._wcontacts.set_contacts(contacts)

    def focus_input(self, cmd_mode=False, search_mode=False):
        self.focus_position = 'body'
        self._wcontext.set_focus(1)
        self._wchat.focus_input()
        self.current_focus = 'input'

        if cmd_mode:
            self._wchat._wline.set_edit_text(':')
            self._wchat._wline.set_edit_pos(1)
        elif search_mode:
            self._wchat._wline.set_edit_text('/')
            self._wchat._wline.set_edit_pos(1)

    def focus_contacts(self):
        self.focus_position = 'body'
        self._wcontext.set_focus(0)
        self.current_focus = 'contacts'

    def focus_chat(self):
        self.focus_position = 'body'
        self._wcontext.set_focus(1)
        self._wchat.focus_chat()
        self.current_focus = 'chat'

    def focus_next(self):
        if self.current_focus == 'contacts':
            self.focus_chat()
        elif self.current_focus == 'chat':
            self.focus_input()
        elif self.current_focus == 'input':
            self.focus_contacts()

    def focus_prev(self):
        if self.current_focus == 'contacts':
            self.focus_input()
        elif self.current_focus == 'chat':
            self.focus_contacts()
        elif self.current_focus == 'input':
            self.focus_chat()

    def show_help_pop_up(self):
        if self.current_focus == 'contacts':
            self._wchat.show_pop_up(HelpDialog())
        elif self.current_focus == 'chat':
            self._wchat.show_pop_up(HelpDialog())

    def on_current_contact_changed(self, old, current, focus=False):
        if self.state.status_data is self.state.current_contact:
            self.state.set_status('')

        if focus:
            self.focus_input()

    def on_status_changed(self, status, data):
        self.set_status(status)

    def on_notification_changed(self, notif, data):
        self.set_status(notif)

    def on_error_changed(self, err):
        self.set_status(err)

    def keypress(self, size, key):
        key = super().keypress(size, key)

        if key == 'tab':
            self.focus_next()
        elif key == 'shift tab':
            self.focus_prev()
        elif key == ':':
            self.focus_input(cmd_mode=True)
        elif key == '/':
            self.focus_input(search_mode=True)
        elif key == '?':
            self.show_help_pop_up()

        return key

# #############################################################################
# state
# #############################################################################

class State:
    signals = ['current_contact_changed', 'status_changed', 'notification_changed', 'error_changed', 'dialog_requested', 'dialog_finished']

    def __init__(self, cfg):
        self.signal = Signal(cfg.username)
        self.cfg = cfg
        self.chats = {}
        self.error = ''
        self.status = ''
        self.notification = ''
        self.status_data = None
        self.current_contact = None
        self.current_chat = urwid.SimpleFocusListWalker([])

        urwid.connect_signal(self.signal, 'receive_message', self.on_receive_message)
        urwid.connect_signal(self.signal, 'send_message', self.on_send_message)

    def set_current_contact(self, contact, focus=False):
        old = self.current_contact
        self.current_contact = contact
        urwid.emit_signal(self, 'current_contact_changed', old, contact, focus)

    def set_status(self, status, data=None):
        self.status = status
        self.status_data = data
        urwid.emit_signal(self, 'status_changed', status, data)

    def set_notification(self, notif, data=None):
        self.notification = notif
        self.status_data = data
        urwid.emit_signal(self, 'notification_changed', notif, data)

    def set_error(self, err):
        self.error = err
        urwid.emit_signal(self, 'error_changed', err)

    def show_dialog(self, w):
        urwid.emit_signal(self, 'dialog_requested', w)

    def clear_current_chat(self):
        self.current_chat.clear()

    def backup_chat(self, contact):
        if contact:
            self.chats[hash_contact(contact)] = [x for x in self.current_chat]

    def get_chat_for_envelope(self, envelope):
        contact = get_envelope_contact(envelope, self.signal)
        if contact == self.current_contact:
            return self.current_chat

        contact_hash = hash_contact(contact)
        if contact_hash not in self.chats:
            self.chats[contact_hash] = []

        return self.chats[contact_hash]

    def on_send_message(self, envelope):
        self.print_sent_message(envelope)

    def on_receive_message(self, envelope):
        msg = get_envelope_msg(envelope)
        sender = get_envelope_contact(envelope, self.signal)
        contact_name = get_contact_name(sender)

        if msg is None:
            logging.info('NOT_A_MESSAGE:%s', envelope)
            return
        logging.info('MESSAGE:%s', envelope)

        if sender != self.current_contact:
            notif = 'New message from ' + contact_name + ': "' + msg + '"'
            self.set_notification(notif, sender)

        formatted_message = self.print_received_message(envelope)
        commands.send_notification(self, contact_name, to_txt(formatted_message))

    def format_msg(self, message):
        message = '\n'.join(textwrap.wrap(message, width=self.cfg.wrap_at))

        if not self.cfg.use_formatting:
            return ntxt(message)

        i, m = 0, []
        while i < len(message):
            c = message[i]
            if c in ('_', '*', '~'):
                try:
                    end = message[i+1:].index(c)
                    sub = message[i+1:i+1+end]
                    m.append(c)
                    m.append((FORMAT_MAP[c], sub))
                    m.append(c)
                    i = i + 2 + end
                except ValueError:
                    m.append(c)
                    i = i + 1
            else:
                m.append(c)
                i = i + 1

        if not m:
            m = " "
        return m

    def print_received_message(self, envelope):
        source = envelope['source']
        is_group = is_envelope_group_message(envelope)
        attachments = get_envelope_attachments(envelope)

        txt = [btxt('>> ')]
        if is_group:
            contact = self.signal.get_contact(source)
            if contact: txt.append(ibtxt(get_contact_name(contact)))
            else: txt.append(btxt(source))
            txt.append(btxt(' | '))

        message = self.format_msg(get_envelope_msg(envelope))
        attachments = get_envelope_attachments(envelope)

        if attachments != []:
            attachments_txt = ', '.join([get_attachment_name(attachment) + ' (' + str(i) + ')' for i, attachment in enumerate(attachments)])
            txt.append(ntxt('[attached: ' + attachments_txt + '] '))

        txt.append(message)
        wtxt = FocusableText(txt)
        wtxt.envelope = envelope
        self.get_chat_for_envelope(envelope).append(wtxt)

        return txt[1:]

    def print_sent_message(self, envelope):
        message = self.format_msg(get_envelope_msg(envelope))
        attachments = get_envelope_attachments(envelope)

        txt = []
        if len(attachments) > 0:
            anames = ', '.join([os.path.basename(attachment) for attachment in attachments])
            txt.append(ntxt('[attached: '))
            txt.append(itxt(anames))
            txt.append(ntxt('] '))
            txt.append(ntxt(message))
            txt.append(btxt(' <<'))
        else:
            txt.append(message)
            txt.append(btxt(' <<'))

        wtxt = FocusableText(txt, align='right')
        wtxt.envelope = envelope
        self.get_chat_for_envelope(envelope).append(wtxt)

        return txt[:-1]

    def save_history(self):
        if not self.cfg.save_history:
            return

        self.backup_chat(self.current_contact)
        with open(SCLI_HISTORY_FILE, 'w') as history_file:
            envelopes = [x.envelope for vals in self.chats.values() for x in vals]
            items = {'envelopes': envelopes}
            history_file.write(json.dumps(items))

    def load_history(self):
        if not self.cfg.save_history or not os.path.exists(SCLI_HISTORY_FILE):
            return

        with open(SCLI_HISTORY_FILE, 'r') as history_file:
            history = json.load(history_file)
            for envelope in history['envelopes']:
                if is_envelope_outgoing(envelope):
                    self.print_sent_message(envelope)
                else:
                    self.print_received_message(envelope)

urwid.register_signal(State, State.signals)

# #############################################################################
# main
# #############################################################################

def parse_cfg_file(cfg_file_path):
    vars = {}
    cfg_file_path = os.path.expanduser(cfg_file_path)
    if os.path.exists(cfg_file_path):
        with open(cfg_file_path) as cfg_file:
            for line in cfg_file:
                if not line.startswith('#') and line.strip() != "":
                    name, var = line.partition("=")[::2]
                    vars[name.strip().replace('-', '_')] = var.strip()
    elif cfg_file_path != SCLI_CFG_FILE and cfg_file_path != "":
        print('Given config file not found: ' + cfg_file_path, file=sys.stderr)
        sys.exit(2)

    return vars

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-c',
                        '--config-file',
                        type=str,
                        default=SCLI_CFG_FILE,
                        help='Config file. Configs in this file overrides every other config supplied by command line. (Default: ' + SCLI_CFG_FILE + ')')

    parser.add_argument('-u',
                        '--username',
                        type=str,
                        help='Phone number starting with "+" followed by country code.')

    parser.add_argument('-n',
                        '--enable-notifications',
                        type=bool,
                        default=False,
                        help='Enable desktop notifications. (Also see --notification-command)')

    parser.add_argument('-N',
                        '--notification-command',
                        type=str,
                        default="notify-send scli '%s - %m'",
                        help='The command to run when a new message arrives. %%m is replaced with the message, %%s is replaced with the sender. (Default is "notify-send scli \'%%s - %%m\'')

    parser.add_argument('-o',
                        '--open-command',
                        type=str,
                        default='xdg-open "%u"',
                        help='File/URL opener command. %%u is replaced with the path. (Default is "xdg-open %%u")')

    parser.add_argument('-G',
                        '--clipboard-get-command',
                        type=str,
                        default="",
                        help='A command that returns a valid file path(s). When user calls `:attachClip` or `:c`, this command is executed and the returned file(s) will be added as attachment(s). The command should return one absolute file path per each line. (Default uses `xclip`)')

    parser.add_argument('-P',
                        '--clipboard-put-command',
                        type=str,
                        default="",
                        help='A command that puts given text to clipboard. %%s will be replaced with the text. (Default uses `xclip`.')

    parser.add_argument('-s',
                        '--save-history',
                        type=bool,
                        default=False,
                        help='Enable saving history. History is saved as plain text. (Default is false.)')

    parser.add_argument('-f',
                        '--use-formatting',
                        type=bool,
                        default=False,
                        help='Use _italic_, *bold*, ~strikethrough~ formatting in messages. (Default is false.)')

    parser.add_argument('-w',
                        '--wrap-at',
                        type=int,
                        default=70,
                        help='Wrap messages at given column.')

    parser.add_argument('--no-daemon',
                        action='store_true',
                        help='Not really useful.')

    parser.add_argument('--debug',
                        default=False,
                        action='store_true')

    cfg = parser.parse_args()
    file_cfg = parse_cfg_file(cfg.config_file)
    for key, val in file_cfg.items():
        attr = getattr(cfg, key)
        if isinstance(attr, bool):
            setattr(cfg, key, val.lower() in ['true', 't', 'yes', 'y'])
        elif isinstance(attr, int):
            setattr(cfg, key, int(val))
        else:
            setattr(cfg, key, val)

    if not os.path.exists(SCLI_DATA_FOLDER):
        try:
            os.makedirs(SCLI_DATA_FOLDER)
        except OSError as exc:
            if not (exc.errno == errno.EEXIST and os.path.isdir(SCLI_DATA_FOLDER)):
                print("Can't create data directory.", file=sys.stderr)
                sys.exit(3)

    if cfg.debug:
        logging.basicConfig(filename=SCLI_LOG_FILE, level=logging.DEBUG)
    else:
        logging.basicConfig(filename=SCLI_LOG_FILE, level=logging.CRITICAL)

    if not cfg.username:
        ulist = []
        try:
            users = [x for x in os.listdir(SIGNALCLI_DATA_FOLDER)
                     if os.path.isfile(os.path.join(SIGNALCLI_DATA_FOLDER, x))]
            ulist.extend(users)
            legacy_users = [x for x in os.listdir(SIGNALCLI_LEGACY_DATA_FOLDER)
                            if os.path.isfile(os.path.join(SIGNALCLI_LEGACY_DATA_FOLDER, x))]
            ulist.extend(legacy_users)
        except FileNotFoundError:
            pass

        if not ulist:
            print("Couldn't find any linked device.", file=sys.stderr)
            sys.exit(1)
        elif len(ulist) == 1:
            cfg.username = ulist[0]
        else:
            print("Use one of these:", file=sys.stderr)
            for u in ulist:
                print("\tscli --username=" + u, file=sys.stderr)
            sys.exit(1)

    state = State(cfg)
    window = MainWindow(state)

    loop = urwid.MainLoop(window, palette=PALETTE)

    state.load_history()
    atexit.register(state.save_history)

    if not cfg.no_daemon:
        proc = state.signal.start_daemon(loop)
        atexit.register(proc.kill)

    loop.run()
    proc.kill()

if __name__ == "__main__":
    main()