#!/bin/sh
# Host orchestration only. The scanner runs in Docker without a Docker socket mount.
set -eu
export LOCAL_UID="${LOCAL_UID:-$(id -u)}"
export LOCAL_GID="${LOCAL_GID:-$(id -g)}"
scanner=aquasec/trivy:0.76.1
mkdir -p reports
result=0
docker run --rm -v jet-worker-trivy-cache:/root/.cache/trivy \
  -v "$PWD:/work:ro" -v "$PWD/reports:/reports" "$scanner" fs \
  --scanners vuln,secret --include-dev-deps --severity HIGH,CRITICAL --exit-code 1 \
  --format json --output /reports/trivy-filesystem.json \
  --skip-dirs /work/.git,/work/.cache,/work/reports /work || result=1
docker compose build tools
docker compose pull nats
scan_dir=$(mktemp -d)
trap 'rm -rf "$scan_dir"' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
for image in "jet-worker-dev:${PYTHON_VERSION:-3.13}" nats:2.15.2-alpine; do
  report_name=$(printf '%s' "$image" | tr ':/' '--')
  docker save "$image" -o "$scan_dir/image.tar"
  docker run --rm -v jet-worker-trivy-cache:/root/.cache/trivy \
    -v "$scan_dir:/scan:ro" -v "$PWD/reports:/reports" "$scanner" image \
    --input /scan/image.tar --severity HIGH,CRITICAL --exit-code 1 \
    --format json --output "/reports/trivy-${report_name}.json" || result=1
done
echo 'Trivy reports: reports/trivy-*.json'
exit "$result"
