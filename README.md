# CSA-Grammatical-Error-Correction
This repo provides the source code & data construction of our paper: `Beyond Hard Samples: Robust and Effective Grammatical Error Correction with Simple Cycle Self-Augmenting` (NLPCC2023 & Preprint-Version2.0)

## Requirements
- Python >= 3.6
- torch == 1.9.1
- For evaluation, we use [ERRANT](https://github.com/chrisjbryant/errant) and [M^2Scorer](https://github.com/nusnlp/m2scorer). 

### `NOTICE`
As our **CSA** method is built upon other models, place refer to the perspective original paper for more environment details. We list the link below:
- [Transfomer](https://github.com/butsugiri/gec-pseudodata)
- [BERT-fuse](https://github.com/kanekomasahiro/bert-gec)
- [BART](https://github.com/Katsumata420/generic-pretrained-GEC)
- [LM-critic](https://github.com/michiyasunaga/LM-Critic)
- [GECToR](https://github.com/grammarly/gector) (BERT, RoBERTa, XLNet)

## Source
In this repo, we provide the following source for reproducing our results:
- perspective scripts and for finetuning different models with our **CSA** method
    - [Transforer](./transformer)
    - [BERT-fuse](./bert-fuse)
    - [BART](./bart)
    - [LM-critic](./lm-critic)
    - [GECToR](./gector)
- converged checkpoints for all the models described in paper [[link]](https://drive.google.com/drive/folders/1foVJeIV1xYrJUJ-c7au3SDj8Mq-NGi0c)
- evaluation metrics in [recovery](./recovery) and attack builder in [attack](./attack) folder
- seven attack datasets for testing the model performance and example data for quick start in [data](./data) folder
- basic data processor for extracting same or different data in [utils](./utils) folder

##
