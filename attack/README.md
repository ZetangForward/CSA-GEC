## Get the  adversarial text
This is an instruction for generating attack sentences.
- The `pos` folder contains the scripts for perturbing specific $n$ vulnerable token in one sentence.
- The `types` folder contains the scripts for perturbing sentences with three kinds of adversarial attack methods, including `antonym substitution`, `synonyms substitution`, and `mapping & rules`.

`NOTICE` 
- For `back-translation` attack method, place refer to [Noising and Denoising Natural Language: Diverse Backtranslation for Grammar Correction](https://aclanthology.org/N18-1057) and our paper for more details.
- For `mapping & rules` attack method, place refer to the paper [Improving Grammatical Error Correction Models
with Purpose-Built Adversarial Examples](https://aclanthology.org/2020.emnlp-main.228) for more details.


## Environment Setup
- We utilize the open source tools `NLPAug`, so please follow the website [[link]](https://github.com/makcedward/nlpaug) to setup the environment.
- `Nltk` package is also required, one should run the following command:
```
import nltk
nltk.download()
```

## Generate attack datasets
There are two main types of attack datasets: positional attacks and specific attacks, which are illustrated below, separately.

We create the example data in `CSA-Grammatical-Error-Correction/data` folder for better illustration.

## For positional attack datasets
Firstly, one should redirect the current directory to `pos` by running the following command:
```
cd ./CSA-Grammatical-Error-Correction/attack/pos
```
Then, following the above pipeline, or run the fully procedure script illustrated in the end:
1. Generating the alignment file which aligns the source and target sentence by applying `fairseq-interactive` function.
```
fairseq-interactive ${DATA_BIN} \
    --path ${MODEL_DIR} \
    --beam 5 \
    --nbest 5 \
    -s src \
    -t trg \
    --batch-size ${bzc} \
    --remove-bpe \
    --print-alignment \
    --nbest 5 < ${INPUT_FILE} > ${ALIGNMENT_FILE}
```
`NOTICE`
- The example of generated alignment file is `../data/sample_data/alignment_file_sample.txt` 
- The settings of `--beam` and `--nbest` must be 5, which are consistence with our code.
- We utilize a well-trained plug-and-play GEC model [[link]](https://gec-pseudo-data.s3-ap-northeast-1.amazonaws.com/ldc_giga.spell_error.finetune.checkpoint_best.pt) to align the sentences.

2. Generating the perturbance positions with the alignment file by applying the `attack_pos_get_1.py` (for single perturbance in each sentence) and `attack_pos_get_2-5.py` (for 2 to 5 perturbances in each sentence). 
- Example for single perturbance in each sentence. The results are shown in `attack_pos_1_sample.txt` and `ori_attack_sentences.txt` .
```
python attack_pos_get_1.py ../../data/sample_data/alignment_file_sample.txt ../../data/sample_data/attack_pos_1_sample.txt ../../data/sample_data/ori_attack_sentences.txt
```

- Example for 2 perturbances in each sentence. The results are shown in `attack_pos_2_sample.txt` 

```
python attack_pos_get_2-5.py ../../data/sample_data/alignment_file_sample.txt ../../data/sample_data/attack_pos_2_sample.txt 2
```
`NOTICE`: 
- The `attack_pos_get_1.py` file must be run firstly to extract the original sentence `ori_attack_sentences.txt` from alignment file for the next step.
- One can define the number of perturbances by assigning the `num` parameter in the `attack_pos_get_2-5.py` file. Theoretically, a maximum of 5 positions can be supported, but we used a maximum of 3 positions in the experiment.

3. Applying the `attack_pos{1,2}-5.py` code to get the attack results by utilizing the `ori_attack_sentences.txt`, `attack_pos.txt` and `corr_to_err_dict.json` database built by ourselves.
- Example for single perturbance in each sentence. The results are shown in `attack_pos1_result.txt` .
```
python -u attack_pos1-5.py 0 ./dict_file/corr_to_err_dict.json ../../data/sample_data/attack_pos_1_sample.txt ../../data/sample_data/ori_attack_sentences.txt ../../data/sample_data/attack_pos1_result.txt
```
- Example for two perturbances in each sentence. The results are shown in `attack_pos2_result.txt` .
```
python -u attack_pos2-5.py 0 ./dict_file/corr_to_err_dict.json ../../data/sample_data/attack_pos_2_sample.txt ../../data/sample_data/ori_attack_sentences.txt ../../data/sample_data/attack_pos2_result.txt
```
`NOTICE`
- We utilize the `BERT` model [link](https://huggingface.co/distilbert-base-uncased)  implemented with huggingface to calculate the similarity of replacing tokens when extracting them from the database. One GPU is required and one can modify the `gpu` parameter in `attack_pos{1,2}-5_result.py` to assign the GPU id.

4. **A fully procedure script** is provided. After finishing step 1, one can run the `attack_pos.sh` script with `bash` command like:
```
bash attack_pos.sh alignment_file gpu_id result_path
```
All the results are stored in `result_path`

## For specific types of attack datasets
Firstly, one should redirect the current directory to `types` by running the following command:
```
cd ./CSA-Grammatical-Error-Correction/attack/types
```
Similar to the positional attack, the whole pipeline of generating specific types of attack is:
1. Utilizing `fairseq_interactive` function to get a `alignment_file` .
2. Getting perturbance positions `positions` and original sentence `original_sentence` with `attack_pos_get_not_limit6.py` which utilizes a aforementioned plug-and-play GEC model to select the weak spots of each sentence. 
3. Applying `attack_antonym.py`, `attack_synonym.py` and `attack_mapping_rules.py` to generate specific types of attack datasets with the help of `positions` file and `original_sentence` file in step 2.

4. **A fully procedure script** is also provided. After finishing step 1, one can run the `attack_other.sh` script with `bash` command like:
```
bash attack_other.sh alignment_file gpu_id result_path
```
All the results are stored in `result_path`
