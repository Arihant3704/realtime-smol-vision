#!/bin/bash

# Configuration
PORT=8080

# 1. Path Logic: Prioritize local setup, fallback to global paths
LOCAL_BINARY="./llama.cpp/build/bin/llama-server"
GLOBAL_BINARY="/home/docketrun/llama.cpp/build/bin/llama-server"

LOCAL_MODEL="./models/SmolVLM-500M-Instruct-Q8_0.gguf"
LOCAL_PROJECTOR="./models/mmproj-SmolVLM-500M-Instruct-Q8_0.gguf"

# Auto-detect Binary
if [ -f "$LOCAL_BINARY" ]; then
    BINARY="$LOCAL_BINARY"
elif [ -f "$GLOBAL_BINARY" ]; then
    BINARY="$GLOBAL_BINARY"
else
    echo "[ERROR] llama-server not found. Please run ./setup.sh first."
    exit 1
fi

# Auto-detect Models
if [ -f "$LOCAL_MODEL" ]; then
    MODEL="$LOCAL_MODEL"
    PROJECTOR="$LOCAL_PROJECTOR"
else
    # Fallback to the current environment's HF cache if local models aren't found
    CACHE_DIR="/home/docketrun/.cache/huggingface/hub/models--ggml-org--SmolVLM-500M-Instruct-GGUF/snapshots/72e986006ef53e37cdd3f6d4241c90b0f01df376"
    MODEL="$CACHE_DIR/SmolVLM-500M-Instruct-Q8_0.gguf"
    PROJECTOR="$CACHE_DIR/mmproj-SmolVLM-500M-Instruct-Q8_0.gguf"
fi

echo "---------------------------------------"
echo "   SmolVLM Vision Studio Starter"
echo "---------------------------------------"

# 2. Handle port conflicts
PID=$(lsof -t -i:$PORT 2>/dev/null)
if [ ! -z "$PID" ]; then
    echo "[!] Port $PORT is occupied by PID $PID. Killing it..."
    kill -9 $PID
    sleep 1
fi

# 3. Start the server
echo "[*] Server Binary: $BINARY"
echo "[*] Using Model: $MODEL"
echo "[*] Using Projector: $PROJECTOR"
echo "---------------------------------------"

# Launch server with --no-jinja (required for SmolVLM image markers) and any extra args
"$BINARY" -m "$MODEL" --mmproj "$PROJECTOR" -ngl 99 --port "$PORT" --host 0.0.0.0 --no-jinja "$@"
