MODEL_DIR=$1
pre_trained_model=$2
device=$3
DATA_DIR=$4

bert_type=bert-base-cased
bert_model=/data1/tzc/model/bert-gec/bert-base-cased
SUBWORD_NMT=/home/tzc/subword/subword_nmt                                                            
FAIRSEQ_DIR=/home/tzc/GEC/bert-nmt
BPE_MODEL_DIR=/home/tzc/GEC/gec-pseudodata/bpe/
VOCAB_DIR=/home/tzc/GEC/gec-pseudodata/vocab
PROCESSED_DIR=${DATA_DIR}/bert-nmt

train_src=$DATA_DIR/hard.src
train_trg=$DATA_DIR/hard.trg
valid_src=/data1/tzc/gec/data/gec-en/benchmark-incorr-data/bea2019-incorr.src
valid_trg=/data1/tzc/gec/data/gec-en/benchmark-incorr-data/bea2019-incorr.trg


cpu_num=`grep -c ^processor /proc/cpuinfo`

if [ -e $PROCESSED_DIR/bin ]; then
    echo Process file already exists
else
    mkdir -p $PROCESSED_DIR/bin

    $SUBWORD_NMT/apply_bpe.py -c $BPE_MODEL_DIR/bpe_code.trg.dict_bpe8000 < $train_src > $PROCESSED_DIR/train.src
    $SUBWORD_NMT/apply_bpe.py -c $BPE_MODEL_DIR/bpe_code.trg.dict_bpe8000 < $train_trg > $PROCESSED_DIR/train.trg
    $SUBWORD_NMT/apply_bpe.py -c $BPE_MODEL_DIR/bpe_code.trg.dict_bpe8000 < $valid_src > $PROCESSED_DIR/valid.src
    $SUBWORD_NMT/apply_bpe.py -c $BPE_MODEL_DIR/bpe_code.trg.dict_bpe8000 < $valid_trg > $PROCESSED_DIR/valid.trg

    cp $train_src $PROCESSED_DIR/train.bert.src
    cp $valid_src $PROCESSED_DIR/valid.bert.src

    python $FAIRSEQ_DIR/preprocess.py --source-lang src --target-lang trg \
        --trainpref $PROCESSED_DIR/train \
        --validpref $PROCESSED_DIR/valid \
        --destdir $PROCESSED_DIR/bin \
        --srcdict $VOCAB_DIR/dict.src_bpe8000.txt \
        --tgtdict $VOCAB_DIR/dict.trg_bpe8000.txt \
        --workers $cpu_num \
        --bert-model-name $bert_type
fi

mkdir -p $MODEL_DIR

cp $pre_trained_model $MODEL_DIR/checkpoint_last.pt

export CUDA_VISIBLE_DEVICES=${device}
nohup python3.7 -u $FAIRSEQ_DIR/train.py $PROCESSED_DIR/bin \
    --save-dir $MODEL_DIR \
    --arch transformer_s2_vaswani_wmt_en_de_big \
    --max-tokens 9012 \
    --optimizer adam \
    --lr 0.00003 \
    -s src \
    -t trg \
    --dropout 0.3 \
    --lr-scheduler reduce_lr_on_plateau \
    --lr-shrink 0.7 \
    --warmup-from-nmt \
    --warmup-nmt-file checkpoint_last.pt \
    --bert-model-name $bert_model \
    --encoder-bert-dropout \
    --encoder-bert-dropout-ratio 0.3 \
    --clip-norm 0.1 \
    --criterion label_smoothed_cross_entropy \
    --label-smoothing 0.1 \
    --max-epoch 3 \
    --adam-betas '(0.9,0.98)' \
    --log-format simple \
    --reset-lr-scheduler \
    --log-interval 30 \
    --reset-optimizer \
    --reset-meters \
    --reset-dataloader \
    --keep-last-epochs 3 > ${MODEL_DIR}/finetune.log 2>&1 & 

    # --rdrop \
    # --reg 3 

    # python2 m2scorer.py /home/tzc/bert-gec/scripts/output/test.best.tok /data1/tzc/data/gec-en/data/conll14st-test-data/noalt/official-2014.combined.m2
