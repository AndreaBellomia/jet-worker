"""Reject accidental template releases and mismatched release tags."""

import os
import tomllib
from pathlib import Path

from packaging.version import Version


def validate_release() -> None:
    """Require an explicit version and a matching canonical PEP 440 tag."""
    project = tomllib.loads(Path("pyproject.toml").read_text())["project"]
    version = project["version"]
    parsed = Version(version)
    if parsed == Version("0.0.0") or str(parsed) != version:
        raise ValueError("Choose a non-bootstrap, canonical PEP 440 version")
    if parsed.local is not None:
        raise ValueError("PyPI does not accept local version identifiers")
    if os.environ["RELEASE_TAG"] != f"v{version}":
        raise ValueError("Release tag must be v followed by the exact project version")


if __name__ == "__main__":
    validate_release()
