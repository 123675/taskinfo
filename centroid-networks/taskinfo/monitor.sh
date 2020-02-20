#!/bin/bash
FOLDER=$1
SPLIT=${2:-val}
MODE=${3:-adjusted}

if [ "$MODE" != "adjusted" ] && [ "$MODE" != "pairwise" ]; then echo "MODE must be adjusted or pairwise"; exit 1; fi

echo "~"
echo "    < Folder: $FOLDER >    "

cat $FOLDER/summary.txt

((a = `date +%s`))
((b = `date -r $FOLDER/summary.txt +%s`))
echo "(refreshed $(( (a-b) / (60))) minutes ago)"
#date -r $FOLDER/summary.txt
cat $FOLDER/summary.txt|grep "$SPLIT/SupervisedAcc_softmax"

if [ "$MODE" = "adjusted" ]
then
	cat $FOLDER/summary.txt|grep "$SPLIT/AdjustedAcc_supervised"
	cat $FOLDER/summary.txt|grep "$SPLIT/AdjustedAcc_unsupervised"
	cat $FOLDER/summary.txt|grep "$SPLIT/AdjustedLoss_supervised"
	cat $FOLDER/summary.txt|grep "$SPLIT/AdjustedLoss_unsupervised"
else
	cat $FOLDER/summary.txt|grep "$SPLIT/PairwiseAcc_supervised"
	cat $FOLDER/summary.txt|grep "$SPLIT/PairwiseAcc_unsupervised"
	cat $FOLDER/summary.txt|grep "$SPLIT/PairwiseLoss_supervised"
	cat $FOLDER/summary.txt|grep "$SPLIT/PairwiseLoss_unsupervised"
fi

