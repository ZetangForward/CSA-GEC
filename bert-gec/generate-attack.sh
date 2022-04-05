input=/data1/tzc/gec/data/gec-en/benchmark-incorr-data/bea2019-incorr.src
gpu=4
seed=3333
beam=5
bert_type=bert-base-cased
SUBWORD_NMT=/home/tzc/subword/subword_nmt                                                            
FAIRSEQ_DIR=/home/tzc/GEC/bert-nmt
BPE_MODEL_DIR=/home/tzc/GEC/gec-pseudodata/bpe/
MODEL_DIR=/data1/tzc/model/gec-en/ablation/adding/bert-gec/cycle3/hard/stage2/checkpoint_best.pt
OUTPUT_DIR=/home/tzc/GEC/bert-gec/scripts/output/forget/cycle3-hard
PREPROCESS=/data1/tzc/gec/data/gec-en/benchmark-incorr-data/bert-nmt/bin

mkdir -p $OUTPUT_DIR

$SUBWORD_NMT/apply_bpe.py -c $BPE_MODEL_DIR/bpe_code.trg.dict_bpe8000 < $input > $OUTPUT_DIR/train.bpe.src

python -u detok.py $input $OUTPUT_DIR/train.bert.src
paste -d "\n" $OUTPUT_DIR/train.bpe.src $OUTPUT_DIR/train.bert.src > $OUTPUT_DIR/train.cat.src

echo Generating...
export CUDA_VISIBLE_DEVICES=$gpu 
python -u ${FAIRSEQ_DIR}/interactive.py $PREPROCESS \
    --path ${MODEL_DIR} \
    --beam ${beam} \
    --nbest ${beam} \
    --no-progress-bar \
    -s src \
    -t trg \
    --buffer-size 1024 \
    --batch-size 32 \
    --log-format simple \
    --remove-bpe \
    --bert-model-name $bert_type \
    < $OUTPUT_DIR/train.cat.src > $OUTPUT_DIR/train.nbest.tok

cat $OUTPUT_DIR/train.nbest.tok | grep "^H"  | python -c "import sys; x = sys.stdin.readlines(); x = ' '.join([ x[i] for i in range(len(x)) if (i % ${beam} == 0) ]); print(x)" | cut -f3 > $OUTPUT_DIR/train.best.tok
sed -i '$d' $OUTPUT_DIR/train.best.tok

# source activate py27 

# cd /home/tzc/m2scorer/scripts/

# python2 m2scorer.py /home/tzc/bert-gec/scripts/output/test.best.tok /data1/tzc/data/gec-en/data/conll14st-test-data/noalt/official-2014.combined.m2 