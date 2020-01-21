#!/bin/bash
echo "CUDA visible devices $CUDA_VISIBLEE_DEVICES"
TRAINLOSS=$1  # pairwiseunsupervised, pairwisesupervised, pairwisecombined
PYTHONPATH=../.. python ../../scripts/train/few_shot/run_train.py --data.dataset omniglot --model.model_name "pairwise_conv" --log.exp_dir results/omniglot5-$TRAINLOSS --train-loss $TRAINLOSS --centroid-loss 0 --regularization 1 --iterations 100000 --data.way 5 --data.test_way 5 --validate-interval 1 --data.cuda
