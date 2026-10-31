# Building and releasing

## Bootstrap guard

The template is version `0.0.0` and must not be published as a working library.
There is no worker implementation or complete user manual. The release workflow
is disabled unless repository variable `PYPI_PUBLISH_ENABLED` equals `true`, and
rejects `0.0.0` even when enabled. Keep it disabled until release readiness is reviewed.

## One-time GitHub and PyPI setup

1. The source repository is [AndreaBellomia/jet-worker](https://github.com/AndreaBellomia/jet-worker).
   Verify ownership of the
   `jet-worker` distribution name on both PyPI and TestPyPI. Availability is not assumed.
2. Create `testpypi` and `pypi` GitHub environments. Configure required reviewers for
   `pypi`, prevent self-review where available, and restrict deployment to release tags.
   Workflow YAML cannot enforce environment protection; verify these settings in GitHub.
3. Register separate Trusted Publishers on TestPyPI and PyPI with the exact GitHub
   owner, repository, workflow filename `release.yml`, and corresponding environment.
   Do not store long-lived PyPI tokens. Publishing jobs receive OIDC permission only.
4. Configure main-branch protection/rulesets to require pull requests, maintainer
   review, and `Quality gates`. Protect release tags from unauthorized creation.
   Enable private vulnerability reporting.
5. Complete the actual worker contracts, tests, and user manual before enabling
   `PYPI_PUBLISH_ENABLED=true`. Verify GitHub plan support for environment reviewers.

Repository URLs point to the actual GitHub project. Add PyPI project links only after
distribution ownership is verified; publication and name availability are not assumed.

## Build and inspect locally

```sh
make check
make integration
make integration-cluster
make security
make build
```

All Python commands run in Docker. `dist/` contains a wheel and source distribution.
Twine validates their descriptions and metadata. An isolated temporary environment
installs the wheel with no dependencies and checks its import and typing marker.
Once runtime dependencies exist, adjust this smoke check to install those dependencies
and exercise a representative public API as well.

## Release procedure

Agree the release scope and version. Use canonical PEP 440 versions (`1.2.0`,
`1.2.0rc1`) and matching `v` tags. Follow semantic versioning for the future public
API; document breaking changes and migrations. Update `project.version` through a
reviewed pull request, refresh uv.lock with `make lock`, and update CHANGELOG.md and
the user manual. There is one version source: pyproject.toml; the package reads
installed distribution metadata.

After the release commit is merged and its checks are green, inspect the exact
commit and create a tag. The following is an example for an agreed `0.1.0` release,
not a command to run on the bootstrap template:

```sh
git switch main
git pull --ff-only
git status --short
git tag -a v0.1.0 -m 'Release 0.1.0'
git push origin v0.1.0
```

Do not proceed with a dirty checkout. A protected tag triggers full checks against
that commit, including both Python versions, NATS integration, CVE scans, and build.
The workflow uses the verified Python 3.13 distributions for both publishing jobs;
it does not rebuild between registries. TestPyPI publishes first, then the `pypi`
environment waits for its configured approval. Inspect the TestPyPI artifacts and
release evidence before approving. PyPA's action uses Trusted Publishing and its
default attestations.

After publishing, verify the index metadata, artifact hashes, installation, and a
documented user example from outside the source checkout. Create release notes
through the repository's normal review process. Never overwrite a published version
or move an existing release tag. Investigate partial uploads before retrying; do not
add blanket `skip-existing` to conceal inconsistent artifacts. For a bad release,
review yanking and publish a new version with a documented correction.
