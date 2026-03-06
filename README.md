# util-images

Utility Docker images for development and CI/CD workflows.

## Images

| Image | Description |
|-------|-------------|
| `ubuntu-sudo` | Ubuntu base with a non-root sudo user to avoid root side-effects |
| `claude-code` | Isolated Claude Code environment with Node.js and subscription auth support |

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

### claude-code

Build:

```bash
docker build -t claude-code ./claude-code
```

Build with custom Node.js version or username:

```bash
docker build -t claude-code --build-arg NODE_MAJOR=20 --build-arg USERNAME=myuser ./claude-code
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

## Why non-root?

Running containers as root can cause file permission issues on mounted volumes and poses unnecessary security risks. These images ship with a default sudo-capable user out of the box.

## License

MIT
