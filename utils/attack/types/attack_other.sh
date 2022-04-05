# cd CSA-Grammatical-Error-Correction/utils/attack/types
m2_file=$1
pos_dir='poslist'
result='result'

mkdir -p $pos_dir
mkdir -p $result

pos=$pos_dir/attack_pos
sen=$pos_dir/attack_sen

python attack_pos_get_not_limit6.py $m2_file $pos $sen

python attack_antonym.py $pos $sen $result/attack_ant_result
python attack_synonym.py $pos $sen $result/attack_syn_result
python attack_mapping_rules.py $pos $sen $result/attack_ant_result
