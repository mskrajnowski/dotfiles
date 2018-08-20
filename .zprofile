export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# python
export PATH="$HOME/.pyenv/bin:$PATH"

# go
export GOPATH="$HOME/.go"
export PATH="$HOME/.go/bin:$PATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$HOME/.rvm/bin:$PATH"

# Load system specific variables
if [ -e "$HOME/.zprofile.$(uname -s)" ]; then
    source $HOME/.zprofile.$(uname -s)
fi

if uname -r | grep -Fq "Microsoft"; then
    export DISPLAY=localhost:0.0
fi

