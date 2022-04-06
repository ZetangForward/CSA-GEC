# cd CSA-Grammatical-Error-Correction/utils/attack/recovery
source_path=$1
golden_path=$2
model_result_path=$3
attack_pos_path=$4
# attack_pos_path=CSA-Grammatical-Error-Correction/utils/attack/attack_pos/poslist/attack_pos_1

python quick-single.py $source_path $golden_path $model_result_path $attack_pos_path