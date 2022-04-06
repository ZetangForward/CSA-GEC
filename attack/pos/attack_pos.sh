alignment_file=$1
gpu=$2
result=$3
pos_dir=${result}/poslist
dict=./dict_file/corr_to_err_dict.json


mkdir -p $pos_dir
mkdir -p $result

pos1=$pos_dir/attack_pos_1.txt
pos2=$pos_dir/attack_pos_2.txt
pos3=$pos_dir/attack_pos_3.txt
pos4=$pos_dir/attack_pos_4.txt
pos5=$pos_dir/attack_pos_5.txt
sen=$pos_dir/attack_sen.txt

python attack_pos_get_1.py $alignment_file $pos1 $sen
python attack_pos_get_2-5.py $alignment_file $pos2 2
python attack_pos_get_2-5.py $alignment_file $pos3 3
python attack_pos_get_2-5.py $alignment_file $pos4 4
python attack_pos_get_2-5.py $alignment_file $pos5 5

python -u attack_pos1-5.py $gpu $dict $pos1 $sen $result/attack_pos1_result.txt
python -u attack_pos2-5.py $gpu $dict $pos2 $sen $result/attack_pos2_result.txt
python -u attack_pos2-5.py $gpu $dict $pos3 $sen $result/attack_pos3_result.txt
python -u attack_pos2-5.py $gpu $dict $pos4 $sen $result/attack_pos4_result.txt
python -u attack_pos2-5.py $gpu $dict $pos5 $sen $result/attack_pos5_result.txt
