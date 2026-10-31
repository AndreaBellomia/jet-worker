# Security

This repository is a pre-release template and has no supported production worker.
Do not use the local development NATS configuration in production: it has no TLS or
authentication. Broker ports are exposed only on loopback when published.

Do not report credentials or exploitable details in a public issue. Use the repository's
GitHub Security Advisories private reporting feature once enabled by the maintainer.
Until private reporting is configured, contact the maintainer through an established
private channel; this template does not invent a security contact address.

CI scans locked Python dependencies, container images, and repository secrets with
Trivy. HIGH and CRITICAL CVEs fail the gate even when a fix is not available. Review
lower severities as well; a passing scanner cannot establish absence of vulnerabilities.
Security exceptions require a specific advisory, justification, expiry, and review.
