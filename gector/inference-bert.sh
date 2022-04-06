INPUT=$1
SAVE=$2
MODEL_DIR=$3
FILE_NAME=$4
device=$5
vocab_path=$6
GECToR=/path/to/GECToR
export CUDA_VISIBLE_DEVICES=${device}

if [ ! -d "${SAVE}" ]; then
    mkdir -p ${SAVE}
else
    echo "${SAVE} already exists"
fi

python ${GECToR}/predict.py --model_path ${MODEL_DIR} \
                  --vocab_path ${vocab_path} \
                  --input_file ${INPUT} \
                  --output_file ${SAVE}/${FILE_NAME} \
                  --iteration_count 5 \
                  --additional_confidence 0 \
                  --min_error_probability 0 \
                  --transformer_model bert \
                  --special_tokens_fix 0 \
