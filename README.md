# jet-worker

Repository foundation for a future Python NATS JetStream worker library.
**Template only:** there is no worker implementation, supported API, or CLI yet.
Version `0.0.0` is a bootstrap marker, not a release intended for PyPI.

The template includes uv packaging, Python 3.13/3.14 checks, Ruff, strict mypy,
pytest with at least 80% branch-aware coverage, Docker development, NATS single-node
and scalable cluster environments, Trivy scans, and guarded GitHub Actions publishing.

## Get started

Install Docker with Compose v2; Make is optional. No Python or uv installation is
needed on the host. Run all project code and tooling in containers.

```sh
make check
make integration
make integration-cluster
```

The integration checks use isolated disposable broker projects. For an interactive
broker or cluster:

```sh
make broker
make down
make cluster NODES=3
make down
```

Use VS Code's **Reopen in Container** for Python editor features. Once a worker entry
point exists, `WORKER_COMMAND='python -m your_entry_point' make dev` runs it in a
container and restarts it when Python files in the shared `src` volume change.
Until then `make dev` intentionally reports the missing entry point.

## Documentation

- [Contributor guide](CONTRIBUTING.md) and [agent instructions](AGENTS.md).
- [Developer setup](docs/development/setup.md).
- [Engineering standards](docs/development/engineering.md) and [testing policy](docs/development/testing.md).
- [Open architectural decisions](docs/development/architecture.md).
- [Primary reference reading](docs/development/references.md).
- [Release guide](docs/development/releasing.md) and [user manual](docs/user/README.md).
- [Security](SECURITY.md), [changelog](CHANGELOG.md), and [Apache 2.0 license](LICENSE).

PyPI project ownership, GitHub environments, and required-check rules
must be configured by the maintainer before releasing. See the release guide.
