################################################################################
# run the following commands one by one in the `gec/` directory of the repo
################################################################################

# conda activate lm-critic

############### Train the fixer ###############
# dt=`date '+%Y%m%d_%H%M%S'`
MODEL_DIR=$1
SAVE_DIR=$2
device=$3
mkdir -p $SAVE_DIR


export CUDA_VISIBLE_DEVICES=${device}
echo "start training"
nohup python3.8 -u src/run_seq2seq.py \
    --model_name_or_path ${MODEL_DIR} \
    --task summarization --text_column bad_detoked --summary_column good_detoked \
    --do_train --num_train_epochs 300 --train_file /data/tzc/data/finetune/gec/wi+locness_v2.1.bea19/train.json \
    --preprocessing_num_workers 20 --overwrite_output_dir --output_dir ${SAVE_DIR} --predict_with_generate --fp16 \
    --per_device_train_batch_size 128 --gradient_accumulation_steps 4 --max_source_length 64 --max_target_length 64 \
    --logging_first_step --logging_steps 20 --save_steps 2000 > ${SAVE_DIR}/log.txt 2>&1 &



############### Run the fixer on benchmarks ###############
# model_path=data/round1__BIFI/model-fixer
#BEA2019
# python src/run_fixer.py -m $model_path -i benchmarks/wi+locness_v2.1.bea19/m2/ABCN.dev.bea19.orig.txt -o /home/tzc/LM-Critic/gec/predictions/bea19dev.out.txt --bea19
#CoNLL2014
# python src/run_fixer.py -m $model_path -i /data1/tzc/data/benchmark-data/conll14st-test-data/conll2014.src -o /home/tzc/LM-Critic/gec/predictions/conll14.out.txt
#GMEG-wiki
# python src/run_fixer.py -m $model_path -i benchmarks/GMEG/data/test/wiki/source -o $model_path/predictions/gmeg.wiki.out.txt
#GMEG-yahoo
# python src/run_fixer.py -m $model_path -i benchmarks/GMEG/data/test/yahoo/source -o $model_path/predictions/gmeg.yahoo.out.txt



############### Evaluate the fixer outputs ###############
#CoNLL2014
# python2 benchmarks/m2scorer/scripts/m2scorer.py $model_path/predictions/conll14.out.txt \
#     benchmarks/conll14st-test-data/noalt/official-2014.combined.m2 | tee $model_path/predictions/conll14.eval.txt
# Precision   : 0.6444
# Recall      : 0.3569
# F_0.5       : 0.5550

#BEA2019 and GMEG uses errant scorer, which needs its own environment
# conda deactivate
# conda activate errant200

#BEA2019
# errant_parallel -orig benchmarks/wi+locness_v2.1.bea19/m2/ABCN.dev.bea19.orig.txt \
#                 -cor $model_path/predictions/bea19dev.out.txt \
#                 -out $model_path/predictions/bea19dev.outm2.txt && \
# errant_compare  -hyp $model_path/predictions/bea19dev.outm2.txt -ref benchmarks/wi+locness_v2.1.bea19/m2/ABCN.dev.gold.bea19.m2 | tee $model_path/predictions/bea19dev.eval.txt
# =========== Span-Based Correction ============
# TP	FP	FN	Prec	Rec	F0.5
# 1848	1733	5613	0.5161	0.2477	0.4241
# ==============================================

#GEMG-wiki
# errant_parallel -orig benchmarks/GMEG/data/test/wiki/source \
#                 -cor $model_path/predictions/gmeg.wiki.out.txt \
#                 -out $model_path/predictions/gmeg.wiki.outm2.txt && \
# errant_compare  -hyp $model_path/predictions/gmeg.wiki.outm2.txt -ref benchmarks/GMEG/data/test/wiki/ref.m2 | tee $model_path/predictions/gmeg.wiki.eval.txt
# =========== Span-Based Correction ============
# TP	FP	FN	Prec	Rec	F0.5
# 468	339	925	0.5799	0.336	0.5064
# ==============================================

#GEMG-yahoo
# errant_parallel -orig benchmarks/GMEG/data/test/yahoo/source \
#                 -cor $model_path/predictions/gmeg.yahoo.out.txt \
#                 -out $model_path/predictions/gmeg.yahoo.outm2.txt && \
# errant_compare  -hyp $model_path/predictions/gmeg.yahoo.outm2.txt -ref benchmarks/GMEG/data/test/yahoo/ref.m2 | tee $model_path/predictions/gmeg.yahoo.eval.txt
# =========== Span-Based Correction ============
# TP	FP	FN	Prec	Rec	F0.5
# 382	329	428	0.5373	0.4716	0.5227
# ==============================================
