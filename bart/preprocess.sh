prefix_train=$1
prefix_valid=$2
INPUT_DIR=$3

for SPLIT in "${prefix_train}" "${prefix_valid}"
do
  for LANG in wp_source wp_target
  do
      python -m examples.roberta.multiprocessing_bpe_encoder \
          --encoder-json /data1/tzc/model/bart/bart-bpe/encoder.json \
          --vocab-bpe /data1/tzc/model/bart/bart-bpe/vocab.bpe \
          --inputs "${INPUT_DIR}/$SPLIT.$LANG" \
          --outputs "${INPUT_DIR}/$SPLIT.bpe.$LANG" \
          --workers 20 \
          --keep-empty;
    done
done

echo "BPE process over, begin processing"

fairseq-preprocess \
  --source-lang "wp_source" \
  --target-lang "wp_target" \
  --trainpref ${INPUT_DIR}/${prefix_train}.bpe \
  --validpref ${INPUT_DIR}/${prefix_valid}.bpe \
  --destdir ${INPUT_DIR}/bart-bin \
  --workers 20 \
  --srcdict /data1/tzc/model/pretrained-gec-en/bart-large/offical_ckp/dict.txt \
  --tgtdict /data1/tzc/model/pretrained-gec-en/bart-large/offical_ckp/dict.txt;