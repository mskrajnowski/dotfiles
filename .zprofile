PATH="$HOME/bin:$PATH"
PATH="$HOME/.local/bin:$PATH"

# python
PATH="$HOME/.pyenv/bin:$PATH"


# go
GOPATH="$HOME/.go"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
PATH="$HOME/.rvm/bin:$PATH"

# Load system specific variables
if [ -e "$HOME/.zprofile.$(uname -s)" ]; then
    source $HOME/.zprofile.$(uname -s)
fi

if uname -r | grep -Fq "Microsoft"; then
    DISPLAY=localhost:0.0
fi

