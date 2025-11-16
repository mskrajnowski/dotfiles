## Install

1. Download binaries from https://zed.dev/docs/linux#other-ways-to-install-zed-on-linux
2. Extract to `~/.local/zed.app`
3. Add `zed` to `$PATH`

  ```sh
  ln -sf ~/.local/zed.app/bin/zed ~/.local/bin/zed
  ```

4. Add desktop entry

  ```sh
  cp ~/.local/zed.app/share/applications/zed.desktop ~/.local/share/applications/dev.zed.Zed.desktop
  sed -i "s|Icon=zed|Icon=$HOME/.local/zed.app/share/icons/hicolor/512x512/apps/zed.png|g" ~/.local/share/applications/dev.zed.Zed.desktop
  sed -i "s|Exec=zed|Exec=$HOME/.local/zed.app/libexec/zed-editor|g" ~/.local/share/applications/dev.zed.Zed.desktop
  ```
