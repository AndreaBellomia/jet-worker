#!/bin/sh
set -eu
python tools/wait_for_nats.py
exec pytest -m integration
