<<<<<<< HEAD
# trace-ai-analysis dev container base image
=======
# autoresearch dev container base image
>>>>>>> e8fae2866bc9d05c0d46f466c10dcdc258f5b6bf
# uses python 3.11
# FROM pytorch/pytorch:2.5.1-cuda12.4-cudnn9-runtime 
# for miniconda workflows without GPU
FROM mcr.microsoft.com/devcontainers/miniconda:3

<<<<<<< HEAD
LABEL org.opencontainers.image.title="trace-ai-analysis-external"
LABEL org.opencontainers.image.description="TRACE-AI analysis development container for external data"
=======
LABEL org.opencontainers.image.title="autoresearch-container"
LABEL org.opencontainers.image.description="Autoresearch development container"
>>>>>>> e8fae2866bc9d05c0d46f466c10dcdc258f5b6bf

# System basics
RUN apt-get update && apt-get install -y \
    sudo \
    tmux \
    git \
    curl \
    wget \
    vim \
    htop \
    ripgrep \
    rclone \
    bubblewrap \
    && rm -rf /var/lib/apt/lists/*

# to avoid files being created as root - we create a non-root user named "dev" 
ARG USERNAME=bb2238
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# 4. FIXING CONFLICTS - sometimes base image ubuntu already as a user named ubuntu at ID 1000 so need to delete it to do our own user trick
RUN if getent passwd $USER_UID > /dev/null 2>&1; then \
        userdel -r $(getent passwd $USER_UID | cut -d: -f1); \
    fi

# Create the new user with the same ID as the host user
RUN groupadd --gid $USER_GID $USERNAME \
    # add user with default bash shell
<<<<<<< HEAD
    && useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME \   
    # Explicitly create the sudoers directory to avoid "nonexistent" errors
    && mkdir -p /etc/sudoers.d \
    # Add sudo support so that the user can run commands as root 
=======
    && useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME \
    # Explicitly create sudoers directory
    && mkdir -p /etc/sudoers.d \
    # Allow passwordless sudo inside sandbox container
>>>>>>> e8fae2866bc9d05c0d46f466c10dcdc258f5b6bf
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Install Node.js 20.x (for Codex CLI)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*
<<<<<<< HEAD
# Install Codex CLI
RUN npm install -g @openai/codex
# update to most recent version of codex
RUN npm i -g @openai/codex@latest

=======
>>>>>>> e8fae2866bc9d05c0d46f466c10dcdc258f5b6bf
# FIX PERMISSIONS FOR CONDA
# This allows the 'dev' user to install packages later
RUN chown -R $USERNAME:$USER_GID /opt/conda

# setup working directory (/workspace name is convention)
WORKDIR /workspace

# Switch to the non-root user BEFORE installing python packages
USER $USERNAME

# Install Python packages
# Since we're in a Conda image, it's safer to use a requirements file 
# but stay in the 'base' environment.
COPY --chown=$USERNAME:$USER_GID requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
