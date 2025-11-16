## local overrides

You can override Git config for a particular machine by creating a `~/.config/git/config.local` file, which is included by the main configuration.

### per-directory overrides

If you want to change some configuration for a particular directory tree, you can add a conditional include section, e.g. if you wanted to change the email address to your work address for a work directory:

```ini
# ~/.config/git/config.local
[includeIf "gitdir:~/work/"]
path = ~/work/.gitconfig

# ~/work/.gitconfig
[user]
email = "user@work.com"
```
