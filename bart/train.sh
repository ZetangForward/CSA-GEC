TOTAL_NUM_UPDATES=20000
WARMUP_UPDATES=500
LR=3e-06
MAX_TOKENS=4000
UPDATE_FREQ=1
BART_PATH=$1
SAVE_PATH=$2
DATA_DIR=$3
device=$4
fairseq_path=/home/tzc/GEC/fairseq_old



if [ ! -e ${SAVE_PATH} ]; then
    mkdir -p ${SAVE_PATH}
    cp ${BART_PATH} ${SAVE_PATH}/checkpoint_last.pt
else   
    echo save dir already exists
fi

export CUDA_VISIBLE_DEVICES=${device}
nohup python ${fairseq_path}/train.py ${DATA_DIR} \
    --save-dir ${SAVE_PATH} \
    --log-format simple \
    --log-interval 100 \
    --seed 1 \
    --max-tokens $MAX_TOKENS \
    --task translation \
    --source-lang src --target-lang trg \
    --truncate-source \
    --layernorm-embedding \
    --share-all-embeddings \
    --share-decoder-input-output-embed \
    --arch bart_large \
    --criterion label_smoothed_cross_entropy \
    --label-smoothing 0.1 \
    --keep-last-epochs 1 \
    --dropout 0.3 --attention-dropout 0.3 \
    --weight-decay 0.01 --optimizer adam \
    --adam-betas "(0.9, 0.999)" --adam-eps 1e-08 \
    --clip-norm 0.1 \
    --reset-optimizer --reset-dataloader --reset-meters \
    --lr-scheduler polynomial_decay --lr $LR \
    --total-num-update $TOTAL_NUM_UPDATES \
    --warmup-updates $WARMUP_UPDATES \
    --skip-invalid-size-inputs-valid-test \
    --max-epoch 5 > ${SAVE_PATH}/bart_large.log 2>&1 &


    