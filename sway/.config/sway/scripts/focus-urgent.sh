#!/usr/bin/env bash
set -euo pipefail

iter_urgent_ids() {
  swaymsg -mt subscribe '["window"]' | jq --unbuffered '
    select(
      .change == "urgent"
      and .container.urgent == true
      and .container.focused == false
    ).container.id
  '
}

focus_container() {
  swaymsg "[con_id=$1] focus"
}

iter_urgent_ids | while read container_id; do
  focus_container $container_id
done
