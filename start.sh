#!/bin/bash

# SmolVLM Vision Studio - Portable Starter
# Automatically detects hardware and local paths.

PORT=8080

# 1. Path Logic: Detect paths relative to this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
LOCAL_BINARY="$SCRIPT_DIR/llama.cpp/build/bin/llama-server"
LOCAL_MODEL="$SCRIPT_DIR/models/SmolVLM-500M-Instruct-Q8_0.gguf"
LOCAL_PROJECTOR="$SCRIPT_DIR/models/mmproj-SmolVLM-500M-Instruct-Q8_0.gguf"

# Auto-detect Binary
if [ -f "$LOCAL_BINARY" ]; then
    BINARY="$LOCAL_BINARY"
elif [ -f "$SCRIPT_DIR/llama-server" ]; then
    BINARY="$SCRIPT_DIR/llama-server"
else
    # Fallback to system path if someone installed it globally
    if command -v llama-server >/dev/null 2>&1; then
        BINARY=$(command -v llama-server)
    else
        echo "❌ [ERROR] llama-server not found. Please run ./setup.sh first."
        exit 1
    fi
fi

# Auto-detect Models
if [ -f "$LOCAL_MODEL" ] && [ -f "$LOCAL_PROJECTOR" ]; then
    MODEL="$LOCAL_MODEL"
    PROJECTOR="$LOCAL_PROJECTOR"
else
    echo "⚠️ [WARNING] Local models not found in ./models/"
    echo "Checking HuggingFace cache..."
    # Portable search for HF cache
    HF_CACHE_DIR="$HOME/.cache/huggingface/hub"
    FOUND_MODEL=$(find "$HF_CACHE_DIR" -name "SmolVLM-500M-Instruct-Q8_0.gguf" | head -n 1)
    FOUND_PROJ=$(find "$HF_CACHE_DIR" -name "mmproj-SmolVLM-500M-Instruct-Q8_0.gguf" | head -n 1)
    
    if [ -n "$FOUND_MODEL" ] && [ -n "$FOUND_PROJ" ]; then
        MODEL="$FOUND_MODEL"
        PROJECTOR="$FOUND_PROJ"
    else
        echo "❌ [ERROR] Models not found. Please run ./setup.sh."
        exit 1
    fi
fi

# 2. Hardware Detection for GPU Offloading
NGL=0
OS_TYPE=$(uname -s)

if command -v nvidia-smi >/dev/null 2>&1; then
    echo "🚀 NVIDIA GPU detected! Offloading to VRAM..."
    NGL=99
elif [ "$OS_TYPE" == "Darwin" ]; then
    echo "🚀 Apple Silicon/Intel detected! Enabling Metal acceleration..."
    NGL=99
else
    echo "ℹ️ Running on CPU mode..."
fi

# 3. Handle port conflicts gracefully
if command -v lsof >/dev/null 2>&1; then
    PID=$(lsof -t -i:$PORT 2>/dev/null)
    if [ ! -z "$PID" ]; then
        echo "[!] Port $PORT is occupied. Attempting to free it..."
        kill -9 $PID 2>/dev/null || true
        sleep 1
    fi
fi

echo "---------------------------------------"
echo "   SmolVLM Vision Studio Starter"
echo "---------------------------------------"
echo "[*] Server Binary: $BINARY"
echo "[*] Using Model:   $MODEL"
echo "[*] GPU Layers:    $NGL"
echo "---------------------------------------"
echo "🔗 STUDIO URL: http://localhost:$PORT"
echo "---------------------------------------"

# Launch server
"$BINARY" -m "$MODEL" --mmproj "$PROJECTOR" -ngl "$NGL" --port "$PORT" --host 0.0.0.0 --no-jinja "$@"
