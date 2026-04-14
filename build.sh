#!/usr/bin/env bash
# Build the full image chain: ubuntu-sudo -> dev-base -> claude-code -> claude-code-api
# Any extra args (e.g. --no-cache, --build-arg KEY=VAL) are forwarded to every `docker build`.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}"

IMAGES=(
  "ubuntu-sudo"
  "dev-base"
  "claude-code"
  "claude-code-api"
)

for image in "${IMAGES[@]}"; do
  echo
  echo "=== Building ${image} ==="
  docker build "$@" -t "${image}" "./${image}"
done

echo
echo "=== Done ==="
docker images --format 'table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedSince}}' \
  | grep -E "^(REPOSITORY|ubuntu-sudo|dev-base|claude-code|claude-code-api)\s"
