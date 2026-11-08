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

# Browsers for the agent-dotfiles 'browser' skill (driven at runtime via
# Puppeteer); that skill documents usage and constraints.
ENV PLAYWRIGHT_BROWSERS_PATH=/opt/ms-playwright

# npx needs the image's configured npm global prefix to exist (base-image quirk)
RUN mkdir -p /usr/local/share/npm-global/lib

RUN npx -y playwright@1.65.0 install --with-deps chromium firefox \
  && rm -rf /root/.npm /root/.cache \
  # playwright can exit 0 on a failed download, so verify.
  && test -x /opt/ms-playwright/chromium-*/chrome-linux64/chrome \
  && test -x /opt/ms-playwright/firefox-*/firefox/firefox

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
