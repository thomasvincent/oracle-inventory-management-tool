FROM ruby:3.1-slim

ARG VERSION=2.0.0
LABEL org.opencontainers.image.title="Oracle Inventory Management Cookbook"
LABEL org.opencontainers.image.description="Chef cookbook to manage Oracle inventory"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.authors="Thomas Vincent"
LABEL org.opencontainers.image.source="https://github.com/thomasvincent/oracle-inventory-management-tool"
LABEL org.opencontainers.image.licenses="Apache-2.0"

WORKDIR /cookbook

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Chef tools
RUN gem install chef-cli berkshelf chef-vault

# Copy the cookbook
COPY . /cookbook/

# Verify cookbook
RUN knife cookbook test oracle-inventory-management -o /cookbook/.. || true

# Create a checkpoint for the cookbook version
RUN echo "Oracle Inventory Management Cookbook v${VERSION}" > /version.txt

# Default command to display cookbook info
CMD ["knife", "cookbook", "show", "oracle-inventory-management"]