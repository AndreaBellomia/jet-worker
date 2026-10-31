# Contributing

Read [AGENTS.md](AGENTS.md) and the [developer setup](docs/development/setup.md).
Repository content must be in English. Use Docker for all Python execution; only Git,
Docker Compose, a POSIX shell, and optionally Make are needed on the host.

Before implementing a change, establish its observable behavior and relevant failure
modes. For consequential ambiguity, discuss the missing decision with the maintainer.
A short plan is enough for small changes. Use an ADR for lasting architectural choices;
the [ADR template](docs/decisions/template.md) records context and alternatives.

Keep pull requests focused. Include the problem, resulting behavior, verification,
and any remaining risk. Add tests where they protect meaningful contracts; maintain
at least 80% branch-aware package coverage. Update documentation alongside changes.

Run `make check`, applicable integration suites, and `make security` before submitting.
If a check cannot run, report the reason. Never replace evidence with a claim that CI
will probably pass. Do not commit credentials, generated environments, or test broker data.

Use [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/)
for every commit, with an English imperative description:

```text
<type>[optional scope][!]: <description>
```

Use `feat` for new behavior and `fix` for bug fixes. Other useful types are `docs`,
`test`, `refactor`, `perf`, `build`, `ci`, `chore`, `style`, and `revert`. Choose a
scope only when it clarifies the affected area. Mark breaking changes with `!` or
a `BREAKING CHANGE:` footer and explain the compatibility impact. For example:

```text
chore(repo): initialize the repository template
fix(consumer): preserve cancellation during shutdown
```

Keep each commit focused. When squash merging, use a Conventional Commit message
for the resulting commit as well.

Changes to public APIs, delivery guarantees, release controls, or security boundaries
need explicit rationale and maintainer review. By contributing, you agree your
contribution is licensed under the repository's Apache License 2.0.
