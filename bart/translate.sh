OUT=$1
GPU=$2
model=$3
INPUT=$4
databin=$4

mkdir -p $OUT

CUDA_VISIBLE_DEVICES=$GPU python translate.py \
  $model \
  $INPUT \
  $OUT \
  $databin

