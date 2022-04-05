SAVE_DIR=/data1/tzc/model/pretrained-gec-en/bart-large
FAIRSEQ_DIR=/home/tzc/GEC/fairseq_old
PROCESS_DIR=/data1/tzc/gec/pretain-data/a1/bart-bpe
cpu_num=`grep -c ^processor /proc/cpuinfo`
device=0,1,2,3,4,5

mkdir -p ${SAVE_DIR}

export CUDA_VISIBLE_DEVICES=${device}
nohup python -u ${FAIRSEQ_DIR}/train.py \
    ${PROCESS_DIR} \
    --save-dir ${SAVE_DIR} \
    --fp16 \
    -s src \
    -t trg \
    --no-progress-bar \
    --arch bart_large \
    --truncate-source \
    --optimizer adam --adam-betas "(0.9, 0.999)" --adam-eps 1e-08 \
    --max-tokens 4096 \
    --max-sentences 512 \
    --lr 3e-5 \
    --lr-scheduler inverse_sqrt \
    --warmup-updates 500 \
    --task translation \
    --log-interval 30 \
    --dropout 0.1 \
    --attention-dropout 0.1 \
    --clip-norm 0.1 \
    --keep-last-epochs 4 \
    --criterion label_smoothed_cross_entropy \
    --label-smoothing 0.1 \
    --skip-invalid-size-inputs-valid-test \
    --max-epoch 50 \
    --tensorboard-logdir ${SAVE_DIR}/log \
    --log-format simple \
    --adam-betas '(0.9,0.98)' >> ${SAVE_DIR}/bart_large.log 2>&1 &


watch gpustat