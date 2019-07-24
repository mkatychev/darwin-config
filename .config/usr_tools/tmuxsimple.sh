#!/bin/sh
#
# Setup a work space called `work` with two windows
# first window has 3 panes. 
# The first pane set at 65%, split horizontally, set to api root and running vim
# pane 2 is split at 25% and running redis-server 
# pane 3 is set to api root and bash prompt.
# note: `api` aliased to `cd ~/path/to/work`
#
tmux start-server
# set up tmux
tmux new -d


# Split pane 1 horizontal by 65%, start redis-server
tmux splitw -h
tmux splitw -v
tmux select-pane -t 0
tmux -2 attach-session -d

