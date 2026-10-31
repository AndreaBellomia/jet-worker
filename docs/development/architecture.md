# Worker design: decisions still open

Status: repository template only. There is no supported worker API or CLI.
Container tooling and broker integration checks are infrastructure, not a worker.

Before implementing the worker, resolve the relevant contracts with the maintainer:

| Area | Questions to resolve |
| --- | --- |
| Public interface | Embedded library, CLI, or both? Handler signature and configuration API? |
| Consumption | Pull or push? Durable consumer ownership, filters, ordering, and batch limits? |
| Acknowledgments | When is work successful? Explicit ack, ack timeout, and progress semantics? |
| Delivery failures | Retry/backoff, maximum deliveries, poison messages, and dead-letter ownership? |
| Side effects | Who provides idempotency? What happens between committing effects and acknowledging? |
| Lifecycle | Startup readiness, disconnect recovery, cancellation, shutdown/drain deadlines? |
| Capacity | Maximum in-flight work, handler concurrency, backpressure, and memory limits? |
| Provisioning | Existing versus managed streams/consumers; migration and deletion permissions? |
| Security | TLS, credentials, accounts, subject permissions, and secret injection? |
| Operations | Configuration sources, logging, metrics, health contract, and supported platforms? |
| Compatibility | Public API/version policy and supported NATS server/client versions? |

Do not infer delivery guarantees from a passing publish/consume smoke test.
Cluster size and stream replication are distinct. A three-node cluster does not
make an R1 stream fault tolerant. Local containers share one host and do not
provide production failure-domain isolation.

For a consequential decision, use an ADR with context, alternatives, accepted
contract, consequences, and validation. Do not create a speculative module tree
before these responsibilities exist.
