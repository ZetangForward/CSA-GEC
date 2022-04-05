device=$1
save_dir=$2
train_set=$3

if [ ! -d "${save_dir}" ];then
    mkdir -p ${save_dir}
else
    echo "${save_dir} already exists"
fi

export CUDA_VISIBLE_DEVICES=${device}
nohup python ../train.py \
    --train_set ${train_set} \
    --dev_set /data/tzc/data/finetune/gec/CSA/cycle1/gector/roberta/valid.txt \
    --model_dir ${save_dir} \
    --pretrain_folder /data/tzc/model/benchmark/gector \
    --pretrain roberta_1_gector \
    --batch_size 64 \
    --vocab_path /home/tzc/gector/data/output_vocabulary \
    --n_epoch 5 \
    --max_len 50 \
    --updates_per_epoch 0 \
    --accumulation_size 2 \
    --cold_steps_count 2 \
    --cold_lr 1e-4 \
    --lr 1e-6 \
    --patience 3 \
    --tn_prob 0 \
    --tp_prob 1 \
    --tune_bert 1 \
    --transformer_model roberta \
    --special_tokens_fix 1 > ${save_dir}/roberta-cycle1.log 2>&1 &

watch gpustat


