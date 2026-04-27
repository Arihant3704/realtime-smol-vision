#!/bin/bash

# Configuration
PORT=8080
BINARY="/home/docketrun/llama.cpp/build/bin/llama-server"
# Use absolute paths to cached HF files for stability
CACHE_DIR="/home/docketrun/.cache/huggingface/hub/models--ggml-org--SmolVLM-500M-Instruct-GGUF/snapshots/72e986006ef53e37cdd3f6d4241c90b0f01df376"
MODEL="$CACHE_DIR/SmolVLM-500M-Instruct-Q8_0.gguf"
PROJECTOR="$CACHE_DIR/mmproj-SmolVLM-500M-Instruct-Q8_0.gguf"

echo "---------------------------------------"
echo "   SmolVLM Vision Studio Starter"
echo "---------------------------------------"

# 1. Handle port conflicts
PID=$(lsof -t -i:$PORT 2>/dev/null)
if [ ! -z "$PID" ]; then
    echo "[!] Port $PORT is occupied by PID $PID. Killing it..."
    kill -9 $PID
    sleep 1
fi

# 2. Check if binary exists
if [ ! -f "$BINARY" ]; then
    echo "[ERROR] llama-server not found at $BINARY"
    echo "Searching for it..."
    SEARCH_PATH=$(find /home/docketrun -name "llama-server" -type f -executable | head -n 1)
    if [ ! -z "$SEARCH_PATH" ]; then
        BINARY=$SEARCH_PATH
        echo "[INFO] Found at $BINARY"
    else
        echo "[ERROR] Could not find llama-server. Please build llama.cpp first."
        exit 1
    fi
fi

# 3. Start the server
echo "[*] Starting server with model: $MODEL"
echo "[*] Using projector: $PROJECTOR"
echo "[*] GPU Layers: 99"
echo "---------------------------------------"

# Launch server with mmproj and any extra args
"$BINARY" -m "$MODEL" --mmproj "$PROJECTOR" -ngl 99 --port "$PORT" --host 0.0.0.0 "$@"
