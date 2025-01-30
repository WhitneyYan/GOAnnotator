#!/bin/bash
export PYTHONPATH=$PYTHONPATH:../../src

DATA="GOR2023" # or SP2024/TR2024
mkdir -p ../results/${DATA}/map/
tasks=("mf" "bp" "cc")
pros=(3 3 2)
gpus=(1 2 3)
for i in ${!tasks[@]}; do
    task=${tasks[$i]}
    pro=${pros[$i]}
    gpu=${gpus[$i]}
    MAP="../results/${DATA}/map/${task}.map"
    INPUT="../../data/${DATA}/pid/${task}.pid"
    log_file="../logs/${task}_pub.log"

    CUDA_VISIBLE_DEVICES=$gpu python ../../src/run_pubretriever.py --input $INPUT --output $MAP --task $task > $log_file 2>&1 

    SAVE_DIR="results/${DATA}/"
    log_file="../logs/${task}_gor.log"
    CUDA_VISIBLE_DEVICES=$gpu python ../../src/run_goretrieverplus.py --save_dir $SAVE_DIR --task $task --data $DATA --input $MAP --pro_num $pro --filter_rank True >> $log_file 2>&1 &
done