import sys
from tqdm import trange

def extract_from_trg(src_lst1, src_lst2, sen2idx_src1, idx2sen_trg1, save_file_src, save_file_trg):

    save_src1, save_trg1 = [], []
    src_set1, src_set2 = set(src_lst1), set(src_lst2)
    src_lst = list(src_set1 - src_set2)
    print(len(src_set1 - src_set2), len(src_set2 - src_set1))
    print(len(src_lst))
    for i in trange(len(src_lst)):
        src_sen1 = src_lst[i]
        trg_sen1 = idx2sen_trg1[sen2idx_src1[src_sen1]]
        save_src1.append(src_sen1)
        save_trg1.append(trg_sen1)
    save_src1 = [i + '\n' for i in save_src1]
    save_trg1 = [i + '\n' for i in save_trg1]
    with open(save_file_src, 'w') as f1:
        f1.writelines(save_src1)
    with open(save_file_trg, 'w') as f2:
        f2.writelines(save_trg1)


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
    trg_file1 = sys.argv[2]
    src_file2 = sys.argv[3]  # training src data
    trg_file2 = sys.argv[4]
    save_file_src = sys.argv[5]
    save_file_trg = sys.argv[6]
    with open(src_file1, 'r') as f1:
        ori_src1 = [i.strip() for i in f1.readlines()]
    with open(trg_file1, 'r') as f2:
        ori_trg1 = [i.strip() for i in f2.readlines()]
    with open(src_file2, 'r') as f3:
        ori_src2 = [i.strip() for i in f3.readlines()]
    with open(trg_file2, 'r') as f4:
        ori_trg2 = [i.strip() for i in f4.readlines()]
    sen2idx_src1, idx2sen_trg1 = sen2idx(ori_src1), idx2sen(ori_trg1)
    extract_from_trg(ori_src1, ori_src2, sen2idx_src1, idx2sen_trg1, save_file_src, save_file_trg)
    



