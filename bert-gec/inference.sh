input=$1
gpu=$2
MODEL_DIR=$3
task=$4
beam=5
bert_type=bert-base-cased
SUBWORD_NMT=/path/to/subword_nmt                                                  
FAIRSEQ_DIR=/path/to/fairseq   
BPE_MODEL_DIR=/path/to/bpe_file
PROCESSED_DIR=${DATA_DIR}/bert-nmt
OUTPUT_DIR=./results/${task}

if [ -e ${OUTPUT_DIR} ]; then 
    echo '${OUTPUT_DIR} already exist'
else
    echo 'mkdir ${OUTPUT_DIR}'
    mkdir -p ${OUTPUT_DIR}
fi

$SUBWORD_NMT/apply_bpe.py -c $BPE_MODEL_DIR/bpe_code.trg.dict_bpe8000 < $input > $OUTPUT_DIR/test.bpe.src

python -u detok.py $input $OUTPUT_DIR/test.bert.src
paste -d "\n" $OUTPUT_DIR/test.bpe.src $OUTPUT_DIR/test.bert.src > $OUTPUT_DIR/test.cat.src

echo Generating...
CUDA_VISIBLE_DEVICES=$gpu python3.7 -u ${FAIRSEQ_DIR}/interactive.py $PROCESSED_DIR \
    --path ${MODEL_DIR} \
    --beam ${beam} \
    --nbest ${beam} \
    --no-progress-bar \
    -s src \
    -t trg \
    --buffer-size 2048 \
    --batch-size 128 \
    --log-format simple \
    --remove-bpe \
    --bert-model-name $bert_type \
    < $OUTPUT_DIR/test.cat.src > $OUTPUT_DIR/test.nbest.tok

cat $OUTPUT_DIR/test.nbest.tok | grep "^H"  | python -c "import sys; x = sys.stdin.readlines(); x = ' '.join([ x[i] for i in range(len(x)) if (i % ${beam} == 0) ]); print(x)" | cut -f3 > $OUTPUT_DIR/test.best.tok
sed -i '$d' $OUTPUT_DIR/test.best.tok

rm $OUTPUT_DIR/test.nbest.tok $OUTPUT_DIR/test.bpe.src $OUTPUT_DIR/test.cat.src $OUTPUT_DIR/test.bert.src
