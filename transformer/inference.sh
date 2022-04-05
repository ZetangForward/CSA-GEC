input=$1     
gpu=$2       
MODEL_DIR=$3  
seed=3333
beam=5       
SUBWORD_NMT=/home/tzc/subword/subword_nmt                                                            
FAIRSEQ_DIR=/home/tzc/bert-nmt
BPE_MODEL_DIR=/home/tzc/gec-pseudodata/bpe/
OUTPUT_DIR=./output
PREPROCESS=/data1/tzc/data/gec-en/benchmark-data/bea2019-train/bin

source activate gec  

mkdir -p $OUTPUT_DIR 

$SUBWORD_NMT/apply_bpe.py -c $BPE_MODEL_DIR/bpe_code.trg.dict_bpe8000 < $input > $OUTPUT_DIR/test.bpe.src

echo Generating...
CUDA_VISIBLE_DEVICES=$gpu python -u /home/tzc/fairseq_old/fairseq_cli/generate.py $PREPROCESS \
    --path ${MODEL_DIR} \
    --beam ${beam} \
    --no-progress-bar \
    -s src \
    -t trg \
    --unnormalized \
    --log-format simple \
    --remove-bpe \
    --nbest ${beam} \
    < $OUTPUT_DIR/test.bpe.src > $OUTPUT_DIR/test.nbest.tok


cat $OUTPUT_DIR/test.nbest.tok | grep "^H"  | python -c "import sys; x = sys.stdin.readlines(); x = ' '.join([ x[i] for i in range(len(x)) if (i % ${beam} == 0) ]); print(x)" | cut -f3 > $OUTPUT_DIR/test.best.tok
sed -i '$d' $OUTPUT_DIR/test.best.tok

source activate py27 

cd /home/tzc/m2scorer/scripts/

python2 m2scorer.py /home/tzc/fairseq_old/examples/translation/output/test.best.tok /data1/tzc/data/gec-en/data/conll14st-test-data/noalt/official-2014.combined.m2 