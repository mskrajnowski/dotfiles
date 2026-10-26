FROM docker/sandbox-templates:shell
USER root

# Install various useful tools
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  wget \
  tree \
  htop \
  git \
  tig \
  fish \
  vim \
  stow \
  && rm -rf /var/lib/apt/lists/*

# set fish as the default shell for agent for ssh
RUN chsh -s /bin/fish agent

# Install mise with fish completions
RUN curl -fsSL https://mise.run | MISE_INSTALL_PATH=/usr/local/bin/mise sh
RUN mkdir -p /etc/fish/completions
RUN mise completion fish >/etc/fish/completions/mise.fish

# Copy dotfiles
COPY --chown=1000:1000 files/home/agent/.config/ /home/agent/.config/
COPY --chown=1000:1000 files/home/agent/.agents/ /home/agent/.agents/
RUN mkdir -p /home/agent/.pi/agent \
  && ln -s /home/agent/.agents/AGENTS.md /home/agent/.pi/agent/AGENTS.md

USER agent
WORKDIR /home/agent
ENTRYPOINT []
CMD ["fish"]
