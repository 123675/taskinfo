#!/bin/bash
FOLDER=$1
SPLIT=${2:-val}
echo "Monitoring $FOLDER"
((a = `date +%s`))
((b = `date -r $FOLDER/summary.txt +%s`))
echo "Refreshed $(( (a-b) / (60))) minutes ago"
date -r $FOLDER/summary.txt
cat $FOLDER/summary.txt|grep "$SPLIT/SupervisedAcc_softmax"
cat $FOLDER/summary.txt|grep "$SPLIT/AdjustedAcc_unsupervised"
cat $FOLDER/summary.txt|grep "$SPLIT/AdjustedAcc_unsupervised"
cat $FOLDER/summary.txt|grep "$SPLIT/AdjustedAcc_supervised"
cat $FOLDER/summary.txt|grep "$SPLIT/AdjustedLoss_unsupervised"
