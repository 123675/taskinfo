#!/bin/bash
TRAINLOSS=$1
RELOAD=$2

PATH_TO_PRETRAINED="$HOME/code/cyvius96/save/proto-5/epoch-last.pth"
if [ -z ${RELOAD+x} ]; then echo "please specify reload 1 or 0"; exit; fi
if [ -n ${RELOAD} ]; then RELOAD_CMD="--checkpoint-state ${PATH_TO_PRETRAINED}"; fi

# Replace this accordingly
echo "CUDA visible devices $CUDA_VISIBLE_DEVICES"
TRAINLOSS=$1  # pairwiseunsupervised, pairwisesupervised, pairwisecombined
PYTHONPATH=../.. python ../../scripts/train/few_shot/run_train.py --data.dataset miniimagenet --data.root $HOME/data/miniimagenet --model.model_name "pairwise_conv" --log.exp_dir results/miniimagenet5-$TRAINLOSS --train-loss $TRAINLOSS --centroid-loss 0 --regularization 1 --iterations 100000 --data.way 5 --data.test_way 5 --data.cuda ${RELOAD_CMD} --train.learning_rate 0.0001
