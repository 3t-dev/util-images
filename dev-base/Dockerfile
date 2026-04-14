FROM ubuntu-sudo:latest

ARG USERNAME=dev
ARG YAZI_VERSION=0.4.2
ARG HELIX_VERSION=25.01.1

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       ca-certificates \
       gnupg \
       git \
       unzip \
       xz-utils \
    && install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
         | gpg --dearmor -o /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
         > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends gh \
    && rm -rf /var/lib/apt/lists/*

RUN ARCH="$(dpkg --print-architecture)" \
    && case "$ARCH" in \
         amd64) HELIX_ARCH="x86_64-linux" ;; \
         arm64) HELIX_ARCH="aarch64-linux" ;; \
         *) echo "Unsupported arch: $ARCH" >&2 && exit 1 ;; \
       esac \
    && curl -fsSL -o /tmp/helix.tar.xz \
         "https://github.com/helix-editor/helix/releases/download/${HELIX_VERSION}/helix-${HELIX_VERSION}-${HELIX_ARCH}.tar.xz" \
    && mkdir -p /tmp/helix-extract \
    && tar -xJf /tmp/helix.tar.xz -C /tmp/helix-extract \
    && install -m 0755 "/tmp/helix-extract/helix-${HELIX_VERSION}-${HELIX_ARCH}/hx" /usr/local/bin/hx \
    && mkdir -p /usr/local/lib/helix \
    && cp -r "/tmp/helix-extract/helix-${HELIX_VERSION}-${HELIX_ARCH}/runtime" /usr/local/lib/helix/runtime \
    && rm -rf /tmp/helix.tar.xz /tmp/helix-extract

ENV HELIX_RUNTIME=/usr/local/lib/helix/runtime

RUN ARCH="$(dpkg --print-architecture)" \
    && case "$ARCH" in \
         amd64) YAZI_ARCH="x86_64-unknown-linux-gnu" ;; \
         arm64) YAZI_ARCH="aarch64-unknown-linux-gnu" ;; \
         *) echo "Unsupported arch: $ARCH" >&2 && exit 1 ;; \
       esac \
    && curl -fsSL -o /tmp/yazi.zip \
         "https://github.com/sxyazi/yazi/releases/download/v${YAZI_VERSION}/yazi-${YAZI_ARCH}.zip" \
    && unzip -d /tmp/yazi-extract /tmp/yazi.zip \
    && find /tmp/yazi-extract -type f -name yazi -exec install -m 0755 {} /usr/local/bin/yazi \; \
    && find /tmp/yazi-extract -type f -name ya   -exec install -m 0755 {} /usr/local/bin/ya   \; \
    && rm -rf /tmp/yazi.zip /tmp/yazi-extract

USER ${USERNAME}
WORKDIR /home/${USERNAME}

RUN cat >> /home/${USERNAME}/.bashrc <<'BASHRC_EOF'

# default editor
export EDITOR=hx
export VISUAL=hx

# enable and config terminal color
export CLICOLOR=1
export LSCOLORS=CxBACxDxGxegedabagaced
parse_git_branch() {
   git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
SB_NOCOLOR="\[\033[0m\]"
SB_GREEN="\[\033[0;32m\]"
SB_GREEN_BOLD="\[\033[1;32m\]"
export PS1="\u@\h $SB_GREEN_BOLD\w$SB_GREEN\$(parse_git_branch)$SB_NOCOLOR $ "
BASHRC_EOF
