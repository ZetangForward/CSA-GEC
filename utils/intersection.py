import sys

def calDiff(file1, file2):
    exist_file1, exist_file2, same = 0, 0, 0
    with open(file1, 'r') as f1:
        with open(file2, 'r') as f2:
            content1 = f1.readlines()
            content2 = f2.readlines()
            c1 = set(content1)
            c2 = set(content2)
            c3 = (c1 & c2)
            print(list(c3)[:2])
            print(len(c3))


def extract(content1, content2, save_file_src, save_file_trg):
    """
    Para:
        content: [(src, trg)]
    """
    set_c1 = set(content1)
    set_c2 = set(content2)
    print(len(set_c1), len(set_c2))
    c3 = set_c2 & set_c1   # set type
    print(len(c3))
    c3 = list(c3)
    with open(save_file_src, 'w') as f1:
        with open(save_file_trg, 'w') as f2:
            for item in c3:
                f1.write(item[0])
                f2.write(item[1])
    print("extract final")


def preprocess(ori_src_file1, ori_trg_file1, ori_src_file2, ori_trg_file2):
    with open(ori_src_file1) as f1:
        with open(ori_trg_file1) as f2:
            content1 = f1.readlines()
            content2 = f2.readlines()
            res1 = [(src, trg) for src, trg in zip(content1, content2)]
            print(len(res1))
    with open(ori_src_file2) as f3:
        with open(ori_trg_file2) as f4:
            content1 = f3.readlines()
            content2 = f4.readlines()
            res2 = [(src, trg) for src, trg in zip(content1, content2)]
            print(len(res2))
    print("preprocess final")
    return res1, res2

    
def main(ori_src_file1, ori_trg_file1, ori_src_file2, ori_trg_file2, save_file_src, save_file_trg):
    content1, content2 = preprocess(ori_src_file1, ori_trg_file1, ori_src_file2, ori_trg_file2)
    extract(content1, content2, save_file_src, save_file_trg)


if __name__=='__main__':
    ori_src_file1=sys.argv[1]
    ori_trg_file1=sys.argv[2]
    ori_src_file2=sys.argv[3]
    ori_trg_file2=sys.argv[4]
    save_file_src=sys.argv[5]
    save_file_trg=sys.argv[6]
    calDiff(ori_trg_file1, ori_trg_file2)
    main(ori_src_file1, ori_trg_file1, ori_src_file2, ori_trg_file2, save_file_src, save_file_trg)