# virtualenvwrapper
export VIRTUAL_ENV_DISABLE_PROMPT=true
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/projects
# source /usr/local/bin/virtualenvwrapper.sh

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="mskrajnowski"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="false"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    aws
    bundler
    debian
    docker
    docker-compose
    gem
    git 
    git-hubflow 
    httpie
    node 
    npm 
    osx
    pip 
    postgres 
    pyenv
    python 
    virtualenv 
    virtualenvwrapper 
    yarn
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export PATH="$HOME/bin:$HOME/.pyenv/bin:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
# export MANPATH="/usr/local/man:$MANPATH"


# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

autoload -U zmv

# https://direnv.net
if which direnv >/dev/null; then
    eval "$(direnv hook zsh)"
fi

# Load RVM into a shell session as a function
if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
    source "$HOME/.rvm/scripts/rvm" 
fi

alias docker-compose-run="docker-compose run --rm"
alias dkc="docker-compose"
alias dkcr="docker-compose-run"
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

if uname -r | grep -Fq "Microsoft"; then
    # ssh-agent configuration
    if [ -z "$(pgrep ssh-agent)" ]; then
        eval $(ssh-agent -s) > /dev/null
    else
        export SSH_AGENT_PID=$(pgrep ssh-agent)
        export SSH_AUTH_SOCK=$(ls /tmp/ssh-*/agent.*)
    fi

    ssh-add 2>/dev/null
fi
