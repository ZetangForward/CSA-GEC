# CSA-Grammatical-Error-Correction
This is the instruction for reproducing the score of GECToR model including BERT, RoBERTa and XLNet.

## Environment Setup
Place follow the original [paper](https://github.com/grammarly/gector) (GECToR) to setup the environment.

## How to reproduce the results
### Resource
The basic checkpoints can be referred to :
- BERT [[link](https://grammarly-nlp-data-public.s3.amazonaws.com/gector/bert_0_gectorv2.th)]
- RoBERTa [[link](https://grammarly-nlp-data-public.s3.amazonaws.com/gector/roberta_1_gectorv2.th)]
- XLNet [[link](https://grammarly-nlp-data-public.s3.amazonaws.com/gector/xlnet_0_gectorv2.th)]

One can finetune the model with our **CSA** method on the basis of well-trained [model](https://drive.google.com/drive/folders/1h_r46EswcT1q75qwje6h6yJpOxzAG8gP?usp=sharing). 

We also release the converged models trained with **CSA** method for testing:
 - [regularization data trained version]()
 - [hard samples trained version]()

`NOTICE`
Before running the command below, one should prepare all the requirements and be familiar with the codes in [GECToR](https://github.com/grammarly/gector).

### Processing & Training
One can follow the processing procedure in original paper, and utilize `train-{bert,roberta,xlnet}-attack1.sh` for training Step 2 and `train-{bert,roberta,xlnet}-attack1-WI.sh` for training Step 3 with regularization data.

`NOTICE` Before running the scripts, one should set the path of GECToR file in the beginning of each script and the set of vocabulary and training procedure is sticking to the original paper.

One can run the script with `bash` command like:
```
bash train-bert-attack1.sh gpu_id /path/to/save_dir /path/to/train_file /path/to/dev_file /path/to/model_ckp_dir /path/to/model_name /path/to/vocabulary

bash train-bert-attack1-WI.sh /path/to/save_dir /path/to/train_file /path/to/dev_file /path/to/model_ckp_dir /path/to/model_name /path/to/vocabulary
```
### Generating Augmentation Data & Inference
As for these two operation, it shares the same sript `inference-{bert,roberta,xlnet}.sh`.
One can run the script with `bash` command like:
```
bash inference-bert.sh /path/to/input_file /path/to/save /path/to/model_dir name_of_output_file gpu_id /path/to/vocabulary
```

The inference results are in the /path/to/save/name_of_output_file

`NOTICE`
For generating augmentation data, we utilize training data as source. 
For inferencing, we utilize testing data as source, and the setting of `additional_confidence` and `min_error_probability` are same as the original paper.

## Results
We have provided all the inference results on four clean datasets in folder ./results







