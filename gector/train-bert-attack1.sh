device=$1
save_dir=$2
train_set=$3
dev_set=$4
pretrain_model_dir=$5
pretrain_model_name=$6
vocab_path=$7
GECToR=/path/to/GECToR

if [ ! -d "${save_dir}" ];then
    mkdir -p ${save_dir}
else
    echo "${save_dir} already exists"
fi

export CUDA_VISIBLE_DEVICES=${device}
nohup python ${GECToR}/train.py \
    --train_set ${train_set} \
    --dev_set ${dev_set} \
    --model_dir ${save_dir} \
    --pretrain_folder ${pretrain_model_dir} \
    --pretrain ${pretrain_model_name} \
    --batch_size 64 \
    --vocab_path ${vocab_path} \
    --n_epoch 5 \
    --max_len 150 \
    --updates_per_epoch 0 \
    --accumulation_size 2 \
    --cold_steps_count 2 \
    --cold_lr 1e-4 \
    --lr 1e-6 \
    --patience 3 \
    --tn_prob 0 \
    --tp_prob 1 \
    --tune_bert 1 \
    --transformer_model bert \
    --special_tokens_fix 0 




