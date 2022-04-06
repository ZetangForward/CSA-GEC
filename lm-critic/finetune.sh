MODEL_DIR=$1
SAVE_DIR=$2
device=$3
train_file=$4
mkdir -p $SAVE_DIR

export CUDA_VISIBLE_DEVICES=$device
mkdir -p $SAVE_DIR

echo "start training"
nohup python3.8 -u src/run_seq2seq.py \
    --model_name_or_path $MODEL_DIR \
    --task summarization --text_column bad_detoked --summary_column good_detoked \
    --do_train --num_train_epochs 10 \
    --train_file $train_file \
    --preprocessing_num_workers 20 --overwrite_output_dir \
    --output_dir $SAVE_DIR --predict_with_generate --fp16 \
    --per_device_train_batch_size 128 --gradient_accumulation_steps 4 \
    --max_source_length 64 --max_target_length 64 \
    --logging_first_step --logging_steps 20 --save_steps 2000 
