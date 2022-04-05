device=$1
save_dir=$2
model=$3

mkdir -p ${save_dir}

export CUDA_VISIBLE_DEVICES=${device}
nohup python ../train.py \
    --train_set /data/tzc/data/finetune/gec/wi+locness_v2.1.bea19/wi.train \
    --dev_set /data/tzc/data/finetune/gec/wi+locness_v2.1.bea19/wi.valid \
    --model_dir ${save_dir} \
    --pretrain_folder ${model} \
    --pretrain best \
    --batch_size 256 \
    --skip_correct 0 \
    --vocab_path /home/tzc/gector/data/output_vocabulary \
    --max_len 100 \
    --n_epoch 3 \
    --updates_per_epoch 0 \
    --accumulation_size 2 \
    --cold_steps_count 0 \
    --cold_lr 1e-4 \
    --lr 1e-6 \
    --patience 3 \
    --tune_bert 1 \
    --tn_prob 1 \
    --tp_prob 1 \
    --transformer_model xlnet \
    --special_tokens_fix 0 > ${save_dir}/CSA_wi.log 2>&1 &


