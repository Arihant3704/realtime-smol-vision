#!/bin/bash

# SmolVLM Vision Studio - Universal Environment Setup
# Supports: Ubuntu/Debian, macOS (Intel/Silicon), and Windows (via WSL2)

set -e

echo "---------------------------------------"
echo "   SmolVLM Universal Setup Script"
echo "---------------------------------------"

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 1. Detect OS and Install Dependencies
OS_TYPE=$(uname -s)

if [ "$OS_TYPE" == "Linux" ]; then
    echo "🐧 Linux detected (or WSL2)..."
    if command_exists apt-get; then
        echo "[*] Updating package lists..."
        sudo apt-get update || echo "⚠️ Warning: apt update failed."
        sudo apt-get install -y build-essential cmake git curl wget python3-pip python3-venv
    else
        echo "⚠️ Non-Debian Linux detected. Please ensure 'cmake', 'gcc', and 'python3-venv' are installed manually."
    fi
elif [ "$OS_TYPE" == "Darwin" ]; then
    echo "🍎 macOS detected..."
    if ! command_exists brew; then
        echo "❌ Homebrew not found. Please install it from https://brew.sh/ first."
        exit 1
    fi
    echo "[*] Installing dependencies via Homebrew..."
    brew install cmake python git
else
    echo "❓ Unknown OS: $OS_TYPE. Please install build-essential, cmake, and python3 manually."
fi

# 2. Python Virtual Environment
echo "[2/4] Setting up Python virtual environment..."
if [ ! -d ".venv" ]; then
    python3 -m venv .venv
fi
source .venv/bin/activate
pip install --upgrade pip
pip install huggingface_hub

# 3. Clone and Build llama.cpp
if [ ! -d "llama.cpp" ]; then
    echo "[3/4] Cloning llama.cpp..."
    git clone https://github.com/ggerganov/llama.cpp
else
    echo "[3/4] llama.cpp already exists, checking build status..."
fi

# Hardware Detection for Build Flags
BUILD_FLAGS="-DGGML_CUDA=OFF -DGGML_METAL=OFF"

if [ "$OS_TYPE" == "Darwin" ]; then
    echo "🚀 Apple Silicon/Intel detected! Enabling Metal support..."
    BUILD_FLAGS="-DGGML_METAL=ON"
elif command_exists nvidia-smi; then
    echo "🚀 NVIDIA GPU detected! Enabling CUDA support..."
    BUILD_FLAGS="-DGGML_CUDA=ON"
else
    echo "ℹ️ No dedicated GPU detected. Building for CPU mode..."
fi

# Build only if binary is missing
if [ ! -f "llama.cpp/build/bin/llama-server" ]; then
    echo "[*] Building llama.cpp with flags: $BUILD_FLAGS"
    pushd llama.cpp > /dev/null
    mkdir -p build
    cd build
    cmake .. $BUILD_FLAGS
    make -j$(nproc 2>/dev/null || sysctl -n hw.ncpu)
    popd > /dev/null
else
    echo "[*] llama-server already built."
fi

# 4. Download SmolVLM Models
echo "[4/4] Downloading SmolVLM 500M Model & Projector..."
mkdir -p models
huggingface-cli download ggml-org/SmolVLM-500M-Instruct-GGUF SmolVLM-500M-Instruct-Q8_0.gguf --local-dir models --local-dir-use-symlinks False
huggingface-cli download ggml-org/SmolVLM-500M-Instruct-GGUF mmproj-SmolVLM-500M-Instruct-Q8_0.gguf --local-dir models --local-dir-use-symlinks False

# 5. Finalize
chmod +x start.sh

echo "---------------------------------------"
echo "✅ SETUP COMPLETE!"
echo "---------------------------------------"
echo "Start the studio: ./start.sh"
echo "---------------------------------------"
