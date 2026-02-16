# Lab 1

**Task.** Create ComfyUI workflow for: object detection (SAM3) -> 
object removal -> inpainting.

_For computations, use local GPU (if it is powerful enough), 
or rent some on Vast.ai._

## Provisioning script for Vast.ai

Provisioning script loads following:
- workflows (put them into `ComfyUI/user/default/workflows` directory)
- input images (put them into `ComfyUI/input` directory)
- checkpoint models (put them into `ComfyUI/models/checkpoints` directory)
  - SD 1.5 model is not in prov. script because it is downloaded automatically as default option
  - inpainting SD 1.5 model
  - inpainting SD 2.1 model
  - [SAM3 model](https://huggingface.co/facebook/sam3/resolve/main/sam3.pt) (*)
- custom node packages (put them into `ComfyUI/custom_nodes` directory)
  - [comfyui-lama-remover](https://github.com/Layer-norm/comfyui-lama-remover) 
  - [rgthree-comfy](https://github.com/rgthree/rgthree-comfy)
  - [ComfyUI-SAM3](https://github.com/PozzettiAndrea/ComfyUI-SAM3) (*)
  - [WAS Node Suite (Revised)](https://github.com/ltdrdata/was-node-suite-comfyui) — for merging list of masks into single mask
- loras

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



## Segmentation (SAM3)

Useful links:
- Tutorial: https://stable-diffusion-art.com/sam3-comfyui-image/#install-model
- Tutorial: https://www.youtube.com/watch?v=ROwlRBkiRdg
- Custom node: https://github.com/PozzettiAndrea/ComfyUI-SAM3?tab=readme-ov-file
- Documentation: https://www.runcomfy.com/comfyui-workflows/sam-3-in-comfyui-workflow-precision-image-segmentation-ai
- Custom node to merge masks:
  - Documentation: https://www.runcomfy.com/comfyui-nodes/was-node-suite-comfyui/Masks-Combine-Batch
  - Repo: https://github.com/ltdrdata/was-node-suite-comfyui


## Object removing

Useful links:
- https://www.youtube.com/watch?v=LJ0AC0aKhAY
- https://www.runcomfy.com/comfyui-nodes/comfyui-lama-remover/LamaRemover
- https://github.com/Layer-norm/comfyui-lama-remover




## Inpainting

Useful links:
- Example: https://comfyanonymous.github.io/ComfyUI_examples/inpaint/
- Tutorial: https://docs.comfy.org/tutorials/basic/inpaint#comfyui-inpainting-workflow-example
- Overal inpainting guide: https://civitai.com/articles/161/basic-inpainting-guide
- `KSampler` docs: https://docs.comfy.org/built-in-nodes/sampling/ksampler


For inpainting, **SD 1.5 model** is used:
- (used source) https://huggingface.co/stable-diffusion-v1-5/stable-diffusion-v1-5
- (alternative source) https://huggingface.co/Comfy-Org/stable-diffusion-v1-5-archive

**Other models** that could be used for inpainting:
- SD 1.5 Inpainting: https://huggingface.co/stable-diffusion-v1-5/stable-diffusion-inpainting
- SD 2.1 Inpainting (`512-inpainting-ema.safetensors`): https://huggingface.co/Comfy-Org/stable_diffusion_2.1_repackaged
- SDXL Inpainting (two sources):
  - (original) https://huggingface.co/diffusers/stable-diffusion-xl-1.0-inpainting-0.1
  - (converted to `.safetensors`) https://huggingface.co/wangqyqq/sd_xl_base_1.0_inpainting_0.1.safetensors
- FLUX1 Fill Dev: https://huggingface.co/black-forest-labs/FLUX.1-Fill-dev/tree/main
- FLUX1 Dev: https://huggingface.co/Comfy-Org/flux1-dev
- FLUX1 Kontext Dev (for image repainting): https://huggingface.co/black-forest-labs/FLUX.1-Kontext-dev


## Training LoRA

ComfyUI LoRA example: https://docs.comfy.org/tutorials/basic/lora.
Some guide: https://www.youtube.com/watch?v=qWDpPos6vrI.


LoRA was trained using Ostrich.ai Toolkit launched on Vast.ai
(template [link]()).

Trigger word is `TomTC` (abbreviated from "Tom the cat") — cat Tom from
"Tom & Jerry" cartoon series.

**Training params** (determined using this comprehensive
[guide](https://www.runcomfy.com/trainer/ai-toolkit/getting-started)):

- JOB:
    - Training Name: `sd15_inpainting_tomtc_lora`
    - Trigger Word: `TomTC`
- MODEL:
  - Model Architecture: `SD 1.5`
  - Name or Path: `stable-diffusion-v1-5/stable-diffusion-inpainting`
    _(Note: `stable-diffusion-v1-5` is the default repository option in
     Ostrich UI where to grab SD 1.5 models)_
- TARGET:
  - Target type: `LoRA`
  - Linear rank: `8` _(8–16: compact and generalizing. This is a good
    starting range for strong bases like Z‑Image Turbo and many
    SDXL / SD 1.5 setups, especially when your dataset is small
    (5–40 images or a few short clips).)_
  - Conv rank: `8` (???) _(convolution rank, which focuses more on texture
    and style layers. Higher Conv Rank emphasizes how the image is
    rendered (brush strokes, noise pattern),
    while Linear Rank leans more on what is in the image.)_
- SAVE:
  - Data Type: `BF16 (bfloat16)` _(is a great default: numerically
    stable and efficient.)_
  - Save Every: `250` (better to be the same with "Sample Every" setting)
  - Max Step Saves to Keep: `20`
- TRAINING:
  - Batch Size: `1`
  - Gradient Accumulation: `4` _(Many people run with Batch Size = 1
    and Gradient Accumulation = 2–4 on 24 GB GPUs.)_
  - Steps: `3000` _(For typical 20–50 image character LoRAs on
    modern models, 2000–3000 steps is a good starting range.)_
  - Optimizer: `AdamW8Bit` _(For most LoRAs in AI Toolkit,
    AdamW8Bit is the right choice)_
  - Learning Rate: `0.0001`
  - Weight Decay: `0.0001`
  - Timestep Bias: `Balanced`
  - Loss Type: `MSE` _(default)_
  - Use EMA: `off` _(On tight VRAM budgets, it’s reasonable
    to keep Use EMA off)_
  - Unload TE: `off`
  - Cache Text Embeddings: `off`
- ADVANCED:
  - Do Differential Guidance: `off`
- DATASETS (have only one dataset):
  - LoRA Weight: `1`
  - Caption Dropout Rate: `0.05` (Near 0 = the LoRA learns a
    strong dependency on the caption.
  - Cache Latents: `off`
  - Is Regularization: `off`
  - Resolutions: `512`
- SAMPLE _(how AI Toolkit generates preview images)_:
  - Sample Every: `250` (the best is to be the same with "Save Every" setting)
  - Sampler: `DDPM` _(for SD 1.5 / SDXL)_
  - Guidance Scale: `6` _(the same as `cfg` param in `KSampler` ComfyUI node)_
  - Seed: `42` (can be any value)
  - Walk Seed: `off` (fix the seed)
  - Sample Prompt #1: `TomTC`
  - Sample Prompt #2: `TomTC is sitting on the rug and smiling`
  - Sample Prompt #3: `Forest and sunny weather`

Two other resources about training SD 1.5 LoRA that wasn't useful:
 - https://www.digitalcreativeai.net/en/post/original-character-lora-sd15-character-training
 - https://www.scottbaker.ca/AI/LoRA-Training
 - https://discuss.huggingface.co/t/perfect-lora-training-parameters-human-character/147211/2

