export CUDA_VISIBLE_DEVICES=6
save_dir=/data/tzc/model/finetune/gec/gector/stage3/roberta

if [ ! -d "${save_dir}" ];then
    mkdir ${save_dir}
else
    echo "${save_dir} already exists"
fi

nohup python ../train.py \
    --train_set /data/tzc/data/finetune/gec/wi+locness_v2.1.bea19/wi.train \
    --dev_set /data/tzc/data/finetune/gec/wi+locness_v2.1.bea19/wi.valid \
    --model_dir ${save_dir} \
    --batch_size 64 \
    --max_len 50 \
    --n_epoch 20 \
    --updates_per_epoch 0 \
    --accumulation_size 2 \
    --cold_steps_count 0 \
    --cold_lr 1e-3 \
    --tn_prob 1 \
    --tp_prob 1 \
    --patience 3 \
    --vocab_path /home/tzc/gector/data/output_vocabulary \
    --transformer_model roberta \
    --pretrain_folder /data/tzc/model/finetune/gec/gector/stage2/roberta \
    --pretrain best \
    --special_tokens_fix 1 > ${save_dir}/stage3.log 2>&1 &

watch gpustat

