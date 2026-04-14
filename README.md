# util-images

Utility Docker images for development and CI/CD workflows.

## Images

| Image | Description |
|-------|-------------|
| `ubuntu-sudo` | Ubuntu base with a non-root sudo user to avoid root side-effects |
| `dev-base` | `ubuntu-sudo` + git, GitHub CLI, Helix, Yazi, and a colored bash prompt with git branch |
| `claude-code` | Isolated Claude Code environment on `dev-base`, subscription auth support |
| `claude-code-api` | Claude Code environment that authenticates via `ANTHROPIC_API_KEY` / `ANTHROPIC_BASE_URL` |

Image inheritance: `ubuntu-sudo` → `dev-base` → `claude-code` → `claude-code-api`.

### Quick start: build the whole chain

```bash
./build.sh                              # build all four in order
./build.sh --no-cache                   # force a fresh rebuild
./build.sh --build-arg USERNAME=thanh   # any flag/arg is forwarded to every `docker build`
```

Or build individually, in order:

```bash
docker build -t ubuntu-sudo     ./ubuntu-sudo
docker build -t dev-base        ./dev-base
docker build -t claude-code     ./claude-code
docker build -t claude-code-api ./claude-code-api
```

## Usage

### ubuntu-sudo

Build with default user (`dev`):

```bash
docker build -t ubuntu-sudo ./ubuntu-sudo
```

Build with a custom username:

```bash
docker build -t ubuntu-sudo --build-arg USERNAME=myuser ./ubuntu-sudo
```

Run:

```bash
docker run -it ubuntu-sudo
```

### dev-base

Development base with:

- `git` and `gh` (GitHub CLI, installed via the official apt repo)
- `hx` (Helix editor) — installed from the upstream GitHub release tarball, not apt (the `helix` package isn't in Ubuntu 24.04's repos). The runtime is placed at `/usr/local/lib/helix/runtime` and `HELIX_RUNTIME` is set globally so `hx` works from any shell.
- `yazi` (terminal file manager) — prebuilt binary from GitHub releases. `$EDITOR`/`$VISUAL` are set to `hx` in `~/.bashrc`, so yazi opens files in Helix out of the box.
- Colored bash prompt with a `parse_git_branch` helper, appended to `~/.bashrc`.

Supports both `amd64` and `arm64`.

Build (requires `ubuntu-sudo` to exist first):

```bash
docker build -t ubuntu-sudo ./ubuntu-sudo
docker build -t dev-base    ./dev-base
```

Pin specific tool versions:

```bash
docker build -t dev-base \
  --build-arg HELIX_VERSION=25.01.1 \
  --build-arg YAZI_VERSION=0.4.2 \
  ./dev-base
```

### claude-code

Build (requires `dev-base` to exist first):

```bash
docker build -t claude-code ./claude-code
```

Pin a specific Claude Code version:

```bash
docker build -t claude-code --build-arg CLAUDE_CODE_VERSION=latest ./claude-code
```

Log in on your host first (one-time):

```bash
claude login
```

Run with subscription auth and a project mounted:

```bash
docker run -it \
  -v ~/.claude:/home/dev/.claude \
  -v /path/to/project:/home/dev/project \
  -w /home/dev/project \
  claude-code
```

### claude-code-api

Like `claude-code`, but uses API-key auth instead of subscription OAuth. Designed for use with the official Anthropic API or a compatible proxy/relay set via `ANTHROPIC_BASE_URL`.

Build (requires the `claude-code` image to exist locally first):

```bash
docker build -t claude-code-api ./claude-code-api
```

Create a host dir for persistent Claude state (one-time):

```bash
mkdir -p ~/.claude-api-docker-vol
```

Run, mounting workspace and Claude state. The container drops you into a shell in `/home/dev` — start Claude yourself with `claude` (easier to debug than auto-launching):

```bash
docker run -it --rm \
  --network host \
  -e ANTHROPIC_API_KEY=sk-ant-... \
  -e ANTHROPIC_BASE_URL=https://api.anthropic.com \
  -v ~/.claude-api-docker-vol:/home/dev/.claude \
  -v /path/to/project:/home/dev/workspace \
  claude-code-api
```

> **macOS note:** `--network host` on Docker Desktop for Mac requires enabling *Settings → Resources → Network → "Enable host networking"* (Docker Desktop 4.29+). Otherwise it silently falls back to bridge mode — use `host.docker.internal` in `ANTHROPIC_BASE_URL` to reach host services instead.

Then inside the container:

```bash
cd ~/workspace
claude
```

Supported env vars (all optional unless noted):

| Env | Purpose |
|-----|---------|
| `ANTHROPIC_API_KEY` | API key sent as `x-api-key` (required unless using `ANTHROPIC_AUTH_TOKEN`) |
| `ANTHROPIC_BASE_URL` | Override the API endpoint (useful for proxies/relays) |
| `ANTHROPIC_AUTH_TOKEN` | Sent as `Authorization: Bearer …` — used by some proxies instead of an API key |
| `ANTHROPIC_MODEL` | Default model (e.g. `claude-opus-4-6`) |
| `DISABLE_AUTOUPDATER` | Pre-set to `1`; the image is immutable so the in-place updater is skipped |

> **Note:** Do not mount your host `~/.claude` into this image. It contains subscription OAuth credentials that conflict with API-key mode, and conversation history keyed by host paths won't match container paths. Use a dedicated dir like `~/.claude-api-docker-vol` instead.

## Why non-root?

Running containers as root can cause file permission issues on mounted volumes and poses unnecessary security risks. These images ship with a default sudo-capable user out of the box.

## License

MIT
