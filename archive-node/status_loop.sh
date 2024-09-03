#!/bin/bash

SCRIPT_PATH="./status.sh"

while true; do
  bash $SCRIPT_PATH
  EXIT_CODE=$?

  if [ $EXIT_CODE -ne 0 ]; then
    echo "An error occurred or no blocks left until next upgrade. Trying again in 60 seconds"
    sleep 60
  fi

  echo "###############"

  sleep 50
done

