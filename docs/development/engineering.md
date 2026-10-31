# Engineering standards

## Python and public contracts

Follow PEP 8, PEP 257, PEP 484, PEP 526, PEP 585, PEP 604, and PEP 695 where supported
by the minimum Python version. Ruff owns formatting (88 columns), import order, naming,
and selected correctness/security checks; do not duplicate its formatter with another.
Use PEP 621 project metadata, PEP 639 license metadata, PEP 517 builds, and PEP 561's
`py.typed` marker. Core metadata stays at version 2.4 for consumer-tool compatibility.
Strict mypy checks source, tooling, and tests.

Type public boundaries and nontrivial helpers. Prefer `collections.abc` interfaces,
`pathlib.Path`, timezone-aware UTC datetimes, and specific exception types. Avoid `Any`
at domain boundaries, mutable defaults, implicit globals, import-time I/O, and broad
type suppressions. Explain unavoidable local suppressions. Validate untrusted inputs
at the boundary; do not validate the same invariant at every internal call.

Document public behavior, exceptions, ownership, and cancellation where relevant.
Comments explain intent or constraints, not a paraphrase of the next line.
Keep implementation details private until a public contract is designed.

## Design and dependencies

Prefer the simplest design that satisfies current requirements. Apply SOLID as a
reasoning aid rather than a demand for interfaces around every class. Keep NATS I/O,
application orchestration, and user business handlers separable when implementation
begins. Inject resources explicitly; resource owners open and close them.

The Refactoring.Guru catalog is a vocabulary, not a mandatory inventory. Consider
Strategy for genuinely interchangeable policies, Adapter at external boundaries,
and a context manager for resource lifetimes. Use a callable instead of a class when
it is sufficient. Avoid speculative factories, repositories, service locators,
singletons, inheritance hierarchies, and generic event frameworks. Record why a
pattern helps and what complexity it introduces when a choice is consequential.

No runtime dependencies are added to the template. `nats-py` currently belongs to
the integration-test dependency group; promote it to runtime dependencies only when
the library actually uses it. Avoid freezing consumers to the entire development lock.

## Async and operational behavior

Use structured concurrency and bounded work when worker semantics have been agreed.
Never perform blocking I/O on the event loop. Preserve cancellation, set intentional
timeouts, and clean up resources with context managers or `finally` blocks.
Do not assume transport reconnect implies successful processing. Distinguish broker
delivery from durable business effects and document idempotency responsibilities.

Use structured, actionable logs without payloads or secrets by default. Add metrics
only for an operational question. Avoid high-cardinality labels. Logging and telemetry
configuration belongs to the hosting application, not import-time library code.

## Dependency and security maintenance

Review direct/transitive dependency changes with their lockfile diff. Use exact uv,
NATS, and Trivy image versions and immutable GitHub Action commits. Image tags are
version-pinned, not immutable digests; review/pin digests before production deployment.
Keep workflows minimally privileged and credentials out of images. Trivy blocks HIGH
and CRITICAL vulnerabilities, including unfixed findings, and detects secrets.
An exception needs maintainer agreement, a specific advisory, rationale, and expiry;
there are no blanket CVE exclusions in this template.
