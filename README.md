# CSA-Grammatical-Error-Correction
Code for the paper `Beyond Hard Samples: Robust and Effective Grammatical Error Correction with Simple Cycle Self-Augmenting` submitted to Computational Linguistics

## Requirements
- Python >= 3.6
- torch == 1.9.1
- [subword-nmt](https://github.com/rsennrich/subword-nmt)
- [fairseq](https://github.com/pytorch/fairseq) (We strongly recommend sticking with the same commit ID for different models.)
- [transformers](https://github.com/huggingface/transformers)(We strongly recommend sticking with the same commit ID for different models.)

### `NOTICE`
As our method is built upon other models, place refer to the perspective original paper for more environment details. We list the link below:
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
- evaluation metrics in [recovery](./recovert) and attack builder in [attack](./attack) folder
- seven attack datasets for testing the model performance and example data for quick start in [data](./data) folder
- basic data processor for extracting same or different data in [utils](./utils) folder

