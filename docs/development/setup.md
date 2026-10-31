# Developer setup

## Requirements and first checks

Use Docker with Compose v2 and a POSIX shell. Make is a convenience wrapper; open
the Makefile for equivalent Docker commands. Python, uv, NATS, test dependencies,
and the worker run inside containers. Do not create a host virtual environment.

```sh
make check
make integration
make integration-cluster
```

`make check` builds the development image, syncs the committed lock, and runs all
local quality gates. `PYTHON_VERSION=3.14 make check` selects the second supported
Python version. The image explicitly selects its own interpreter and disables uv
Python downloads, so `.python-version` cannot silently collapse the CI matrix.
Only Docker/Make orchestration runs on the host. The development image uses Alpine
and runs as a user mapped to the host UID/GID by Make (or Dev Containers on Linux).

## Editor and shell

Open the repository in VS Code and select **Dev Containers: Reopen in Container**.
The container provides `/home/app/.venv/bin/python`, Ruff, and pytest. `.editorconfig`
also supplies editor-independent whitespace rules. Other editors can attach to the
same container or use `make shell`. Editor settings are intended for the container,
not a host interpreter. The source bind mount shares edits without rebuilding.

## Broker topologies

`make broker` starts one persistent JetStream server. `make cluster NODES=3` starts
the seed plus two replicas; use `NODES=5` for a larger local topology. The seed
uses a stable server name and the scaled service uses unique container hostnames.
All nodes use the same cluster name and replicas discover peers through the seed.
No coordinator or Docker socket mount is required.

Single-node mode has no cluster configuration. `compose.cluster.yaml` adds routes
and the scalable peer service. To change topology,
run `make down` before starting the next topology. Restarting servers does not
change a stream's replication factor. Prefer odd counts of at least three for
quorum experiments. More nodes do not automatically increase stream replicas.

Data for the seed lives in a named volume; replica data uses one anonymous volume
per container. `make down` preserves volumes. Removing/replacing scaled containers
can orphan their anonymous volumes; this is local tooling, not production cluster
management. `docker compose -f compose.yaml -f compose.cluster.yaml --profile cluster down --volumes` deletes local broker
data. Do not use it when the data is needed. Test scripts delete only the unique
temporary project they create.

Ports are private to the Compose network. Access the broker from the editor/worker
at `nats://nats:4222`, monitoring at `http://nats:8222`. To inspect readiness:

```sh
docker compose exec nats wget -qO- http://127.0.0.1:8222/healthz
docker compose exec nats wget -qO- http://127.0.0.1:8222/routez
```

This topology has no auth/TLS and runs on one host. Do not deploy it as production
infrastructure. Replication, failover, and production security require explicit design.

## Worker development in watch mode

The template does not pretend to implement a worker. After an entry point is added:

```sh
WORKER_COMMAND='python -m your_entry_point' make dev
```

The `worker` service waits for NATS and runs watchfiles on shared `src` files.
The watcher starts/restarts the command inside Docker. For a running cluster:

```sh
make cluster NODES=3
COMPOSE_FILE=compose.yaml:compose.cluster.yaml NATS_EXPECTED_NODES=3 WORKER_COMMAND='python -m your_entry_point' make dev
```

Use `WATCHFILES_FORCE_POLLING=true` inside the worker environment if filesystem
notifications are unreliable in a particular Docker environment. Configuration or
dependency changes require a service restart; Python source changes do not.

## Dependencies and security

Edit dependency declarations and run `make lock` (a dedicated uv container), then rebuild
with `make check`. For an intentional upgrade, run `uv lock --upgrade` inside a uv
container and review the diff. `uv sync --locked` never silently rewrites the lock.

`make security` scans the repository lock, secrets, development image, and NATS image.
CI runs the same command. Network access is needed for images, dependencies,
and fresh vulnerability databases. A failed database download is a failure, not a
clean scan. JSON reports are written to `reports/trivy-*.json` and uploaded by CI;
the scanner database is cached in the `jet-worker-trivy-cache` Docker volume.
No developer tooling or broker credentials are embedded in a release wheel.
