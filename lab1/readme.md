# Lab 1

**Task.** Create workflow for object removal.

## Provisioning script

Provisioning script loads following:
- workflow
- input images — put in `ComfyUI/input` directory
- [inpainting model](https://huggingface.co/Comfy-Org/stable_diffusion_2.1_repackaged/resolve/main/512-inpainting-ema.safetensors) — put in `ComfyUI/models/checkpoints` directory
- [comfyui-lama-remover](https://github.com/Layer-norm/comfyui-lama-remover) custom node package
- [rgthree-comfy](https://github.com/rgthree/rgthree-comfy) custom node package
- [SAM3 model](https://huggingface.co/facebook/sam3/blob/main/sam3.pt)*
- [ComfyUI-SAM3](https://github.com/PozzettiAndrea/ComfyUI-SAM3)* custom node package

_* **Note:** for using SAM3 model, you need to have a Hugging Face
account with permission to download SAM3 model
(usually, this permission is granted within 20 minutes after you apply for it).
Access Token of this account should be pasted into `HF_TOKEN`
environment variable in Vast.ai template. Frankly speaking, downloading model
explicitly in provisioning script is not necessary, because ComfyUI-SAM3 will do
this when you run it the first time (although you will still need access token).
But indeed it is better to download model explicitly in order to
keep your dependencies clear and avoid delay on first run._ 

Provisioning script is based on official Vast.ai ComfyUI template
([script link](https://raw.githubusercontent.com/vast-ai/base-image/refs/heads/main/derivatives/pytorch/derivatives/comfyui/provisioning_scripts/default.sh))
([template docs](https://cloud.vast.ai/template/readme/a0ec77570e232e570c7e89f0ac8fd0a2)).

Provisioning script link (to be pasted in
`PROVISIONING_SCRIPT` environment variable of "ComfyUI"
template in Vast.ai):
https://raw.githubusercontent.com/YaroslavDrovolskyi/deep-learning/refs/heads/main/lab1/provisioning_script.sh.