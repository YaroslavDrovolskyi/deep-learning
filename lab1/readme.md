# Lab 1

**Task.** Create workflow for object removal.

## Provisioning script

Provisioning script loads following:
- workflow
- input images — put in `ComfyUI/input` directory
- inpainting model ([link](https://huggingface.co/Comfy-Org/stable_diffusion_2.1_repackaged/resolve/main/512-inpainting-ema.safetensors)) — put in `ComfyUI/models/checkpoints` directory
- [comfyui-lama-remover](https://github.com/Layer-norm/comfyui-lama-remover) custom node package
- [rgthree-comfy](https://github.com/rgthree/rgthree-comfy) custom node package

Provisioning script is based on official Vast.ai ComfyUI template
([script link](https://raw.githubusercontent.com/vast-ai/base-image/refs/heads/main/derivatives/pytorch/derivatives/comfyui/provisioning_scripts/default.sh))
([template docs](https://cloud.vast.ai/template/readme/a0ec77570e232e570c7e89f0ac8fd0a2)).

Provisioning script link (to be pasted in
`PROVISIONING_SCRIPT` environment variable of "ComfyUI"
template in Vast.ai):
https://raw.githubusercontent.com/YaroslavDrovolskyi/deep-learning/refs/heads/main/lab1/provisioning_script.sh.