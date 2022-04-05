device=$1
PROCESS_DIR=/data1/tzc/gec/data/gec-en/benchmark-data/wi+locness_v2.1.bea19/process/bin
SAVE_DIR=$2
pretain_model=$3
FAIRSEQ_DIR=/home/tzc/GEC/fairseq_old
SUBWORD_NMT=/home/tzc/subword/subword_nmt  
VOCAB_DIR=/home/tzc/gec-pseudodata/vocab
BPE_MODEL_DIR=/home/tzc/gec-pseudodata/bpe
cpu_num=`grep -c ^processor /proc/cpuinfo`

if [ -e ${SAVE_DIR} ]; then
    echo save dir already exists
else
    mkdir -p ${SAVE_DIR}
    cp ${pretain_model} ${SAVE_DIR}/checkpoint_last.pt
fi

export CUDA_VISIBLE_DEVICES=${device}
python -u ${FAIRSEQ_DIR}/train.py \
    ${PROCESS_DIR} \
    --save-dir ${SAVE_DIR} \
    -s src \
    -t trg \
    --no-progress-bar \
    --arch transformer_vaswani_wmt_en_de_big \
    --optimizer adafactor \
    --max-tokens 9012 \
    --max-sentences 256 \
    --lr 3e-5 \
    --task translation \
    --log-interval 30 \
    --dropout 0.3 \
    --clip-norm 0.1 \
    --keep-last-epochs 2 \
    --criterion label_smoothed_cross_entropy \
    --label-smoothing 0.1 \
    --skip-invalid-size-inputs-valid-test \
    --max-epoch 3 \
    --reset-optimizer \
    --reset-dataloader \
    --log-format simple > ${SAVE_DIR}/finetune.log 2>&1 &


 


   

        