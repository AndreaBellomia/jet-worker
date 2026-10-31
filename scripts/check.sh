#!/bin/sh
set -eu
ruff check .
ruff format --check .
mypy
pytest -m 'not integration' --cov --cov-report=term-missing --cov-report=xml:reports/coverage.xml
sh scripts/build.sh
