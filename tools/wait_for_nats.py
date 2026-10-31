"""Wait for a local broker and the requested number of route peers."""

import json
import os
import time
from urllib.error import URLError
from urllib.parse import urlparse
from urllib.request import urlopen


def wait_for_nats() -> None:
    """Bound startup latency and verify the requested cluster membership."""
    monitor = os.environ["NATS_MONITOR_URL"].rstrip("/")
    if urlparse(monitor).scheme != "http":
        raise ValueError("The local NATS monitor must use HTTP")
    expected = int(os.environ.get("NATS_EXPECTED_NODES", "1"))
    if expected < 1:
        raise ValueError("NATS_EXPECTED_NODES must be positive")
    deadline = time.monotonic() + 60
    last_error = "Broker is not ready"
    while time.monotonic() < deadline:
        try:
            # Only the validated local HTTP monitor URL is used here.
            with urlopen(f"{monitor}/healthz", timeout=2) as response:  # noqa: S310
                if response.status != 200:
                    raise ValueError("Broker health check failed")
            with urlopen(f"{monitor}/routez", timeout=2) as response:  # noqa: S310
                routes = json.load(response)["routes"]
            peers = {route["remote_id"] for route in routes}
            if len(peers) + 1 == expected:
                return
            last_error = f"Expected {expected} nodes; observed {len(peers) + 1}"
        except (URLError, TimeoutError, ValueError, KeyError) as error:
            last_error = str(error)
        time.sleep(0.25)
    raise TimeoutError(f"NATS readiness timed out: {last_error}")


if __name__ == "__main__":
    wait_for_nats()
