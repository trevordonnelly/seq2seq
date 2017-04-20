#!/usr/bin/env bash

raw_data=experiments/APE17/raw_data
data_dir=experiments/APE17/edits/data

rm -rf ${data_dir}
mkdir -p ${data_dir}

if [ ! -f ${raw_data}/train.full.mt ]; then
    rename s/train/train.full/ ${raw_data}/train.{mt,src,pe}

    head -n1000 ${raw_data}/train.full.mt > ${raw_data}/train-dev.mt
    head -n1000 ${raw_data}/train.full.src > ${raw_data}/train-dev.src
    head -n1000 ${raw_data}/train.full.pe > ${raw_data}/train-dev.pe

    tail -n+1001 ${raw_data}/train.full.mt > ${raw_data}/train.mt
    tail -n+1001 ${raw_data}/train.full.src > ${raw_data}/train.src
    tail -n+1001 ${raw_data}/train.full.pe > ${raw_data}/train.pe
fi

if [ ! -f ${raw_data}/train.edits ]; then
    scripts/extract-edits.py ${raw_data}/train.{mt,pe} > ${raw_data}/train.edits
fi
if [ ! -f ${raw_data}/dev.edits ]; then
    scripts/extract-edits.py ${raw_data}/dev.{mt,pe} > ${raw_data}/dev.edits
fi
if [ ! -f ${raw_data}/train-dev.edits ]; then
    scripts/extract-edits.py ${raw_data}/train-dev.{mt,pe} > ${raw_data}/train-dev.edits
fi

cp ${raw_data}/{train,train-dev,dev}.{src,mt,pe,edits} ${data_dir}

scripts/prepare-data.py ${raw_data}/train src pe mt edits ${data_dir} --mode vocab
