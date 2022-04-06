# CSA-Grammatical-Error-Correction
This is the instruction for reproducing the performance of bert-fuse model with our **CSA** method.

## Environment Setup
Place follow the original paper [bert-fuse](https://github.com/kanekomasahiro/bert-fuse) to setup the environment.


## How to reproduce the results
### Resource
The basic setup and checkpoint are referred to [bert-fuse](https://github.com/kanekomasahiro/bert-fuse).
One can finetune the model with our **CSA** method on the basis of well-trained [model](https://drive.google.com/drive/folders/1h_r46EswcT1q75qwje6h6yJpOxzAG8gP?usp=sharing). 

We also release the converged models trained with **CSA** method for testing:
 - [regularization data trained version]()
 - [hard samples trained version]()

`NOTICE`
Before running the command below, one should prepare all the requirements and be familiar with the codes in [bert-fuse](https://github.com/kanekomasahiro/bert-fuse).


### Processing & Training
We process the data on the basis of `fairseq-preprocess`, and train the model with the `fairseq-train` command. We combine the process procedure and finetune procedure of stage 1 in  `finetune.sh` for , and `finetune-wi.sh` script is for Step 2. 

`NOTICE` Before running the scripts, one should set some paths of file (e.g. fairseq dir, subword_nmt, ... ) in the beginning of each script.

One can run the script with `bash` command like:
```
bash finetune.sh /path/to/save_dir /path/to/model_ckp gpu_id /path/to/data
```
### Generating Augmentation Data & Inference
As for these two operation, it shares the same sript `inference.sh`.
One can run the script with `bash` command like:
```
bash inference.sh /path/to/input_file gpu_id /path/to/model_ckp folder_name
```

The inference results are in the ./results/folder_name/test.best.tok

`NOTICE`
- For generating augmentation data, we utilize training data as source. 
- For inferencing, we utilize testing data as source.

## Results
We have provided all the inference results on four clean datasets in folder ./results







