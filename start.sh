#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}Starting GitHub Runner...${NC}"

# Load environment variables
if [ -f .env ]; then
    source .env
fi

# Pull latest image
echo -e "${YELLOW}Pulling latest runner image...${NC}"
docker compose pull

# Start the runner
echo -e "${YELLOW}Starting runner container...${NC}"
docker compose up -d

# Wait a moment for the container to start
sleep 2

# Check if container is running
if docker compose ps | grep -q "Up"; then
    echo -e "${GREEN}✓ Runner started successfully!${NC}"
    echo ""
    echo "Container name: ${GITHUB_RUNNER_CONTAINER:-github-runner}"
    echo "Runner name: ${GITHUB_RUNNER_NAME:-github-runner}"
    echo ""
    echo "Check logs with: ./logs.sh"
    echo "Stop with: ./stop.sh"
else
    echo -e "${RED}✗ Failed to start runner. Check logs with: docker compose logs${NC}"
    exit 1
fi
