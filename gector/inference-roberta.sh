INPUT=$1
SAVE=$2
MODEL_DIR=$3
FILE_NAME=$4
device=$5
export CUDA_VISIBLE_DEVICES=${device}

mkdir -p ${SAVE}

python /home/tzc/gector/predict.py --model_path ${MODEL_DIR} \
                  --vocab_path /data/tzc/model/CSA/gector/cycle1/bert/vocabulary \
                  --input_file ${INPUT} \
                  --output_file ${SAVE}/${FILE_NAME} \
                  --iteration_count 5 \
                  --additional_confidence 0 \
                  --min_error_probability 0 \
                  --transformer_model roberta \
                  --special_tokens_fix 1 

# --additional_confidence 0.2 \
# --min_error_probability 0.5 \
# conda activate py27

# cd /home/tzc/m2scorer/scripts

# python2 m2scorer.py /home/tzc/gector/scripts/xlnet/conll.txt /data1/tzc/data/benchmark-data/conll14st-test-data/noalt/official-2014.combined.m2

# cd ~/gector/scripts


# /data1/tzc/data/attack-datasets/result.txt
# /data1/tzc/data/benchmark-data/conll14st-test-data/conll2014.src