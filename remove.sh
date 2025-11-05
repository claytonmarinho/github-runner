#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${RED}WARNING: This will remove the runner and all its data!${NC}"
echo -e "${YELLOW}This action cannot be undone.${NC}"
echo ""
read -p "Are you sure you want to continue? (yes/no): " -r
echo

if [[ $REPLY != "yes" ]]; then
    echo "Aborted."
    exit 1
fi

echo -e "${YELLOW}Stopping and removing runner...${NC}"

# Stop and remove containers
docker compose down -v

# Remove runner data directory
WORKDIR="${GITHUB_RUNNER_WORKDIR:-./runner-data}"
if [ -d "$WORKDIR" ]; then
    echo -e "${YELLOW}Removing runner data directory: $WORKDIR${NC}"
    rm -rf "$WORKDIR"
fi

echo -e "${GREEN}✓ Runner removed${NC}"
echo ""
echo "Note: The runner may still be registered in GitHub."
echo "Remove it manually at: https://github.com/YOUR_ORG_OR_REPO/settings/actions/runners"
