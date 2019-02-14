export LANG=en_US.UTF-8

export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# python
export PATH="$HOME/.pyenv/bin:$PATH"
export PATH="$PATH:$(python -c 'import site; print site.USER_BASE + "/bin"')"

if which python3 >/dev/null; then
    export PATH="$PATH:$(python3 -c 'import site; print(site.USER_BASE + "/bin")')"
fi

# go
export GOPATH="$HOME/.go"
export PATH="$HOME/.go/bin:$PATH"

# ruby
export PATH="$HOME/.rvm/bin:$PATH"

if uname -s | grep -Fq "Linux"; then
    # Linux specific (including WSL) variables
fi

if uname -s | grep -Fq "Darwin"; then
    # Mac specific oh-my-zsh variables
    export PATH="$PATH:/usr/local/opt/node@8/bin"
fi

if uname -r | grep -Fq "Microsoft"; then
    # WSL specific oh-my-zsh variables
    export DISPLAY=localhost:0.0
fi
