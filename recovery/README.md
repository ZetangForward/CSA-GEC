## Calculate the correction rate
This is an instruction for calculating the correction rate.

## Environment Setup
We use the open source tools errant, so please follow the website (https://github.com/chrisjbryant/errant) to setup the environment.


## Run
Firstly, you should run the following command:
```
source errant_env/bin/activate
cd CSA-Grammatical-Error-Correction/utils/attack/recovery
```

One can run the script with `python` command like:
```
python quick-single.py src_file trg_file model_result_file attack_pos_file
```

We provide available src_file,trg_file in CSA-Grammatical-Error-Correction/utils/attack/temp, and you can try it.
The attack_pos_file is a file that record where the words in the sentence have been replaced, maybe you can find it in CSA-Grammatical-Error-Correction/utils/attack/attack_pos/poslist/.

`NOTICE`
If you want to calculate the correction rate of a sentence that one position was attacked, you should run quick-single.py, otherwise, you will run quick-multismall-pro2.py.

Notice that the number of tokens attacked in the sentence should be consistent with the parameter(attack_pos_file).

For example, you can run the script like:
python quick-multismall-pro2.py CSA-Grammatical-Error-Correction/utils/attack/temp/conll2014.src CSA-Grammatical-Error-Correction/utils/attack/temp/conll2014.trg CSA-Grammatical-Error-Correction/utils/attack/temp/m2_file_example CSA-Grammatical-Error-Correction/utils/attack/temp/attack_pos1_result CSA-Grammatical-Error-Correction/utils/attack/temp/attack_pos_1