device=$1
save_dir=$2
model_dir=$3
model_name=$4
train_set=$5
dev_set=$6
vocab_path=$7
GECToR=/path/to/GECToR


mkdir -p ${save_dir}

export CUDA_VISIBLE_DEVICES=${device}
nohup python ${GECToR}/train.py \
    --train_set ${train_set} \
    --dev_set ${dev_set} \
    --model_dir ${save_dir} \
    --pretrain_folder ${model_dir} \
    --pretrain ${model_name} \
    --batch_size 256 \
    --skip_correct 0 \
    --vocab_path ${vocab_path} \
    --max_len 100 \
    --n_epoch 3 \
    --updates_per_epoch 0 \
    --accumulation_size 2 \
    --cold_steps_count 0 \
    --cold_lr 1e-4 \
    --lr 1e-6 \
    --patience 3 \
    --tn_prob 1 \
    --tp_prob 1 \
    --tune_bert 1 \
    --transformer_model bert \
    --special_tokens_fix 0 


