# profile .zshrc
# zmodload zsh/zprof

# https://zsh.sourceforge.io/Doc/Release/Options.html
# append to history and share history between terminals
setopt INC_APPEND_HISTORY

# don't store duplicates in zsh history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS

# don't store commands prefixed with a space
setopt HIST_IGNORE_SPACE

# https://github.com/robbyrussell/oh-my-zsh
export ZSH=$HOME/.oh-my-zsh

plugins=(
    docker
    git
    command-not-found
)

# init oh-my-zsh
source $ZSH/oh-my-zsh.sh

# init starship prompt
if command -v starship >/dev/null; then
  eval "$(starship init zsh)"
fi

if [ "$DEKSTOP_SESSION" = kde ] && command -v ksshaskpass >/dev/null; then
  export SSH_ASKPASS=ksshaskpass
  export SSH_ASKPASS_REQUIRE=prefer
fi

if [[ -f ~/.local/bin/mise ]]; then
  eval "$(~/.local/bin/mise activate zsh)"
fi

# enable zmv for batch renaming
# https://blog.thecodewhisperer.com/permalink/renaming-magically-with-zmv
autoload -U zmv

function random-string {
    openssl rand -base64 1024 | tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1
}

function uuid3 {
    python -c "import uuid; print(uuid.uuid3(uuid.UUID('$1'), '$2'))"
}

function uuid4 {
    python -c "import uuid; print(uuid.uuid4())"
}

function uuid5 {
    python -c "import uuid; print(uuid.uuid5(uuid.UUID('$1'), '$2'))"
}

# zprof

. "$HOME/.local/env"
