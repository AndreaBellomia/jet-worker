#!/bin/sh
set -eu
: "${WORKER_COMMAND:?The template has no worker. Implement an entry point, then set WORKER_COMMAND.}"
python tools/wait_for_nats.py
exec watchfiles --filter python "$WORKER_COMMAND" src
