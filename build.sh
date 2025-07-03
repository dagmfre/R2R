#!/bin/bash
set -e

# Set Cargo environment variables for temporary directories
export CARGO_HOME=/tmp/cargo
export RUSTUP_HOME=/tmp/rustup

# Create temporary directories
mkdir -p /tmp/cargo /tmp/rustup

# Install Rust toolchain in temporary directory
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
source /tmp/cargo/env

# Install R2R with Rust available
pip install 'r2r[core]'
