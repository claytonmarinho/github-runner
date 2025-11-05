#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}GitHub Runner Status${NC}"
echo "=================================="

# Check if container is running
if docker compose ps | grep -q "Up"; then
    echo -e "${GREEN}✓ Runner is running${NC}"
    echo ""
    docker compose ps
    echo ""
    echo "Recent logs:"
    docker compose logs --tail=10 github-runner
else
    echo -e "${RED}✗ Runner is not running${NC}"
    echo ""
    echo "Start with: ./start.sh"
fi
