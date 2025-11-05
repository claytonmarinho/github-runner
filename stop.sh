#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Stopping GitHub Runner...${NC}"

docker compose down

echo -e "${GREEN}✓ Runner stopped${NC}"
