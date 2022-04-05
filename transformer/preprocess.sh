DATA_DIR=$1
FAIRSEQ_DIR=/path/to/fairseq                                                           
SUBWORD_NMT=/path/to/subword_nmt
BPE_MODEL_DIR=/path/to/bpe_file
PROCESSED_DIR=${DATA_DIR}/preprocess
VOCAB_DIR=/path/to/vocabulary

train_src=${DATA_DIR}/train.src
train_trg=${DATA_DIR}/train.trg
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
fi

python $FAIRSEQ_DIR/preprocess.py --source-lang src --target-lang trg \
    --trainpref $PROCESSED_DIR/train \
    --validpref $PROCESSED_DIR/valid \
    --destdir $PROCESSED_DIR/bin \
    --srcdict $VOCAB_DIR/dict.src_bpe8000.txt \
    --tgtdict $VOCAB_DIR/dict.trg_bpe8000.txt \
    --workers $cpu_num