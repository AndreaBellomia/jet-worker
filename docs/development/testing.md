# Testing and quality gates

## Test the right behavior

Use pytest. Choose tests from the change's contracts, consequences, and credible
failure modes. Prefer a few focused cases that explain the behavior to repetitive
matrices. Parameterize only when the cases share a meaningful contract.

- Unit tests cover decisions, validation, error translation, and isolated business behavior.
- Integration tests exercise a real NATS server for persistence, consumers, and acknowledgments.
- Cluster smoke tests verify the requested topology and replicated publication; they do
  not establish failover guarantees. Add bounded fault tests when failover is implemented.
- Distribution checks build wheel and sdist, check metadata, install the wheel outside
  the checkout, and verify import/version/typing metadata.

Use fresh subjects/stream names and deterministic teardown. Use bounded polling of
observable readiness instead of arbitrary sleeps. Fake external business effects at
owned boundaries; do not mock nats-py internals to claim transport correctness.
Do not test Python itself, mirror private call order, assert incidental log wording,
or write one test per property just to raise coverage.

When behavior arrives, evaluate malformed messages, duplicate delivery, handler
failure, cancellation, disconnect, timeout, concurrency limits, and drain. Choose
cases relevant to that change; not every pull request needs the entire list.

## Enforced gates

`make check` validates both Compose topologies, workflows with actionlint, shell
scripts with ShellCheck, Ruff lint and format checks, strict mypy, pytest with branch-aware
coverage and `fail_under = 80`, builds, Twine metadata validation, and wheel smoke checks.
Coverage includes the entire `src/jet_worker` tree, including unimported files.
The percentage combines line and branch opportunities; it is not a separate 80%
threshold on each metric. Inspect uncovered branches during review.

Coverage is a floor, not a target. Do not omit production modules, add unjustified
`pragma: no cover`, weaken the threshold, or substitute assertions for useful tests.
The template's package metadata test provides only bootstrap coverage. It does not
test any worker, because no worker exists yet.

`make integration` tests a disposable single-node broker. `make integration-cluster`
tests three nodes with stream replication set to three. Both run in isolated Compose
projects and delete only their own temporary volumes on exit. Integration tests fail
if their required environment is absent; they must not silently pass via skips.

GitHub Actions repeats tests on Python 3.13 and 3.14, exercises single-node and cluster
integration, scans the lockfile and the development/NATS images with Trivy, and
builds artifacts. `Quality gates` aggregates these jobs. Configure it as a required
check in a GitHub ruleset; a workflow file cannot enable branch protection itself.
