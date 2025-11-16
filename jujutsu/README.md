## local overrides

You can override Jujutsu config for a particular machine by adding configuration files to `~/.config/jj/conf.d` directory, which is automatically included in alphabetical order.

- https://jj-vcs.github.io/jj/latest/config/#ways-to-specify-jj-config-details

### per-directory overrides

If you want to change some configuration for a particular directory tree, you can add a conditional config, e.g. if you wanted to change the email address to your work address for a work directory:

```toml
# ~/.config/jj/conf.d/work.toml
--when.repositories = ["~/work"]

[user]
email = "user@work.com"
```

- https://jj-vcs.github.io/jj/latest/config/#conditional-variables
