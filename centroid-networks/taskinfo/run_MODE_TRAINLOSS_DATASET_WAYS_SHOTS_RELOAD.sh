#!/bin/bash
MODE=$1
TRAINLOSS=$2
DATASET=$3
WAYS=$4
SHOTS=${5}
RELOAD=${6}

if [[ "$MODE" != "train" && "$MODE" != "eval" ]]; then echo "mode must be train or eval";exit 1; fi 
if [[ "$MODE" == "eval" ]]; then ACTUALTRAINLOSS="evalonly"; else ACTUALTRAINLOSS="$TRAINLOSS"; fi

PATH_TO_PRETRAINED="$HOME/code/cyvius96/save/proto-5/epoch-last.pth"
if [ -z ${RELOAD+x} ]; then echo "please specify reload 1 or 0"; exit; fi
if [ -n ${RELOAD} ]; then RELOAD_CMD="--checkpoint-state ${PATH_TO_PRETRAINED}"; fi

# Replace this accordingly
echo "CUDA visible devices $CUDA_VISIBLE_DEVICES"
set -o xtrace

PYTHONPATH=.. python ../scripts/train/few_shot/run_train.py --data.dataset ${DATASET} --data.root $HOME/data/${DATASET} --model.model_name "pairwise_conv" --log.exp_dir results/${DATASET}-${WAYS}way-${SHOTS}shot-$TRAINLOSS --train-loss "${ACTUALTRAINLOSS}" --centroid-loss 0 --validate-interval 5 --iterations 100000 --data.way ${WAYS} --data.test_way ${WAYS} --train.learning_rate 0.0001 --data.cuda
