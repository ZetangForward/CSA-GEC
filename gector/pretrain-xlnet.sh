device=5
SAVE_DIR=/data/tzc/model/pretrain/gec/gector/xlnet
export CUDA_VISIBLE_DEVICES=${device}
nohup python ../train.py \
    --train_set /data/tzc/data/pretrain/a1/train.txt \
    --dev_set /data/tzc/data/pretrain/a1/valid.txt \
    --model_dir ${SAVE_DIR} \
    --batch_size 64 \
    --vocab_path /home/tzc/gector/data/output_vocabulary \
    --max_len 50 \
    --n_epoch 20 \
    --updates_per_epoch 10000 \
    --accumulation_size 4 \
    --cold_steps_count 2 \
    --cold_lr 1e-3 \
    --lr 1e-5 \
    --tune_bert 1 \
    --transformer_model xlnet \
    --special_tokens_fix 0 > ${SAVE_DIR}/xlnet-stage1.log 2>&1 &


