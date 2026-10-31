# Reference reading for contributors and agents

Reviewed for this template on 2026-10-31. Consult upstream documentation when changing
a tool or protocol contract; record the relevant version and re-check moved links.
These links are a reading guide, not vendored copies of upstream content.

| Topic | Primary source | Use it for |
| --- | --- | --- |
| Python style | [PEP 8](https://peps.python.org/pep-0008/), [PEP 257](https://peps.python.org/pep-0257/) | Naming, readability, and docstrings |
| Typing | [Python typing](https://docs.python.org/3/library/typing.html), [mypy](https://mypy.readthedocs.io/en/stable/) | Public contracts and strict static checks |
| Async | [asyncio](https://docs.python.org/3/library/asyncio.html) | Task lifetimes, cancellation, and timeouts |
| Packaging | [PEP 621](https://peps.python.org/pep-0621/), [PEP 639](https://peps.python.org/pep-0639/), [packaging guide](https://packaging.python.org/en/latest/) | Metadata, license expression, wheel/sdist |
| uv and Docker | [uv Docker guide](https://docs.astral.sh/uv/guides/integration/docker/) | Locked environments, bind mounts, and container-only execution |
| Ruff | [Ruff configuration](https://docs.astral.sh/ruff/configuration/) | Central lint/format settings |
| Testing | [pytest](https://docs.pytest.org/en/stable/), [coverage.py](https://coverage.readthedocs.io/en/latest/branch.html) | Fixtures, isolation, and branch coverage |
| Design | [Refactoring.Guru](https://refactoring.guru/design-patterns), [Python examples](https://refactoring.guru/design-patterns/python) | Compare applicable patterns and their costs |
| JetStream | [NATS learning guide](https://docs.nats.io/learn/), [JetStream concepts](https://docs.nats.io/nats-concepts/jetstream) | Streams, consumers, persistence, and delivery semantics |
| NATS clustering | [JetStream cluster](https://docs.nats.io/learn/topologies/jetstream-in-a-cluster) | Meta group, quorum, and stream replication |
| Python NATS client | [nats.py](https://github.com/nats-io/nats.py), [examples](https://github.com/nats-io/nats.py/tree/main/examples) | Actual client interfaces and lifecycle |
| Compose | [Startup order](https://docs.docker.com/compose/how-tos/startup-order/), [Compose CLI](https://docs.docker.com/reference/cli/docker/compose/up/) | Readiness and scaling |
| Vulnerabilities | [Trivy filesystem](https://trivy.dev/docs/latest/target/filesystem/), [Python coverage](https://trivy.dev/docs/latest/coverage/language/python/) | Lockfile and image CVE scanning |
| CI security | [GitHub secure use](https://docs.github.com/en/actions/reference/security/secure-use) | Immutable actions and least privilege |
| Publishing | [PyPI Trusted Publishing](https://docs.pypi.org/trusted-publishers/using-a-publisher/) | OIDC, environments, and attestations |

Start with the contract needed for the current task. Do not turn a catalog of patterns
or a list of possible failure modes into mandatory speculative implementation.
