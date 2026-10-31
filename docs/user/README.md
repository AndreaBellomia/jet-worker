# User manual

## Current availability

jet-worker is currently a repository template. No worker API, CLI, delivery guarantees,
or production release is available. Do not install a similarly named PyPI project on
the assumption it belongs to this repository; project ownership is not configured yet.

Python 3.13 and 3.14 are the intended tested versions. The future distribution is
named `jet-worker` and its Python import is `jet_worker`. Source is licensed under
Apache 2.0. [Developer setup](../development/setup.md) describes running the template.

## Before the first usable release

The user manual must be completed alongside the first implementation, using verified
examples that run against the released wheel. It must cover:

1. Installation from the verified project and supported Python/NATS versions.
2. A minimal real handler and startup/shutdown example.
3. Configuration, credentials/TLS, and stream/consumer provisioning ownership.
4. Acknowledgment, retries, redelivery, idempotency, and failure behavior.
5. Concurrency, backpressure, shutdown deadlines, and operational visibility.
6. Single-node and cluster deployment, persistence, and replication limits.
7. Troubleshooting, upgrades, compatibility, and security reporting.

Do not document guessed APIs as working features. The release workflow refuses the
bootstrap version and requires a maintainer-enabled release setting.
