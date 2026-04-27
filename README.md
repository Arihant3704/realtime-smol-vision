# SmolVLM Vision Studio 🚀

A real-time, interactive Vision-Language application powered by **SmolVLM-500M** and `llama.cpp`. This studio allows for both live webcam analysis and high-precision image uploads with real-time bounding box visualization.

## ✨ Features
- **Real-time Bounding Boxes**: Automatically parses coordinates from the model and renders green detection boxes.
- **Modern Chat API**: Uses the high-performance `/v1/chat/completions` endpoint for superior image alignment.
- **Optimized for SmolVLM**: Specifically tuned for the Idefics3 architecture with proper image markers and tokenization.
- **Ultra-Lightweight**: The total model package is ~500MB, fitting easily into local VRAM.

## 🚀 How to Run

### 1. Requirements
- A working build of `llama.cpp` (specifically `llama-server`).
- NVIDIA GPU with CUDA (recommended for real-time performance).

### 2. Start the Inference Server
The inference server includes the vision projector and an optimization to bypass template interference:
```bash
bash start.sh
```
*Note: This script handles port conflicts, model paths, and enables the `--no-jinja` flag required for SmolVLM.*

### 3. Open the Dashboard
Simply open `index.html` in any modern browser. 
- **Live Mode**: Uses the webcam to analyze your environment.
- **Image Upload**: Upload high-res photos for deep analysis and object detection.

## 🛠️ Technical Details
- **Architecture**: Idefics3 (SigLIP 512 + SmolLM2 360M).
- **Quantization**: Q8_0 (8-bit) for near-lossless local inference.
- **Prompt Format**: ChatML (`<|im_start|>User: <image>\n{instruction}<|im_end|>`).

---
*Created with ❤️ for the edge AI community.*
