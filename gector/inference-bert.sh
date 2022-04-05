INPUT=$1
SAVE=$2
MODEL_DIR=$3
FILE_NAME=$4
device=$5
export CUDA_VISIBLE_DEVICES=${device}

if [ ! -d "${SAVE}" ]; then
    mkdir -p ${SAVE}
else
    echo "${SAVE} already exists"
fi

python /home/tzc/gector/predict.py --model_path ${MODEL_DIR} \
                  --vocab_path /home/tzc/gector/data/output_vocabulary \
                  --input_file ${INPUT} \
                  --output_file ${SAVE}/${FILE_NAME} \
                  --iteration_count 5 \
                  --additional_confidence 0 \
                  --min_error_probability 0 \
                  --transformer_model bert \
                  --special_tokens_fix 0 \



# --additional_confidence 0.1 \
# --min_error_probability 0.4 \

# conda activate py27

# cd /home/tzc/m2scorer/scripts

# python2 m2scorer.py /home/tzc/gector/scripts/output/bert-stage1-ouput.txt /data1/tzc/data/benchmark-data/conll14st-test-data/noalt/official-2014.combined.m2



# /data1/tzc/data/attack-datasets/result.txt
# /data1/tzc/data/benchmark-data/conll14st-test-data/conll2014.src