MODEL_DIR=$1
pre_trained_model=$2
device=$3
DATA_DIR=$4

bert_type=bert-base-cased
bert_model=/path/to/bert-model
SUBWORD_NMT=/path/to/subword_nmt                                                  
FAIRSEQ_DIR=/path/to/fairseq   
BPE_MODEL_DIR=/path/to/bpe_file
VOCAB_DIR=/path/to/vocabulary
PROCESSED_DIR=${DATA_DIR}/bert-nmt

train_src=$DATA_DIR/train.src
train_trg=$DATA_DIR/train.trg
valid_src=${DATA_DIR}/valid.src
valid_trg=${DATA_DIR}/valid.trg

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
    --keep-last-epochs 3 

  