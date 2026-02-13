# Lab 1

**Task.** Create workflow for object removal.

## Provisioning script

Provisioning script loads following:
- workflows (put them into `ComfyUI/user/default/workflows` directory)
- input images (put them into `ComfyUI/input` directory)
- checkpoint models (put them into `ComfyUI/models/checkpoints` directory)
  - [inpainting model](https://huggingface.co/Comfy-Org/stable_diffusion_2.1_repackaged/resolve/main/512-inpainting-ema.safetensors)
  - [SAM3 model](https://huggingface.co/facebook/sam3/resolve/main/sam3.pt) (*)
- custom node packages (put them into `ComfyUI/custom_nodes` directory)
  - [comfyui-lama-remover](https://github.com/Layer-norm/comfyui-lama-remover) 
  - [rgthree-comfy](https://github.com/rgthree/rgthree-comfy)
  - [ComfyUI-SAM3](https://github.com/PozzettiAndrea/ComfyUI-SAM3) (*)
  - [WAS Node Suite (Revised)](https://github.com/ltdrdata/was-node-suite-comfyui) — for merging list of masks into single mask

_(*) **Note:** for using SAM3 model, you need to have a Hugging Face
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