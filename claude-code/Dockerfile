FROM dev-base:latest

ARG USERNAME=dev
ARG CLAUDE_CODE_VERSION=latest

ENV PATH="/home/${USERNAME}/.local/bin:${PATH}"

RUN curl -fsSL https://claude.ai/install.sh | bash -s ${CLAUDE_CODE_VERSION}

ENTRYPOINT ["claude"]
