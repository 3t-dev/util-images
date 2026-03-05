# util-images

Utility Docker images for development and CI/CD workflows.

## Images

| Image | Description |
|-------|-------------|
| `ubuntu-sudo` | Ubuntu base with a non-root sudo user to avoid root side-effects |

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

## Why non-root?

Running containers as root can cause file permission issues on mounted volumes and poses unnecessary security risks. These images ship with a default sudo-capable user out of the box.

## License

MIT
