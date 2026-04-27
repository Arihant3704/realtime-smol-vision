#!/bin/bash

# SmolVLM Vision Studio - Complete Environment Setup
# This script installs llama.cpp and downloads the models.

set -e # Exit on error

echo "---------------------------------------"
echo "   SmolVLM Environment Setup Script"
echo "---------------------------------------"

# 1. Update and install system dependencies
echo "[1/4] Installing system dependencies..."
sudo apt-get update
sudo apt-get install -y build-essential cmake git curl wget python3-pip

# 2. Clone and Build llama.cpp with CUDA support
if [ ! -d "llama.cpp" ]; then
    echo "[2/4] Cloning llama.cpp..."
    git clone https://github.com/ggerganov/llama.cpp
else
    echo "[2/4] llama.cpp already exists, skipping clone."
fi

echo "[*] Building llama.cpp with CUDA support..."
cd llama.cpp
mkdir -p build
cd build
# Using -DGGML_CUDA=ON for NVIDIA GPUs. Change to -DGGML_VULKAN=ON for AMD/Intel.
cmake .. -DGGML_CUDA=ON
make -j$(nproc)
cd ../..

# 3. Download SmolVLM Models
echo "[3/4] Installing huggingface_hub for model downloading..."
pip3 install huggingface_hub

echo "[*] Downloading SmolVLM 500M Model & Projector..."
mkdir -p models
huggingface-cli download ggml-org/SmolVLM-500M-Instruct-GGUF SmolVLM-500M-Instruct-Q8_0.gguf --local-dir models --local-dir-use-symlinks False
huggingface-cli download ggml-org/SmolVLM-500M-Instruct-GGUF mmproj-SmolVLM-500M-Instruct-Q8_0.gguf --local-dir models --local-dir-use-symlinks False

# 4. Final configuration
echo "[4/4] Finalizing setup..."
chmod +x start.sh

echo "---------------------------------------"
echo "✅ SETUP COMPLETE!"
echo "---------------------------------------"
echo "You can now start the studio by running:"
echo "  ./start.sh"
echo "---------------------------------------"
