#!/bin/sh
set -eu
smoke_dir=$(mktemp -d)
trap 'rm -rf "$smoke_dir"' EXIT HUP INT TERM
uv venv "$smoke_dir/venv"
uv pip install --python "$smoke_dir/venv/bin/python" --no-deps dist/*.whl
# Isolated mode prevents the checkout or PYTHONPATH from satisfying the import.
"$smoke_dir/venv/bin/python" -I -c 'from importlib.metadata import metadata; from importlib.resources import files; import jet_worker; assert jet_worker.__version__ == metadata("jet-worker")["Version"]; assert files(jet_worker).joinpath("py.typed").is_file()'
