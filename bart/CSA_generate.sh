OUT=/data1/tzc/gec/data/gec-en/ablation/forget/cycle2/bart/hard
GPU=5 
model=/data1/tzc/model/gec-en/ablation/adding/bart/cycle1/hard/stage2
databin=/data1/tzc/gec/data/gec-en/benchmark-data/bea2019-train/bart-bin
INPUT=/data1/tzc/gec/data/gec-en/benchmark-incorr-data/bea2019-incorr.src

mkdir -p $OUT

export CUDA_VISIBLE_DEVICES=$GPU 
nohup python translate.py ${model} ${INPUT} ${OUT} ${databin} > ${OUT}/generate.log 2>&1 &


# bash translate.sh /home/tzc/GEC/fairseq_old/examples/translation/bart/output/benchmark \
# 5 /data1/tzc/model/gec-en/finetune/bart-large-incorr \
# /data1/tzc/gec/data/gec-en/benchmark-data/bea2019-train/bart-bin \
# /home/tzc/GEC/fairseq_old/examples/translation/test-data/conll2014.src