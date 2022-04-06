import torch
import torch.nn.functional as F
import os
# os.environ["CUDA_VISIBLE_DEVICES"] = "0"


def similarity(original_sen, candidata_sen_lst, tokenizer=None, model=None, lambda_=1e-6, gpu=0):
    os.environ["CUDA_VISIBLE_DEVICES"] = gpu
    inputs = tokenizer(original_sen, return_tensors="pt")
    for item in inputs:
        inputs[item] = inputs[item].cuda()

    outputs = model(**inputs)
    last_hidden_states = outputs.last_hidden_state
    ori_hidden_state = last_hidden_states.squeeze(dim=0)

    can_hidden_stats = []
    for candidate in candidata_sen_lst:
        inputs = tokenizer(candidate, return_tensors="pt")
        for item in inputs:
            inputs[item] = inputs[item].cuda()
        outputs = model(**inputs)
        last_hidden_states = outputs.last_hidden_state
        can_hidden_state = last_hidden_states.squeeze(dim=0)
        can_hidden_stats.append(can_hidden_state)

    can_cosine_socres = []
    for can_hidden_stat in can_hidden_stats:
        if can_hidden_stat.size(0) != ori_hidden_state.size(0):
            can_cosine_socres.append(lambda_)
        else:
            score = F.cosine_similarity(ori_hidden_state, can_hidden_stat)
            score = score.cpu()
            score = score.detach().numpy()
            can_cosine_socres.append(score.mean())

    return can_cosine_socres


