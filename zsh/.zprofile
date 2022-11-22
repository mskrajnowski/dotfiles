export LANG=en_US.UTF-8

export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# python
if command -v python3 &>/dev/null; then
    export PATH="$PATH:$(python3 -c 'import site; print(site.USER_BASE + "/bin")')"
fi

# go
export GOPATH="$HOME/.go"
export PATH="$HOME/.go/bin:$PATH"

if uname -s | grep -Fq "Linux"; then
    # Linux specific (including WSL) variables
fi

if uname -s | grep -Fq "Darwin"; then
    # Mac specific oh-my-zsh variables
fi

if uname -r | grep -Fq "Microsoft"; then
    # WSL specific oh-my-zsh variables
    export DISPLAY=localhost:0.0
fi
