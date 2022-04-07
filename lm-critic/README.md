# CSA-Grammatical-Error-Correction
This is the instruction for reproducing the performance of LM-Critic model with our **CSA** method.

## Environment Setup
Place follow the original paper [LM-Critic](https://github.com/michiyasunaga/LM-Critic) to setup the environment.

## How to reproduce the results
### Resource
The basic setting of hyper-parameters is according to [LM-Critic](https://github.com/michiyasunaga/LM-Critic)

We also release the converged models trained with **CSA** method for testing:
 - [regularization data trained version](https://drive.google.com/file/d/1X9R9INwiDGSS31gVUucqeJMGOrkYwCKW/view?usp=sharing)
 - [hard samples trained version](https://drive.google.com/file/d/1X9R9INwiDGSS31gVUucqeJMGOrkYwCKW/view?usp=sharing)

`NOTICE`
Before running the command below, one should prepare all the requirements and be familiar with the codes in [LM-Critic](https://github.com/michiyasunaga/LM-Critic).

### Processing & Model Initializing
Since there is no checkpoint of LM-Critic model for GEC task, one should initialize a model by following the aforementioned paper and their released codes.

After training an improved fixer with BIFI algorithm and unlabeled text data, the performance of initialized model is listed below:

|  Test Dataset   | P    | R    | Score
| ---- | :---- | :---- | :----  
| CoNLL2014| 64.4 | 35.6 | 55.5  (F_0.5)
| FCE | 49.6 | 24.6 | 41.2 (F_0.5)
| BEA2019 |51.6 | 24.7 | 42.4 (ERRANT)

### Training
One can finetune the model with our **CSA** method on the basis of the aforementioned initialized model.

As for the two stage finetuning step, we provide the perspective script in this folder: `finetune.sh` for Step 1 and `finetune-WI.sh` for Step 2.

`NOTICE` Before running the scripts, one should running the following command and add `finetune` scripts to `gec/` working directory.

```
git clone https://github.com/michiyasunaga/LM-Critic
```

Before running the script, one should preprocess the data by following the original paper.
Afterward, one can run the `finetune` script with `bash` command like:
```
bash finetune.sh /path/to/model_ckp /path/to/save_dir gpu_id /path/to/processed_data 
bash finetune-WI.sh /path/to/model_ckp /path/to/save_dir gpu_id /path/to/processed_data 
```

### Generating Augmentation Data & Inference
As for these two operation, it shares the same code `run-fixer.py`.
One can run the script with `python` command like:
```
python run-fixer.py -m /path/to/model -i /path/to/input_file -o /path/to/output_file [--bea19]
```
The inference results are in the /path/to/output_file

`NOTICE`
- For generating augmentation data, we utilize training data as source. 
- For inferencing, we utilize testing data as source. 
- If testing on bea2019 evaluation dataset, place add the `--bea19` args, and vice verse.

## Results
We have provided all the inference results on four clean datasets in folder ./results










