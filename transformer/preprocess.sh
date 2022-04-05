DATA_DIR=$1
SUBWORD_NMT=/home/tzc/subword/subword_nmt                                                            
FAIRSEQ_DIR=/home/tzc/GEC/fairseq_old/fairseq_cli
BPE_MODEL_DIR=/home/tzc/GEC/gec-pseudodata/bpe
PROCESSED_DIR=${DATA_DIR}/preprocess
VOCAB_DIR=/home/tzc/GEC/gec-pseudodata/vocab

train_src=${DATA_DIR}/hard.src
train_trg=${DATA_DIR}/hard.trg
valid_src=/data1/tzc/gec/data/gec-en/benchmark-incorr-data/bea2019-valid.src
valid_trg=/data1/tzc/gec/data/gec-en/benchmark-incorr-data/bea2019-valid.trg

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
    --workers 20