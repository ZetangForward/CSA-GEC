input=$1     
gpu=$2       
MODEL_DIR=$3 
task=$4 
seed=3333
beam=5       
FAIRSEQ_DIR=/path/to/fairseq
PROCESS_DIR=/path/to/processed_data
SUBWORD_NMT=/path/to/subword_nmt
BPE_MODEL_DIR=/path/to/bpe_file
OUTPUT_DIR=./results/${task}

mkdir -p $OUTPUT_DIR 

$SUBWORD_NMT/apply_bpe.py -c $BPE_MODEL_DIR/bpe_code.trg.dict_bpe8000 < $input > $OUTPUT_DIR/test.bpe.src

echo Generating...
CUDA_VISIBLE_DEVICES=$gpu python -u /home/tzc/fairseq_old/fairseq_cli/generate.py $PREPROCESS \
    --path $MODEL_DIR \
    --beam 5 \
    --no-progress-bar \
    -s src \
    -t trg \
    --buffer-size 4096 \
    --num-workers 10 \
    --batch-size 256 \
    --log-format simple \
    --remove-bpe \
    --print-alignment \
    --nbest 5 \
    < $OUTPUT_DIR/test.bpe.src > $OUTPUT_DIR/test.nbest.tok 

cat $OUTPUT_DIR/test.nbest.tok | grep "^H"  | python -c "import sys; x = sys.stdin.readlines(); x = ' '.join([ x[i] for i in range(len(x)) if (i % ${beam} == 0) ]); print(x)" | cut -f3 > $OUTPUT_DIR/test.best.tok
sed -i '$d' $OUTPUT_DIR/test.best.tok

rm $OUTPUT_DIR/test.nbest.tok 
rm $OUTPUT_DIR/test.bpe.src