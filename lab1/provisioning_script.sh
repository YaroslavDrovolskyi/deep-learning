#!/bin/bash

source /venv/main/bin/activate
COMFYUI_DIR=${WORKSPACE}/ComfyUI

# Packages are installed after nodes so we can fix them...

APT_PACKAGES=(
    #"package-1"
    #"package-2"
)

PIP_PACKAGES=(
    #"package-1"
    #"package-2"
)

NODES=(
    "https://github.com/Layer-norm/comfyui-lama-remover"
    "https://github.com/rgthree/rgthree-comfy"
    "https://github.com/PozzettiAndrea/ComfyUI-SAM3"
    "https://github.com/ltdrdata/was-node-suite-comfyui"
)

WORKFLOWS=(
    "https://raw.githubusercontent.com/YaroslavDrovolskyi/deep-learning/refs/heads/main/lab1/workflow/01-object-removal-inpainting.json"
    "https://raw.githubusercontent.com/YaroslavDrovolskyi/deep-learning/refs/heads/main/lab1/workflow/02-object-segmentation-removal-inpainting.json"
)

CHECKPOINT_MODELS=(
    "https://civitai.com/api/download/models/798204?type=Model&format=SafeTensor&size=full&fp=fp16" # realvisxlV50_v50LightningBakedvae.safetensors
    "https://huggingface.co/Comfy-Org/stable_diffusion_2.1_repackaged/resolve/main/512-inpainting-ema.safetensors"
    "https://huggingface.co/facebook/sam3/resolve/main/sam3.pt" # access token will be used in provisioning_download() function
)

UNET_MODELS=(
)

LORA_MODELS=(
)

VAE_MODELS=(
)

ESRGAN_MODELS=(
)

CONTROLNET_MODELS=(
)

INPUT=(
    "https://raw.githubusercontent.com/YaroslavDrovolskyi/deep-learning/refs/heads/main/lab1/input/beach1.png"
    "https://raw.githubusercontent.com/YaroslavDrovolskyi/deep-learning/refs/heads/main/lab1/input/beach2.png"
    "https://raw.githubusercontent.com/YaroslavDrovolskyi/deep-learning/refs/heads/main/lab1/input/flowers1.png"
    "https://raw.githubusercontent.com/YaroslavDrovolskyi/deep-learning/refs/heads/main/lab1/input/flowers2.png"
    "https://raw.githubusercontent.com/YaroslavDrovolskyi/deep-learning/refs/heads/main/lab1/input/food.png"
    "https://raw.githubusercontent.com/YaroslavDrovolskyi/deep-learning/refs/heads/main/lab1/input/grass.jpg"
    "https://raw.githubusercontent.com/YaroslavDrovolskyi/deep-learning/refs/heads/main/lab1/input/man-car.png"
)

### DO NOT EDIT BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING ###

function provisioning_start() {
    provisioning_print_header
    provisioning_get_apt_packages
    provisioning_get_nodes
    provisioning_get_pip_packages
    provisioning_get_input
    provisioning_get_workflows
    provisioning_get_files \
        "${COMFYUI_DIR}/models/checkpoints" \
        "${CHECKPOINT_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/unet" \
        "${UNET_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/lora" \
        "${LORA_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/controlnet" \
        "${CONTROLNET_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/vae" \
        "${VAE_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/esrgan" \
        "${ESRGAN_MODELS[@]}"
    provisioning_print_end
}

function provisioning_get_apt_packages() {
    if [[ -n $APT_PACKAGES ]]; then
            sudo $APT_INSTALL ${APT_PACKAGES[@]}
    fi
}

function provisioning_get_pip_packages() {
    if [[ -n $PIP_PACKAGES ]]; then
            pip install --no-cache-dir ${PIP_PACKAGES[@]}
    fi
}

function provisioning_get_nodes() {
    for repo in "${NODES[@]}"; do
        dir="${repo##*/}"
        path="${COMFYUI_DIR}/custom_nodes/${dir}"
        requirements="${path}/requirements.txt"
        if [[ -d $path ]]; then
            if [[ ${AUTO_UPDATE,,} != "false" ]]; then
                printf "Updating node: %s...\n" "${repo}"
                ( cd "$path" && git pull )
                if [[ -e $requirements ]]; then
                   pip install --no-cache-dir -r "$requirements"
                fi
            fi
        else
            printf "Downloading node: %s...\n" "${repo}"
            git clone "${repo}" "${path}" --recursive
            if [[ -e $requirements ]]; then
                pip install --no-cache-dir -r "${requirements}"
            fi
        fi
    done
}

function provisioning_get_files() {
    if [[ -z $2 ]]; then return 1; fi

    dir="$1"
    mkdir -p "$dir"
    shift
    arr=("$@")
    printf "Downloading %s model(s) to %s...\n" "${#arr[@]}" "$dir"
    for url in "${arr[@]}"; do
        printf "Downloading: %s\n" "${url}"
        provisioning_download "${url}" "${dir}"
        printf "\n"
    done
}

function provisioning_print_header() {
    printf "\n##############################################\n#                                            #\n#          Provisioning container            #\n#                                            #\n#         This will take some time           #\n#                                            #\n# Your container will be ready on completion #\n#                                            #\n##############################################\n\n"
}

function provisioning_print_end() {
    printf "\nProvisioning complete:  Application will start now\n\n"
}

function provisioning_has_valid_hf_token() {
    [[ -n "$HF_TOKEN" ]] || return 1
    url="https://huggingface.co/api/whoami-v2"

    response=$(curl -o /dev/null -s -w "%{http_code}" -X GET "$url" \
        -H "Authorization: Bearer $HF_TOKEN" \
        -H "Content-Type: application/json")

    # Check if the token is valid
    if [ "$response" -eq 200 ]; then
        return 0
    else
        return 1
    fi
}

function provisioning_has_valid_civitai_token() {
    [[ -n "$CIVITAI_TOKEN" ]] || return 1
    url="https://civitai.com/api/v1/models?hidden=1&limit=1"

    response=$(curl -o /dev/null -s -w "%{http_code}" -X GET "$url" \
        -H "Authorization: Bearer $CIVITAI_TOKEN" \
        -H "Content-Type: application/json")

    # Check if the token is valid
    if [ "$response" -eq 200 ]; then
        return 0
    else
        return 1
    fi
}

# Download from $1 URL to $2 file path
function provisioning_download() {
    if [[ -n $HF_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?huggingface\.co(/|$|\?) ]]; then
        auth_token="$HF_TOKEN"
    elif
        [[ -n $CIVITAI_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?civitai\.com(/|$|\?) ]]; then
        auth_token="$CIVITAI_TOKEN"
    fi
    if [[ -n $auth_token ]];then
        wget --header="Authorization: Bearer $auth_token" -qnc --content-disposition --show-progress -e dotbytes="${3:-4M}" -P "$2" "$1"
    else
        wget -qnc --content-disposition --show-progress -e dotbytes="${3:-4M}" -P "$2" "$1"
    fi
}

# Downloads all workflows files from WORKFLOWS array
function provisioning_get_workflows() {
    WORKFLOW_DIR=${COMFYUI_DIR}/user/default/workflows

    mkdir -p "$WORKFLOW_DIR"

    # download each in WORKFLOWS array
    for url in "${WORKFLOWS[@]}"; do
        filename=$(basename "$url") # get filename from URL
        wget -O "${WORKFLOW_DIR}/${filename}" "$url"
    done
}

# Downloads all input files from INPUT array
function provisioning_get_input() {
    INPUT_DIR=${COMFYUI_DIR}/input

    # Create the directory just in case
    mkdir -p "$INPUT_DIR"

    # download each in WORKFLOWS array
    for url in "${INPUT[@]}"; do
        filename=$(basename "$url") # get filename from URL
        wget -O "${INPUT_DIR}/${filename}" "$url"
    done
}


# Allow user to disable provisioning if they started with a script they didn't want
if [[ ! -f /.noprovisioning ]]; then
    provisioning_start
fi