import sys
import os
from tqdm import trange


def extract_from_trg(src_lst1, src_lst2, trg_lst1, trg_lst2, save_hard_src, save_hard_trg, save_easy_src, save_easy_trg):    
    hard_src, hard_trg = [], []
    easy_src, easy_trg = [], []
    assert len(src_lst1) == len(src_lst2), "two file must contain the same data length"
    for i in trange(len(src_lst1)):
        src_sen1, src_sen2 = src_lst1[i], src_lst2[i]
        if(src_sen1 != src_sen2):
            hard_src.append(src_sen2)
            hard_trg.append(trg_lst2[i])
        else:
            easy_src.append(src_sen2)
            easy_trg.append(trg_lst2[i])
    hard_src = [i + '\n' for i in hard_src]
    hard_trg = [i + '\n' for i in hard_trg]
    easy_src = [i + '\n' for i in easy_src]
    easy_trg = [i + '\n' for i in easy_trg]

    with open(save_hard_src, 'w') as f1:
        f1.writelines(hard_src)
    with open(save_hard_trg, 'w') as f2:
        f2.writelines(hard_trg)
    with open(save_easy_src, 'w') as f3:
        f3.writelines(easy_src)
    with open(save_easy_trg, 'w') as f4:
        f4.writelines(easy_trg)


def sen2idx(lst):
    """
        convert sentence lst to a dict which
        contains the index of sentences
    """
    dic = dict()
    i = 0  # index from 1
    for sen in lst:
        dic[sen] = i
        i += 1
    return dic


def idx2sen(lst):
    """
        convert index to a dict which 
        contains the sentences
    """
    dic = dict()
    for i in range(len(lst)):
        dic[i] = lst[i]
    return dic


if __name__ == "__main__":
    src_file1 = sys.argv[1]  # output data
    trg_file1 = r"/data/tzc/data/finetune/gec/benchmark-incorr-data/bea2019-incorr.trg"
    src_file2 = r"/data/tzc/data/finetune/gec/benchmark-incorr-data/bea2019-incorr.src"
    trg_file2 = r"/data/tzc/data/finetune/gec/benchmark-incorr-data/bea2019-incorr.trg"
    save_hard_src = sys.argv[2]
    save_hard_trg = sys.argv[3]
    save_easy_src = sys.argv[4]
    save_easy_trg = sys.argv[5]


    with open(src_file1, 'r') as f1:
        ori_src1 = [i.strip() for i in f1.readlines()]
    with open(trg_file1, 'r') as f2:
        ori_trg1 = [i.strip() for i in f2.readlines()]
    with open(src_file2, 'r') as f3:
        ori_src2 = [i.strip() for i in f3.readlines()]
    with open(trg_file2, 'r') as f4:
        ori_trg2 = [i.strip() for i in f4.readlines()]
    sen2idx_src2, idx2sen_trg2 = sen2idx(ori_src2), idx2sen(ori_trg2)
    extract_from_trg(ori_src1, ori_src2, ori_trg1, ori_trg2, 
                    save_hard_src, save_hard_trg, save_easy_src, save_easy_trg)
    



