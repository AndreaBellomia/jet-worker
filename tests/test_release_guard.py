"""Prevent publishing the bootstrap package or a mismatched release version."""

import runpy
from pathlib import Path

import pytest

VALIDATOR = Path(__file__).resolve().parents[1] / "tools" / "validate_release.py"


@pytest.mark.parametrize(
    ("version", "tag", "message"),
    [
        ("0.0.0", "v0.0.0", "non-bootstrap"),
        ("1.2.0", "v1.2.1", "exact project version"),
        ("1.2.0", "1.2.0", "exact project version"),
        ("1.2.0+local", "v1.2.0+local", "local version identifiers"),
    ],
)
def test_unsafe_release_is_rejected(
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
    version: str,
    tag: str,
    message: str,
) -> None:
    """A release requires both an intentional version and its matching tag."""
    (tmp_path / "pyproject.toml").write_text(f'[project]\nversion = "{version}"\n')
    monkeypatch.chdir(tmp_path)
    monkeypatch.setenv("RELEASE_TAG", tag)
    with pytest.raises(ValueError, match=message):
        runpy.run_path(str(VALIDATOR), run_name="__main__")


def test_matching_prerelease_is_accepted(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    """Canonical PEP 440 pre-releases can be sent through the guarded workflow."""
    (tmp_path / "pyproject.toml").write_text('[project]\nversion = "1.2.0rc1"\n')
    monkeypatch.chdir(tmp_path)
    monkeypatch.setenv("RELEASE_TAG", "v1.2.0rc1")
    runpy.run_path(str(VALIDATOR), run_name="__main__")
