# GitHub Actions Self-Hosted Runner

Docker-based GitHub Actions runner that can be used across multiple repositories.

## Features

- 🐳 Docker-based for easy deployment
- 🔄 Reusable across multiple projects
- 📦 Pre-configured for Node.js/pnpm projects
- 🚀 Organization or repository-level runners
- 💾 Persistent cache for faster builds
- 🛡️ Security best practices

## Prerequisites

- Docker and Docker Compose installed
- GitHub Personal Access Token with appropriate scopes:
  - For **repository-level** runners: `repo` scope
  - For **organization-level** runners: `admin:org` scope

## Quick Start

### 1. Initial Setup

```bash
# Clone or navigate to this repository
cd github-runner

# Run setup (creates .env from template)
./setup.sh

# Edit .env with your configuration
nano .env
```

### 2. Configure Environment

Edit `.env` file with your settings:

```bash
# Required: GitHub Personal Access Token
GITHUB_TOKEN=ghp_your_token_here

# For repository-level runner (one repo)
GITHUB_REPO_OWNER=your-username
GITHUB_REPO_NAME=your-repo

# OR for organization-level runner (all repos in org)
# Uncomment these and comment out repo settings above
# GITHUB_ORG_NAME=your-org-name
```

### 3. Start Runner

```bash
./start.sh
```

That's it! Your runner is now available in GitHub Actions.

## Management Commands

| Command | Description |
|---------|-------------|
| `./setup.sh` | Initial setup (creates .env) |
| `./start.sh` | Start the runner |
| `./stop.sh` | Stop the runner |
| `./restart.sh` | Restart the runner |
| `./logs.sh` | View runner logs (live) |
| `./status.sh` | Check runner status |
| `./remove.sh` | Remove runner completely |

## Configuration Options

### Runner Settings

```bash
# Runner identification
GITHUB_RUNNER_NAME=my-runner              # Default: github-runner
GITHUB_RUNNER_CONTAINER=my-container      # Default: github-runner

# Runner labels (comma-separated)
GITHUB_RUNNER_LABELS=self-hosted,linux,docker,node,pnpm

# Architecture (auto-detected if not set)
GITHUB_RUNNER_ARCH=arm64                  # or x64

# Runner behavior
RUNNER_EPHEMERAL=false                    # true = remove after each job
RUNNER_SCOPE=repo                         # repo or org
```

### Storage

```bash
# Runner work directory (stores build artifacts, caches, etc.)
GITHUB_RUNNER_WORKDIR=./runner-data       # Default location
```

## Organization vs Repository Runners

### Organization-Level (Recommended for Multiple Projects)

**Pros:**
- ✅ One runner serves all repos in the organization
- ✅ Centralized management
- ✅ Cost-effective

**Setup:**
```bash
# In .env
GITHUB_ORG_NAME=your-org-name
GITHUB_TOKEN=ghp_token_with_admin_org_scope

# In docker-compose.yml, uncomment:
# ORG_NAME: ${GITHUB_ORG_NAME}
# ACCESS_TOKEN: ${GITHUB_TOKEN}

# And comment out:
# REPO_URL: ...
```

### Repository-Level

**Pros:**
- ✅ Isolated per repository
- ✅ Different configuration per repo

**Setup:**
```bash
# In .env (default configuration)
GITHUB_REPO_OWNER=your-username
GITHUB_REPO_NAME=your-repo
GITHUB_TOKEN=ghp_token_with_repo_scope
```

## Using the Runner in Workflows

In your repository's `.github/workflows/*.yml`:

```yaml
jobs:
  build:
    runs-on: self-hosted  # Uses your runner
    steps:
      - uses: actions/checkout@v4
      - name: Build
        run: pnpm build
```

### With Specific Labels

```yaml
jobs:
  build:
    runs-on: [self-hosted, linux, arm64]  # Matches runner labels
```

## Resource Limits

Default limits (adjust in `docker-compose.yml`):

```yaml
deploy:
  resources:
    limits:
      cpus: '4'
      memory: 8G
    reservations:
      cpus: '2'
      memory: 4G
```

## Troubleshooting

### Runner Not Appearing in GitHub

1. Check logs: `./logs.sh`
2. Verify token has correct scopes
3. Check token hasn't expired
4. Ensure Docker is running: `docker ps`

### Runner Offline

```bash
# Check status
./status.sh

# Restart runner
./restart.sh

# Check logs for errors
./logs.sh
```

### Permission Errors

```bash
# Ensure Docker socket is accessible
ls -la /var/run/docker.sock

# On Linux, add user to docker group
sudo usermod -aG docker $USER
```

### Out of Disk Space

```bash
# Clean Docker
docker system prune -a

# Check runner data size
du -sh ${GITHUB_RUNNER_WORKDIR:-./runner-data}

# Remove old runner data
./remove.sh
./setup.sh
./start.sh
```

## Security Considerations

1. **Token Security**: Never commit `.env` file with tokens
2. **Docker Socket**: Runner has Docker access (can run any container)
3. **Network**: Runner can access internet and local network
4. **Updates**: Keep Docker image updated: `docker compose pull`

### Recommended Practices

- Use ephemeral runners for untrusted code: `RUNNER_EPHEMERAL=true`
- Limit runner to specific repositories
- Rotate GitHub tokens regularly
- Monitor runner logs for suspicious activity
- Use organization-level runners only in trusted orgs

## Monitoring

### Check Runner Status in GitHub

**For Organization:**
`https://github.com/organizations/YOUR_ORG/settings/actions/runners`

**For Repository:**
`https://github.com/OWNER/REPO/settings/actions/runners`

### View Logs

```bash
# Live logs
./logs.sh

# Last 100 lines
docker compose logs --tail=100 github-runner

# Export logs
docker compose logs > runner-logs.txt
```

## Updating

```bash
# Pull latest runner image
docker compose pull

# Restart with new image
./restart.sh
```

## Uninstalling

```bash
# Stop and remove runner
./remove.sh

# Remove runner from GitHub (manual):
# 1. Go to: https://github.com/YOUR_ORG_OR_REPO/settings/actions/runners
# 2. Click on your runner
# 3. Click "Remove"
```

## Multiple Runners

To run multiple runners, create separate directories:

```bash
# Create second runner
cp -r github-runner github-runner-2
cd github-runner-2

# Edit .env with different GITHUB_RUNNER_NAME
nano .env

# Start second runner
./start.sh
```

## Performance Optimization

### Cache Configuration

Caches are automatically configured for:
- pnpm store
- Node.js cache
- Build outputs

### Persistent Storage

Runner work directory persists between runs for faster builds:
```bash
GITHUB_RUNNER_WORKDIR=./runner-data  # Adjust path as needed
```

## Support

For issues with this runner setup, check:
1. Docker logs: `./logs.sh`
2. GitHub runner status (see Monitoring section)
3. Docker installation: `docker info`

## License

MIT

## Related Links

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Self-hosted Runners](https://docs.github.com/en/actions/hosting-your-own-runners)
- [myoung34/github-runner Docker Image](https://github.com/myoung34/docker-github-actions-runner)
