"""Verify the installed package contract rather than a future worker implementation."""

from importlib.metadata import metadata
from importlib.resources import files

import jet_worker


def test_installed_package_metadata() -> None:
    """The import, distribution version, license, and typing marker agree."""
    distribution = metadata("jet-worker")
    assert jet_worker.__version__ == distribution["Version"]
    assert distribution["License-Expression"] == "Apache-2.0"
    assert files(jet_worker).joinpath("py.typed").is_file()
