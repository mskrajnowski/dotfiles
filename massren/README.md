# massren

https://github.com/laurent22/massren

## Editor setup

Sadly massren stores its configuration in a SQLite database, along with history of renames for undo.

That means you have to run

```sh
massren --config editor 'code -w'
```

to setup VSCode as the editor.

https://github.com/laurent22/massren/issues/5
