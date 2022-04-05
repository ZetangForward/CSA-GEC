# CSA-Grammatical-Error-Correction
This is the instruction for reproduce the score of Transformer model.

## Environment Setup
Place follow the instruction below to setup the environment.
```
conda create -n transformer python=3.7
git clone https://github.com/pytorch/fairseq
cd fairseq
pip install --editable ./
```

## Inference with existing checkpoing
```
bash inference.sh /path/to/test_file gpu_id /path/to/model_ckp task_name
```
The inference result is in the ./results/{task_name}

## How to reproduce the results
### Resource
The basic setup and checkpoint are referred to [pseudodata-for-gec](https://github.com/butsugiri/gec-pseudodata).

One can finetune the model with our **CSA** method on the basis of well-trained [model](https://gec-pseudo-data.s3-ap-northeast-1.amazonaws.com/ldc_giga.spell_error.finetune.checkpoint_best.pt). Before running the command below, one should install all the requirements and be familiar with the codes in [pseudodata-for-gec](https://github.com/butsugiri/gec-pseudodata).

We provide our checkpoint below:
 - [regularization data trained version]()
 - [hard samples trained version]()

### Processing
We process the data on the basis of `fairseq-preprocess`, and we provide the scipt `preprocess.sh`. One can run the following command:
```
bash preprocess.sh /path/to/data_dir
```

### Training
As for the two stage finetuning step, we provide the perspective script in this folder: `finetune.sh` for Step 1 and `finetune-wi.sh` for Step 2. 
Before running the scripts, one should set some paths of file (e.g. fairseq dir, subword_nmt, ... ) in the beginning of each file.
One can run the following command:
```
bash finetune.sh gpu_id /path/to/processed_data /path/to/save_dir /path/to/model_ckp
```
### Generating Augmentation Data & Inference
As for these two operation, it shares the same sript `inference.sh`.

For generating augmentation data, we utilize training data as source. 
For inferencing, we utilize testing data as source.


## Results
We have provided all the inference results on four clean datasets in folder ./results







