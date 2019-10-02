# https://github.com/robbyrussell/oh-my-zsh
export ZSH=$HOME/.oh-my-zsh

# https://github.com/denysdovhan/spaceship-prompt
ZSH_THEME="spaceship"
SPACESHIP_CHAR_SYMBOL="$ "
SPACESHIP_PROMPT_ORDER=(
  time          # Time stamps section
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  exec_time     # Execution time
  line_sep      # Line break
  battery       # Battery level and status
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)

plugins=(
    aws
    docker
    docker-compose
    dotenv
    git
    git-hubflow
    gpg-agent
    httpie
    tmuxinator
)

if uname -s | grep -Fq "Linux"; then
    # Linux specific (including WSL) oh-my-zsh config
    plugins=(
        $plugins
        command-not-found
        debian
    )

    # Fix tilix VTE issue
    # https://github.com/gnunn1/tilix/wiki/VTE-Configuration-Issue
    if [[ $TILIX_ID ]]; then
        source /etc/profile.d/vte.sh
    fi
fi

if uname -s | grep -Fq "Darwin"; then
    # Mac specific oh-my-zsh config
    plugins=(
        $plugins
        brew
        osx
    )
fi

if uname -r | grep -Fq "Microsoft"; then
    # WSL specific oh-my-zsh config
fi

# init oh-my-zsh
source $ZSH/oh-my-zsh.sh

# enable zmv for batch renaming
# https://blog.thecodewhisperer.com/permalink/renaming-magically-with-zmv
autoload -U zmv

# init pyenv if installed
if which pyenv >/dev/null; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# init RVM if installed
if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
    source "$HOME/.rvm/scripts/rvm"
fi

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

if uname -s | grep -Fq "Linux"; then
    # Linux specific (including WSL) config
fi

if uname -s | grep -Fq "Darwin"; then
    # Mac specific config
fi

if uname -r | grep -Fq "Microsoft"; then
    # WSL specific config
    # make sure ssh-agent is running
    if [ -z "$(pgrep ssh-agent)" ]; then
        # remove any dangling agent files
        find /tmp -maxdepth 1 -name 'ssh-*' -delete
        eval $(ssh-agent -s) >/dev/null
        # add the main key, so I only need to type the passphrase once
        ssh-add ~/.ssh/id_rsa
    else
        export SSH_AGENT_PID=$(pgrep ssh-agent)
        export SSH_AUTH_SOCK=$(ls /tmp/ssh-*/agent.*)
    fi
fi
