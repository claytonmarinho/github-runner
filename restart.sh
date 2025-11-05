#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Restarting GitHub Runner...${NC}"

./stop.sh
sleep 1
./start.sh

echo -e "${GREEN}✓ Runner restarted${NC}"
