#!/bin/sh

while read p; do
  code --install-extension "$p"
done < $HOME/.config/Code/User/extensions.txt
