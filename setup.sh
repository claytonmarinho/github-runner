#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}GitHub Runner Setup${NC}"
echo "=================================="

# Check if .env file exists
if [ ! -f .env ]; then
    echo -e "${YELLOW}No .env file found. Creating from .env.example...${NC}"
    cp .env.example .env
    echo -e "${RED}Please edit .env file with your GitHub token and configuration.${NC}"
    echo -e "${YELLOW}Create a token at: https://github.com/settings/tokens/new${NC}"
    echo -e "${YELLOW}Required scopes: repo (for repo-level) or admin:org (for org-level)${NC}"
    exit 1
fi

# Load environment variables
source .env

# Validate required variables
if [ -z "$GITHUB_TOKEN" ]; then
    echo -e "${RED}Error: GITHUB_TOKEN is not set in .env${NC}"
    exit 1
fi

# Check for organization or repository configuration
if [ -n "$GITHUB_ORG_NAME" ]; then
    echo -e "${GREEN}Setting up organization-level runner for: $GITHUB_ORG_NAME${NC}"
    echo "This runner will be available to all repositories in the organization."
elif [ -n "$GITHUB_REPO_OWNER" ] && [ -n "$GITHUB_REPO_NAME" ]; then
    echo -e "${GREEN}Setting up repository-level runner for: $GITHUB_REPO_OWNER/$GITHUB_REPO_NAME${NC}"
else
    echo -e "${RED}Error: Either GITHUB_ORG_NAME or both GITHUB_REPO_OWNER and GITHUB_REPO_NAME must be set${NC}"
    exit 1
fi

# Create runner work directory
WORKDIR="${GITHUB_RUNNER_WORKDIR:-./runner-data}"
if [ ! -d "$WORKDIR" ]; then
    echo -e "${YELLOW}Creating runner work directory: $WORKDIR${NC}"
    mkdir -p "$WORKDIR"
fi

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}Error: Docker is not running. Please start Docker and try again.${NC}"
    exit 1
fi

echo -e "${GREEN}Setup complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Review your .env configuration"
echo "2. Run: ./start.sh to start the runner"
echo "3. Check logs: ./logs.sh"
echo ""
