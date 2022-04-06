# CSA-Grammatical-Error-Correction
This is the instruction for reproducing the score of BART model.

## Environment Setup
Place follow the original [paper](https://github.com/Katsumata420/generic-pretrained-GEC/tree/master/BART-GEC) (generic-pretrained-GEC) to setup the environment.

## How to reproduce the results
### Resource
The basic setup and checkpoint are according to [generic-pretrained-GEC](https://github.com/Katsumata420/generic-pretrained-GEC/tree/master/BART-GEC).

`NOTICE`
Before running the command below, one should prepare all the requirements and be familiar with the codes in [generic-pretrained-GEC](https://github.com/Katsumata420/generic-pretrained-GEC/tree/master/BART-GEC).

We provide our checkpoints as listing below:
 - [regularization data trained version]()
 - [hard samples trained version]()


### Processing & Model Initializing
As there is no checkpoint of BART model for GEC task, one should initialize a BART model by following the aforementioned paper and their released codes.

After finetuning the pretrained [BART](https://dl.fbaipublicfiles.com/fairseq/models/bart.large.tar.gz) model, the performance of initialized model is listed below:

|   Dataset   | P    | R    | F_0.5 
| ---- | :---- | :---- | :----  
| CoNLL2014| 69.3 | 45.0 | 62.6 
| BEA2019 |68.3 | 57.1 |65.6
| FCE | 59.6 | 40.3 | 54.4

### Training
One can finetune the model with our **CSA** method on the basis of the aforementioned initialized model.

As for the two stage finetuning step, we provide the perspective script in this folder: `finetune.sh` for Step 1 and `finetune-wi.sh` for Step 2, and we also provide the `preprocess.sh` for data preprocessing.

`NOTICE` Before running the scripts, one should set some paths of file (e.g. fairseq dir, subword_nmt, ... ) in the beginning of each script.

One can run the script with `bash` command like:
```
bash preprocess.sh train valid /path/to/input_dir
bash finetune.sh /path/to/model_ckp /path/to/save_dir gpu_id /path/to/processed_data 
```
### Generating Augmentation Data & Inference
As for these two operation, it shares the same sript `inference.sh` and code `translate.py`.
One can run the script with `bash` command like:
```
bash inference.sh /path/to/output_file gpu_id /path/to/model_ckp /path/to/input_file
```

The inference results are in the /path/to/output_file/hyp.txt

`NOTICE`
For generating augmentation data, we utilize training data as source. 
For inferencing, we utilize testing data as source.

## Results
We have provided all the inference results on four clean datasets in folder ./results







