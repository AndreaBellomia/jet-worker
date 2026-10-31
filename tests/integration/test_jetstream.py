"""Exercise the broker contract; this does not implement or test a worker."""

import asyncio
import os
from uuid import uuid4

import nats
import pytest
from nats.js.api import AckPolicy, ConsumerConfig, StorageType
from nats.js.errors import ServiceUnavailableError

pytestmark = pytest.mark.integration


async def test_replicated_publish_consume_and_acknowledge() -> None:
    """Publish durably, fetch through a durable consumer, and confirm its ack."""
    replicas = int(os.environ["NATS_REPLICAS"])
    connection = await nats.connect(os.environ["NATS_URL"], connect_timeout=5)
    stream = f"SMOKE_{uuid4().hex}"
    subject = f"smoke.{uuid4().hex}"
    jetstream = connection.jetstream(timeout=5)
    created = False
    try:
        async with asyncio.timeout(60):
            while True:
                try:
                    await jetstream.add_stream(
                        name=stream,
                        subjects=[subject],
                        storage=StorageType.FILE,
                        num_replicas=replicas,
                    )
                    created = True
                    break
                except ServiceUnavailableError:
                    # Route health can precede JetStream meta leader election.
                    await asyncio.sleep(0.25)
        subscription = await jetstream.pull_subscribe(
            subject,
            durable="smoke",
            stream=stream,
            config=ConsumerConfig(ack_policy=AckPolicy.EXPLICIT),
        )
        acknowledgment = await jetstream.publish(subject, b"template-smoke-test")
        assert acknowledgment.stream == stream
        messages = await subscription.fetch(1, timeout=10)
        assert len(messages) == 1
        assert messages[0].data == b"template-smoke-test"
        await messages[0].ack_sync(timeout=5)
        consumer = await jetstream.consumer_info(stream, "smoke")
        assert consumer.num_ack_pending == 0
        info = await jetstream.stream_info(stream)
        assert info.config.num_replicas == replicas
        if replicas > 1:
            assert info.cluster is not None
            assert info.cluster.replicas is not None
            assert len(info.cluster.replicas) == replicas - 1
        await subscription.unsubscribe()
    finally:
        try:
            if created:
                await jetstream.delete_stream(stream)
        finally:
            await connection.close()
