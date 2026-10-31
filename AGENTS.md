# Working in this repository

## Scope and judgment

This repository currently provides a Python library template, not a worker implementation.
All code, documentation, comments, identifiers, and repository instructions must be in English.
Read README.md and the relevant developer documents before changing files.

Understand the requested outcome, inspect existing contracts, and outline the smallest
coherent change before coding. Scale design effort to risk. Routine, reversible changes
do not need a formal approval ceremony. Ask the user about ambiguity that affects public
APIs, delivery guarantees, persistence, security, compatibility, or release behavior.
Continue independent work while waiting; do not silently invent those requirements.
Do not expand the task into a framework or launch parallel agents without authorization.

## Engineering

- Use Python 3.13-compatible syntax; CI also validates Python 3.14.
- Use uv and commit uv.lock. Run development, tests, and builds in Docker; do not
  install project dependencies or start the worker on the developer's host.
- Keep the src layout. Add modules when responsibilities exist, not to fill a diagram.
- Follow docs/development/engineering.md and docs/development/testing.md.
- Prefer explicit dependencies, small cohesive functions, typed boundaries, and composition.
- Use design patterns only for a demonstrated problem and explain the tradeoff.
- Never hide exceptions, swallow cancellation, block the event loop, or log credentials.
- Do not decide acknowledgment, retries, dead letters, idempotency, stream ownership,
  or concurrency semantics without resolving docs/development/architecture.md first.

## Verification

Use `make check` for lint, formatting, strict typing, tests with branch coverage >=80%,
distribution build, metadata checks, and installed-wheel smoke verification. Use
`make integration` and `make integration-cluster` when changing NATS interactions or
orchestration. Use `make security` for dependency and secret scanning.

Test observable contracts and credible failures. Avoid mocks of NATS internals,
implementation-shaped assertions, trivial getter tests, arbitrary sleeps, and tests
added only to raise coverage. Never weaken gates or omit executable production code
from coverage to pass CI. The initial metadata test only validates the package template;
its coverage is not evidence of a reliable worker.

Update relevant developer/user docs and CHANGELOG.md when behavior changes. Report
what changed, checks actually run, failures, and limitations. Never claim a skipped or
unavailable check passed. Do not publish packages or push release tags unless requested.
Use Conventional Commits 1.0.0 for every commit, as described in CONTRIBUTING.md.
Commit descriptions, bodies, and footers must be in English.

## Reference map

- docs/development/setup.md: Docker workflows and editor setup.
- docs/development/engineering.md: implementation and style decisions.
- docs/development/testing.md: proportional test strategy and gates.
- docs/development/architecture.md: unresolved worker contracts.
- docs/development/references.md: primary documentation, with reading guidance.
- docs/development/releasing.md: build and PyPI release procedure.
- docs/user/README.md: honest user-facing status and future manual structure.
