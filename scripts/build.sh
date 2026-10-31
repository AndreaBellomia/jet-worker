#!/bin/sh
set -eu
rm -f dist/*.whl dist/*.tar.gz
uv build --out-dir dist
twine check --strict dist/*
sh scripts/wheel-smoke.sh
