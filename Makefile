.PHONY: help check config-check format integration integration-cluster broker cluster down dev shell lock build security
NODES ?= 3
export LOCAL_UID := $(shell id -u)
export LOCAL_GID := $(shell id -g)

help:
	@echo 'check format integration integration-cluster broker cluster NODES=3 down dev shell lock build security'

check: config-check
	docker compose run --build --rm tools sh scripts/check.sh

config-check:
	docker compose config --quiet
	docker compose -f compose.yaml -f compose.cluster.yaml --profile cluster config --quiet
	docker run --rm -v "$(CURDIR):/repo:ro" -w /repo rhysd/actionlint:1.7.7
	docker run --rm -v "$(CURDIR):/repo:ro" -w /repo koalaman/shellcheck:v0.11.0 scripts/*.sh

format:
	docker compose run --build --rm tools sh -ec 'ruff check --fix . && ruff format .'

integration:
	sh scripts/run-integration.sh 1

integration-cluster:
	sh scripts/run-integration.sh 3

broker:
	docker compose up -d --wait nats

cluster:
	@case '$(NODES)' in ''|*[!0-9]*|0|1) echo 'NODES must be an integer >=2' >&2; exit 2;; esac
	docker compose -f compose.yaml -f compose.cluster.yaml --profile cluster up -d --wait --scale nats-node=$$(( $(NODES) - 1 )) nats nats-node

down:
	docker compose -f compose.yaml -f compose.cluster.yaml --profile cluster --profile dev --profile editor down --remove-orphans

dev:
	docker compose --profile dev up --build worker

shell:
	docker compose run --build --rm tools sh

lock:
	docker run --rm --user "$(LOCAL_UID):$(LOCAL_GID)" -e UV_CACHE_DIR=/tmp/uv-cache -e UV_PYTHON=/usr/local/bin/python -e UV_PYTHON_DOWNLOADS=never -v "$(CURDIR):/app" -w /app ghcr.io/astral-sh/uv:0.13.6-python3.13-alpine3.23 uv lock

build:
	docker compose run --build --rm tools sh scripts/build.sh

security:
	sh scripts/security.sh
