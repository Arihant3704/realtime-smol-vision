# SmolVLM Vision Studio 🚀

A real-time, interactive Vision-Language application powered by **SmolVLM-500M** and `llama.cpp`. 
<img width="847" height="913" alt="image" src="https://github.com/user-attachments/assets/0ac170cb-7e61-4105-947a-5f022f6fcec4" />

## ✨ Features
- **Real-time Bounding Boxes**: Automatically parses coordinates from the model and renders green detection boxes.
- **Modern Chat API**: Uses the high-performance `/v1/chat/completions` endpoint for superior image alignment.
- **Ultra-Lightweight**: Total model package is ~500MB.

---

## 💻 Fresh Installation (Ubuntu)

If you are setting this up on a new computer with nothing installed, follow these steps:

### 1. Clone the repository
```bash
git clone https://github.com/Arihant3704/realtime-smol-vision.git
cd realtime-smol-vision
```

### 2. Run the Setup Script
This script will install system dependencies, build `llama.cpp` with CUDA support, and download the models:
```bash
chmod +x setup.sh
./setup.sh
```

### 3. Start the Studio
Once setup is complete, simply run:
```bash
bash start.sh
```

### 4. Open the Dashboard
Open `index.html` in your browser to start the webcam or upload images.

---

## 🛠️ Technical Details
- **Architecture**: Idefics3 (SigLIP 512 + SmolLM2 360M).
- **Inference Engine**: `llama-server` (built locally during setup).
- **Flags**: Uses `--no-jinja` to ensure correct vision tokenization.

---
*Created with ❤️ for the edge AI community.*
