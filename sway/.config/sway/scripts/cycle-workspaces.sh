#!/usr/bin/env bash
# Usage:
#   cycle-workspaces.sh next|prev
#
# Requires:
# - swaymsg
# - jq

WORKSPACE_COUNT=8

workspace_num() {
  swaymsg -t get_workspaces | jq -r '.[] | select(.focused).num'
}

next() {
  local current=$(workspace_num)
  local next=$(( current + 1 <= WORKSPACE_COUNT ? current + 1 : WORKSPACE_COUNT ))
  swaymsg "workspace number $next"
}

prev() {
  local current=$(workspace_num)
  local prev=$(( current - 1 >= 1 ? current - 1 : 1 ))
  swaymsg "workspace number $prev"
}

case "$1" in
  next) next ;;
  prev) prev ;;
  *) exit 1 ;;
esac
