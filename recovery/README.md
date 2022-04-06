## Calculate the correction rate
This is an instruction for calculating the correction rate $TR$ and $SR$.

## Environment Setup
We use the open source tools `errant`, please follow the website [[link]](https://github.com/chrisjbryant/errant) to setup the environment.

# Evaluation with our code
Firstly, one should redirect the current directory to `recovery` by running the following command:
```
cd ./CSA-Grammatical-Error-Correction/recovery
```
## Single perturbance in each sentence
For single perturbance in each sentence, one can run the `quick-single.py` file with the following command:
```
python quick-single.py src_file trg_file model_result attack_pos_file
```
- `src_file` and `trg_file` denote for the original files which contain ungrammatical sentences and corresponding grammatical sentences.
- `model_result` represents for the inference results by GEC model .
- `attack_pos_file` is the perturbance position file which can be acquired by running `attack_pos_get_1.py` or `attack_pos_get_2-5.py` in `attack` directory.

## Multiple perturbances in each sentence
For multiple perturbances in each sentence, one can run the `quick-multi.py` file with the following command:
```
python quick-multi.py src_file trg_file model_result attack_pos
```

We provide available `sample.src` (src_file), `sample.trg` (trg_file) and `model_result_sample.txt` (model_result) in [CSA-Grammatical-Error-Correction/data](../data) folder for testing and quick start.
