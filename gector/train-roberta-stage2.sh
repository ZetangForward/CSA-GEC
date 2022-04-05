export CUDA_VISIBLE_DEVICES=4
save_dir=/data/tzc/model/finetune/gec/gector/stage2/roberta

if [ ! -d "${save_dir}" ];then
    mkdir ${save_dir}
else
    echo "${save_dir} already exists"
fi

nohup python ../train.py \
    --train_set /data/tzc/data/finetune/gec/benchmark-incorr-data/bea2019-incorr.train \
    --dev_set /data/tzc/data/finetune/gec/benchmark-incorr-data/bea2019-incorr.valid \
    --model_dir ${save_dir} \
    --batch_size 64 \
    --max_len 50 \
    --n_epoch 20 \
    --updates_per_epoch 0 \
    --accumulation_size 2 \
    --cold_steps_count 2 \
    --cold_lr 1e-3 \
    --tn_prob 0 \
    --tp_prob 1 \
    --patience 3 \
    --vocab_path /home/tzc/gector/data/output_vocabulary \
    --transformer_model roberta \
    --pretrain_folder /data/tzc/model/pretrain/gec/gector/roberta \
    --pretrain best \
    --special_tokens_fix 1 > ${save_dir}/stage2.log 2>&1 &

watch gpustat

