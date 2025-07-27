set -g fish_greeting
set -gxp PATH ~/.local/bin

if status is-interactive
  # Commands to run in interactive sessions can go here
  if command -q mise
    mise activate fish | source
  end

  if command -q starship
    starship init fish | source
  end

  function random-string
    set size 32

    if set -q argv[1]
      set size $argv[1]
    end

    openssl rand -base64 1024 \
      | tr -dc 'a-zA-Z0-9' \
      | fold -w $size \
      | head -n 1
  end

  function uuid4
    python -c "import uuid; print(uuid.uuid4())"
  end
end
