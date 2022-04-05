src_file1=$1
save_hard_dir=$2
save_easy_dir=$3

if [ ! -e ${save_easy_dir} ]; then
    mkdir -p ${save_easy_dir}
fi

if [ ! -e ${save_hard_dir} ]; then
    mkdir -p ${save_hard_dir}
fi

python /home/tzc/gector/scripts/extract.py \
    ${src_file1} \
    ${save_hard_dir}/hard.src ${save_hard_dir}/hard.trg \
    ${save_easy_dir}/easy.src ${save_easy_dir}/easy.trg 

python /home/tzc/gector/utils/preprocess_data.py -s ${save_hard_dir}/hard.src -t ${save_hard_dir}/hard.trg -o ${save_hard_dir}/hard.txt 
python /home/tzc/gector/utils/preprocess_data.py -s ${save_easy_dir}/easy.src -t ${save_easy_dir}/easy.trg -o ${save_easy_dir}/easy.txt 