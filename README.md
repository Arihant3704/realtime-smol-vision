# SmolVLM Vision Studio 🚀

A real-time, interactive Vision-Language application powered by **SmolVLM-500M** and `llama.cpp`. This studio runs entirely locally on your laptop, supporting webcam streams, image uploads, and video analysis.

![SmolVLM Demo](demo.gif)

<img width="847" height="913" alt="image" src="https://github.com/user-attachments/assets/0ac170cb-7e61-4105-947a-5f022f6fcec4" />

## ✨ Features
- **Real-time Detection**: Automatic bounding box rendering for detected objects.
- **Cross-Platform**: Runs on **Linux**, **macOS** (Metal), and **Windows** (WSL2).
- **Video Inference**: Analyze video files frame-by-frame with live overlays.
- **Privacy First**: Everything runs 100% locally. No data leaves your machine.
- **Ultra-Lightweight**: Model package is only ~500MB.

---

## 📊 Technical Specs
| Component | Details |
| --- | --- |
| **Model** | SmolVLM-500M-Instruct (Quantized Q8_0) |
| **Architecture** | SigLIP Vision Encoder + SmolLM2 500M |
| **RAM Required** | 1 GB+ |
| **VRAM** | ~1.5 GB (Optional, runs on CPU too!) |

---

## 💻 Installation

### 1. Prerequisites
- **Linux/WSL2**: `sudo apt install git`
- **macOS**: Install [Homebrew](https://brew.sh/)
- **Windows**: Install [WSL2 (Ubuntu)](https://learn.microsoft.com/en-us/windows/wsl/install)

### 2. Setup
Clone and run the universal setup script. It will automatically detect your hardware (NVIDIA GPU, Apple Metal, or CPU) and configure everything:

```bash
git clone https://github.com/Arihant3704/realtime-smol-vision.git
cd realtime-smol-vision

# Grant permissions and run setup
chmod +x setup.sh
./setup.sh
```

### 3. Run
Start the inference server:
```bash
./start.sh
```

### 4. Open the Dashboard
Simply open `index.html` in your favorite web browser.
- **Webcam**: Click "Start Live Stream".
- **Image**: Switch to "Image Upload" tab.
- **Video**: Switch to "Video Upload" tab and select a `.mp4` or `.webm` file.

---

## 🛠️ Troubleshooting
- **Port 8080 Busy**: `start.sh` will try to clear the port, but if it fails, you can change the `PORT` variable in `start.sh`.
- **No GPU found**: The setup script will fall back to CPU mode. It's slower but still works!
- **macOS Permission**: If the camera doesn't start, ensure your browser has permission to access the webcam in System Settings.

---
*Created with ❤️ for the edge AI community.*
