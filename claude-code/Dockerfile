FROM ubuntu:24.04

ARG USERNAME=dev
ARG NODE_MAJOR=22

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       sudo \
       build-essential \
       curl \
       git \
       ca-certificates \
       gnupg \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
       | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main" \
       > /etc/apt/sources.list.d/nodesource.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -m -s /bin/bash ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

RUN npm install -g @anthropic-ai/claude-code

USER ${USERNAME}
WORKDIR /home/${USERNAME}

ENTRYPOINT ["claude"]
