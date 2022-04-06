alignment_file=$1
gpu=$2
result=$3
pos_dir=${result}/pos
dict=./dict_file/corr_to_err_dict.json

mkdir -p $pos_dir
mkdir -p $result

pos=$pos_dir/attack_pos.txt
sen=$pos_dir/attack_sen.txt

python attack_pos_get_not_limit6.py $alignment_file $pos $sen

python attack_antonym.py $pos $sen $result/attack_ant_result.txt
python attack_synonym.py $pos $sen $result/attack_syn_result.txt
python attack_mapping_rules.py $gpu $dict $pos $sen $result/attack_map_result.txt

