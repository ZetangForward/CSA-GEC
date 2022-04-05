OUT=$1
GPU=$2
model=$3
INPUT=$4
databin=/data1/tzc/data/story/writingPrompts/bart-bin

mkdir -p $OUT

CUDA_VISIBLE_DEVICES=$GPU python translate.py \
  $model \
  $INPUT \
  $OUT \
  $databin

# echo "begin evaluate"
# source activate py27
# cd /home/tzc/GEC/m2scorer/scripts
# python2 m2scorer.py ${OUT}/hyp.txt /data1/tzc/gec/data/gec-en/data/conll14st-test-data/noalt/official-2014.combined.m2

# source activate fairseq_old
# cd /home/tzc/GEC/fairseq_old/examples/translation/bart

# bash translate.sh /home/tzc/GEC/fairseq_old/examples/translation/bart/output/benchmark/pos1 \
# 5 /data1/tzc/model/gec-en/finetune/bart-large-incorr/stage2 \
# /data1/tzc/gec/data/gec-en/benchmark-data/bea2019-train/bart-bin \
# /data1/tzc/fkq/generate/result_pos_1.txt