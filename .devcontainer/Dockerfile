# autoresearch dev container base image
# uses python 3.11
# FROM pytorch/pytorch:2.5.1-cuda12.4-cudnn9-runtime 
# for miniconda workflows without GPU
FROM mcr.microsoft.com/devcontainers/miniconda:3

LABEL org.opencontainers.image.title="autoresearch-container"
LABEL org.opencontainers.image.description="Autoresearch development container"

# System basics
RUN apt-get update && apt-get install -y \
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
    && useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME

# Install Node.js 20.x (for Codex CLI)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*
# FIX PERMISSIONS FOR CONDA
# This allows the 'dev' user to install packages later
RUN chown -R $USERNAME:$USER_GID /opt/conda

# setup working directory (/workspace name is convention)
WORKDIR /workspace

# Switch to the non-root user BEFORE installing python packages
USER $USERNAME

# Python dependencies are installed at post-create time via `uv sync`
# from the mounted workspace (`/workspace`).
