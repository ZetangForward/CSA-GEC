input=$1      # ungrammatical data txt /data1/tzc/gec/data/gec-en/benchmark-incorr-data/bea2019-incorr.src
gpu=$2
MODEL_DIR=$3  # model dir
task=$4 
seed=3333
beam=5
SUBWORD_NMT=/home/tzc/subword/subword_nmt                                                            
FAIRSEQ_DIR=/home/tzc/bert-nmt
BPE_MODEL_DIR=/home/tzc/GEC/gec-pseudodata/bpe
OUTPUT_DIR=./output/${task}
PREPROCESS=/data1/tzc/gec/data/gec-en/benchmark-data/bea2019-train/bin

mkdir -p $OUTPUT_DIR

$SUBWORD_NMT/apply_bpe.py -c $BPE_MODEL_DIR/bpe_code.trg.dict_bpe8000 < $input > $OUTPUT_DIR/test.bpe.src

echo Generating...
CUDA_VISIBLE_DEVICES=$gpu python -u /home/tzc/GEC/fairseq_old/fairseq_cli/interactive.py $PREPROCESS \
    --path ${MODEL_DIR} \
    --beam 5 \
    --no-progress-bar \
    -s src \
    -t trg \
    --buffer-size 2048 \
    --batch-size 128 \
    --log-format simple \
    --remove-bpe \
    --print-alignment \
    --nbest 5 \
    < $OUTPUT_DIR/test.bpe.src > $OUTPUT_DIR/test.nbest.tok 


cat $OUTPUT_DIR/test.nbest.tok | grep "^H"  | python -c "import sys; x = sys.stdin.readlines(); x = ' '.join([ x[i] for i in range(len(x)) if (i % ${beam} == 0) ]); print(x)" | cut -f3 > $OUTPUT_DIR/test.best.tok
sed -i '$d' $OUTPUT_DIR/test.best.tok

rm $OUTPUT_DIR/test.nbest.tok 
rm $OUTPUT_DIR/test.bpe.src


