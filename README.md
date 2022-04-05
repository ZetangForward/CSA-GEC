# CSA-Grammatical-Error-Correction
Code for the paper `Beyond Hard Samples: Robust and Effective Grammatical Error Correction with Simple Cycle Self-Augmenting` submitted to Computational Linguistics

## Requirements
- Python 3.6 or higher
- torch == 1.9.1
- [subword-nmt](https://github.com/rsennrich/subword-nmt)
- [fairseq](https://github.com/pytorch/fairseq) (We strongly recommend sticking with the same commit ID as for different models.)
- [transformers](https://github.com/huggingface/transformers)(We strongly recommend sticking with the same commit ID as for different models.)

### `NOTICE`
As our method is built upon other models, place refer to the perspective original paper for more environment details. We list the link below:
- [Transfomer](https://github.com/butsugiri/gec-pseudodata)
- [BERT-gec](https://github.com/kanekomasahiro/bert-gec)
- [BART](https://github.com/Katsumata420/generic-pretrained-GEC)
- [LM-critic](https://github.com/michiyasunaga/LM-Critic)
- [GECToR](https://github.com/grammarly/gector) (BERT, RoBERTa, XLNet)

## Source
In this repo, we provide the following source for reproducing our results:
- perspective scripts for finetuning different models in different folders
- converged checkpoints for all the models described in paper
- evaluation metrics and data process tools in `utils` folder
- seven attack datasets for testing the model performance

## Command
Place refer to the perspective folders.