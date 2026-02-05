# Lab 1

**Task.** Create workflow for object removal.

Provision script loads following:
- workflow
- input images — put in `ComfyUI/input` directory
- inpainting model ([link](https://huggingface.co/Comfy-Org/stable_diffusion_2.1_repackaged/resolve/main/512-inpainting-ema.safetensors)) — put in `ComfyUI/models/checkpoints` directory
- [comfyui-lama-remover](https://github.com/Layer-norm/comfyui-lama-remover) custom node package
- [rgthree-comfy](https://github.com/rgthree/rgthree-comfy) custom node package

Provisioning script is based on official Vast.ai ComfyUI [template](https://raw.githubusercontent.com/vast-ai/base-image/refs/heads/main/derivatives/pytorch/derivatives/comfyui/provisioning_scripts/default.sh).
