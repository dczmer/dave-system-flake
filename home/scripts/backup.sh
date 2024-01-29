# Setting this, so the repo does not need to be given on the commandline:
export BORG_REPO=ssh://dave@guinness/backup/lucky

# TODO: Use gnu pass integration to eliminate need to store a secret in the store
# See the section "Passphrase notes" for more infos.
export BORG_PASSPHRASE='REDACTED'

# some helpers and error handling:
info() { printf "\n%s %s\n\n" "$( date )" "$*" >&2; }
trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM

info "Starting backup"

# Backup the most important directories into an archive named after
# the machine this script is currently running on:

borg create                         \
    --verbose                       \
    --filter AME                    \
    --list                          \
    --stats                         \
    --show-rc                       \
    --compression lz4               \
    --exclude-caches                \
    --exclude='/home/dave/Public'   \
    --exclude='/home/dave/source'   \
    --exclude='/home/*/.cache/*'    \
    --exclude='*/cache'             \
    --exclude='*/Cache'             \
    --exclude='*/.yarn'             \
    --exclude='*/node_modules'      \
    --exclude='*/.venv'             \
    --exclude='/home/dave/Downloads'    \
    --exclude='/home/dave/Videos'   \
    --exclude='/home/dave/.arduino15'   \
    --exclude='/home/dave/.ccache'      \
    --exclude='/home/dave/.electron'    \
    --exclude='/home/dave/.mozilla'     \
    --exclude='/home/dave/.node-gyp'    \
    --exclude='/home/dave/.npm'     \
    --exclude='/home/dave/.nvm'     \
    --exclude='/home/dave/.pyenv'   \
    --exclude='/home/dave/.yarn'    \
    --exclude='/home/dave/.var'    \
    --exclude='/home/dave/.local'    \
    --exclude='/home/dave/.zplug'    \
    --exclude='/home/dave/.ssh'     \
    --exclude='/home/dave/.gnupg'   \
    --exclude='/home/dave/.password-store' \
                                    \
    ::'{hostname}-{now}'            \
    /home/dave                      \

backup_exit=$?

info "Pruning repository"

# Use the `prune` subcommand to maintain 7 daily, 4 weekly and 6 monthly
# archives of THIS machine. The '{hostname}-*' matching is very important to
# limit prune's operation to this machine's archives and not apply to
# other machines' archives also:

borg prune                          \
    --list                          \
    --glob-archives '{hostname}-*'  \
    --show-rc                       \
    --keep-daily    7               \
    --keep-weekly   4               \
    --keep-monthly  6

prune_exit=$?

# actually free repo disk space by compacting segments

info "Compacting repository"

borg compact

compact_exit=$?

# use highest exit code as global exit code
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))
global_exit=$(( compact_exit > global_exit ? compact_exit : global_exit ))

if [ ${global_exit} -eq 0 ]; then
    info "Backup, Prune, and Compact finished successfully"
elif [ ${global_exit} -eq 1 ]; then
    info "Backup, Prune, and/or Compact finished with warnings"
else
    info "Backup, Prune, and/or Compact finished with errors"
fi

exit ${global_exit}
