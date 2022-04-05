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
    --dev_set /data/tzc/data/finetune/gec/CSA/cycle1/gector/xlnet/valid.txt \
    --model_dir ${save_dir} \
    --pretrain_folder /data/tzc/model/benchmark/gector \
    --pretrain xlnet_0_gector \
    --batch_size 64 \
    --vocab_path /home/tzc/gector/data/output_vocabulary \
    --max_len 150 \
    --n_epoch 5 \
    --updates_per_epoch 0 \
    --accumulation_size 2 \
    --cold_steps_count 2 \
    --cold_lr 1e-5 \
    --lr 1e-6 \
    --patience 3 \
    --tune_bert 1 \
    --tn_prob 0 \
    --tp_prob 1 \
    --transformer_model xlnet \
    --special_tokens_fix 0 > ${save_dir}/xlnet-cycle1.log 2>&1 &

watch gpustat

