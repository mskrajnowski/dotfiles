#!/usr/bin/env bash
set -euo pipefail

iter_focused_app_ids() {
  swaymsg -mt subscribe '["window"]' | jq --unbuffered -r '
    select(
      .change == "focus"
      and .container.focused == true
    ).container.app_id
  '
}

iter_focused_app_ids | while read app_id; do
  case "$app_id" in
    Alacritty)
      swaymsg unbindsym "$1" || true ;;
    *)
      swaymsg bindsym "$@"
  esac
done
