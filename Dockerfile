FROM nvidia/cuda:12.8.1-cudnn-devel-ubuntu24.04

ARG python_version="3.11.9"

# Install dependencies
RUN apt-get update && apt-get install -y \
    sudo curl git tmux build-essential ca-certificates gnupg \
    nodejs npm ripgrep \
 && rm -rf /var/lib/apt/lists/*

 # Install gh CLI
RUN (type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
	&& out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
	&& cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& sudo mkdir -p -m 755 /etc/apt/sources.list.d \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y \
    && rm -rf /var/lib/apt/lists/*

# Add user with sudo privileges
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu

USER ubuntu

# Install Rye
RUN curl -sSf https://rye.astral.sh/get | RYE_INSTALL_OPTION="--yes" bash
ENV PATH="/home/ubuntu/.rye/shims:${PATH}"

WORKDIR /home/ubuntu/work

COPY --chown=ubuntu:ubuntu ./work /home/ubuntu/work/


# Configure npm global directory and install Claude Code
RUN npm config set prefix '/home/ubuntu/.npm-global' && \
    npm install -g @anthropic-ai/claude-code

# Add npm global bin to PATH
ENV PATH="/home/ubuntu/.npm-global/bin:$PATH"
CMD ["claude"]