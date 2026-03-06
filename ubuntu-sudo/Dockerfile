FROM ubuntu:24.04

ARG USERNAME=dev

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       sudo \
       build-essential \
       curl \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -m -s /bin/bash ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

USER ${USERNAME}
WORKDIR /home/${USERNAME}
