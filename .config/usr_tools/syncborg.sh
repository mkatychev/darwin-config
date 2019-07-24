#!/usr/bin/env bash
# the envvar $REPONAME is something you should just hardcode
export REPOSITORY="borgbackup" 
export RUSTDIR="Documents/rust"
cd ~
# Fill in your password here, borg picks it up automatically
read -sp "borg password:" BORG_PASSPHRASE
export BORG_PASSPHRASE

# Backup all of /home except a few excluded directories and files
borg create -v --stats --compression lz4              \
    $REPOSITORY::'rust_{now:%Y_%m_%d_%H_%M}' $RUSTDIR \
--exclude '**/target/*'                         \
--exclude 'Cargo.lock'                                \
--exclude '*.rs.bk'                                   \

# Route the normal process logging to journalctl
2>&1

# If there is an error backing up, reset password envvar and exit
if [ "$?" = "1" ] ; then
    export BORG_PASSPHRASE=""
    exit 1
fi

# Prune the repo of extra backups
borg prune -v $REPOSITORY --prefix 'rust-' \
    --keep-hourly=6                        \
    --keep-daily=7                         \
    --keep-weekly=4                        \
    --keep-monthly=6                       \
 
# Include the remaining device capacity in the log
df -hl | grep --color=never /dev/sdc
 
borg list $REPOSITORY
 
cd -
# Unset the password
export BORG_PASSPHRASE=""
exit 0
#mkdir ~/borgdrivebackup
#mount rust: ~/borgbackup -v --max-read-ahead 200M --buffer-size 32M --dir-cache-time 300h --poll-interval 5m
