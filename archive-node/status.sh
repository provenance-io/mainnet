#!/bin/bash

get_latest_block_height() {
  curl -s "http://localhost:26657/status" | jq -r '.result.sync_info.latest_block_height'
}

get_correct_current_upgrade() {
  local block_height=$1
  jq -r --argjson height "$block_height" '
    .upgrades
    | map(select(.height <= $height))
    | sort_by(.height)
    | reverse
    | map(select(.height <= $height))
    | .[0]
  ' upgrades.json
}

get_next_upgrade() {
  local block_height=$1
  jq -r --argjson height "$block_height" '
    .upgrades
    | map(select(.height > $height))
    | sort_by(.height)
    | first
  ' upgrades.json
}

start_time=$(date +"%Y-%m-%d %H:%M:%S")
start_time_unix=$(date +%s)
initial_height=$(get_latest_block_height)

sleep 10

end_time=$(date +"%Y-%m-%d %H:%M:%S")
end_time_unix=$(date +%s)
final_height=$(get_latest_block_height)

block_difference=$((final_height - initial_height))

if [ "$block_difference" -eq 0 ]; then
  echo "No blocks ingested. Exiting."
  exit 1
fi

blocks_per_second=$(echo "scale=2; $block_difference / 10" | bc)
blocks_per_minute=$(echo "scale=2; $blocks_per_second * 60" | bc)
blocks_per_hour=$(echo "scale=2; $blocks_per_minute * 60" | bc)

current_upgrade=$(get_correct_current_upgrade "$final_height")
next_upgrade=$(get_next_upgrade "$final_height")

current_upgrade_name=$(echo "$current_upgrade" | jq -r '.name')
current_upgrade_tag=$(echo "$current_upgrade" | jq -r '.tag')
current_upgrade_height=$(echo "$current_upgrade" | jq -r '.height')

next_upgrade_name=$(echo "$next_upgrade" | jq -r '.name')
next_upgrade_tag=$(echo "$next_upgrade" | jq -r '.tag')
next_upgrade_height=$(echo "$next_upgrade" | jq -r '.height')

if [ "$next_upgrade_height" != "null" ]; then
  blocks_until_next_upgrade=$((next_upgrade_height - final_height))

  if [ "$blocks_until_next_upgrade" -eq 0 ]; then
    echo "No blocks left until next upgrade. Exiting."
    exit 0
  fi

  seconds_until_next_upgrade=$(echo "$blocks_until_next_upgrade / $blocks_per_second" | bc)

  estimated_next_upgrade_unix=$((end_time_unix + seconds_until_next_upgrade))
  estimated_next_upgrade_time=$(date -d @"$estimated_next_upgrade_unix" +"%Y-%m-%d %H:%M:%S")

  minutes_until_next_upgrade=$(echo "$seconds_until_next_upgrade / 60" | bc)
else
  estimated_next_upgrade_time="N/A"
  minutes_until_next_upgrade="N/A"
fi

echo "Start block height: $initial_height at $start_time"
echo "End block height: $final_height at $end_time"
echo "Blocks ingested per second: $blocks_per_second"
echo "Blocks ingested per minute: $blocks_per_minute"
echo "Blocks ingested per hour: $blocks_per_hour"
echo "Current upgrade: $current_upgrade_name (Tag: $current_upgrade_tag, Height: $current_upgrade_height)"
if [ "$next_upgrade_height" != "null" ]; then
  echo "Next upgrade: $next_upgrade_name (Tag: $next_upgrade_tag, Height: $next_upgrade_height)"
  echo "Blocks left until next upgrade: $blocks_until_next_upgrade"
  echo "Total minutes until next upgrade: $minutes_until_next_upgrade minutes"
  echo "Estimated time of next upgrade: $estimated_next_upgrade_time"
else
  echo "No upcoming upgrades found."
fi

