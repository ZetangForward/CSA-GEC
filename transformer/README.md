# CSA-Grammatical-Error-Correction
This is the instruction for reproducing the score of Transformer model.

## Environment Setup
Place follow the original [paper](https://github.com/butsugiri/gec-pseudodata) (pseudodata-for-gec) to setup the environment.

## How to reproduce the results
### Resource
The basic setup and checkpoint are according to [pseudodata-for-gec](https://github.com/butsugiri/gec-pseudodata).
One can finetune the model with our **CSA** method on the basis of well-trained [model](https://gec-pseudo-data.s3-ap-northeast-1.amazonaws.com/ldc_giga.spell_error.finetune.checkpoint_best.pt). 

We also release the converged models trained with **CSA** method for testing:
 - [regularization data trained version]()
 - [hard samples trained version]()

`NOTICE`
Before running the command below, one should prepare all the requirements and be familiar with the codes in [pseudodata-for-gec](https://github.com/butsugiri/gec-pseudodata).


### Processing
We process the data on the basis of `fairseq-preprocess`, and we provide the scipt `preprocess.sh`. One can run the following command:
```
bash preprocess.sh /path/to/data_dir
```

### Training
As for the two stage finetuning step, we provide the perspective script in this folder: `finetune.sh` for Step 1 and `finetune-wi.sh` for Step 2. 

`NOTICE` Before running the scripts, one should set some paths of file (e.g. fairseq dir, subword_nmt, ... ) in the beginning of each script.

One can run the script with `bash` command like:
```
bash finetune.sh gpu_id /path/to/processed_data /path/to/save_dir /path/to/model_ckp
```
### Generating Augmentation Data & Inference
As for these two operation, it shares the same sript `inference.sh`.
One can run the script with `bash` command like:
```
bash inference.sh /path/to/input_file gpu_id /path/to/model_ckp folder_name
```

The inference results are in the ./results/folder_name/test.best.tok

`NOTICE`
For generating augmentation data, we utilize training data as source. 
For inferencing, we utilize testing data as source.


## Results
We have provided all the inference results on four clean datasets in folder ./results







