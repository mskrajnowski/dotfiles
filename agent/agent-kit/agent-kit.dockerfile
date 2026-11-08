FROM docker/sandbox-templates:shell-docker
USER root

# Install various useful tools
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  ffmpeg \
  imagemagick \
  wget \
  tree \
  htop \
  git \
  tig \
  fish \
  vim \
  stow \
  # Headless Wayland desktop (used by the agent-dotfiles 'desktop' skill)
  sway \
  wayvnc \
  grim \
  xwayland \
  novnc \
  websockify \
  && rm -rf /var/lib/apt/lists/*

# set fish as the default shell for agent for ssh
RUN chsh -s /bin/fish agent

# Install mise with fish completions
RUN curl -fsSL https://mise.run | MISE_INSTALL_PATH=/usr/local/bin/mise sh
RUN mkdir -p /etc/fish/completions
RUN mise completion fish >/etc/fish/completions/mise.fish

USER agent
WORKDIR /home/agent
ENTRYPOINT []
CMD ["fish"]
