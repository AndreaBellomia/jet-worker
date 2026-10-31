#!/bin/sh
# Run on the host: all Python and NATS execution happens inside Docker.
set -eu
export LOCAL_UID="${LOCAL_UID:-$(id -u)}"
export LOCAL_GID="${LOCAL_GID:-$(id -g)}"
nodes=${1:-1}
case "$nodes" in
  1|3) ;;
  *) echo 'Usage: sh scripts/run-integration.sh [1|3]' >&2; exit 2 ;;
esac
export NATS_EXPECTED_NODES="$nodes"
export NATS_REPLICAS="$nodes"
export COMPOSE_PROJECT_NAME="jet-worker-test-${nodes}-$$"
export COMPOSE_FILE=compose.yaml
if [ "$nodes" -eq 3 ]; then
  COMPOSE_FILE=compose.yaml:compose.cluster.yaml
fi
cleanup() {
  result=$?
  if [ "$result" -ne 0 ]; then
    docker compose --profile cluster logs --no-color
  fi
  docker compose --profile cluster down --volumes --remove-orphans
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
if [ "$nodes" -eq 1 ]; then
  docker compose up -d --wait nats
else
  docker compose --profile cluster up -d --wait --scale nats-node=2 nats nats-node
fi
docker compose run --build --rm tests
