import sys
import random


def calculate():
    """
    func: give some statcial data [not implementation]
    args:
        - simi_pair:
        - non_simi_pair:
    return:
        - same sentences (0 to default)
        - wrong sentences
    """
    pass


def write_back(set_lst, save_src, save_trg):
    """
    func:
        write list[tuple()] to trg files
    Args:
        - set_lst: list:[tuple(gen_src, ori_src, trg)]
        - save_src | save_trg : save dir
    return:
        None
    """
    with open(save_trg, 'w') as wt:
        with open(save_src, 'w') as ws:
            for item in set_lst:
                ws.write(item[0])
                wt.write(item[1])


def main(small_up_src, small_up_trg, big_down_src, big_down_trg, save_src, save_trg):
    """
    func:
        extract same and different sentences
        exclude same data from small dataset
    Args:
        - small_up_src: 
        - ...
    Return: 
        None
    """
    with open(small_up_src) as f_small_src:
        content_small_src=f_small_src.readlines()
    with open(small_up_trg) as f_small_trg:
        content_small_trg=f_small_trg.readlines()
    with open(big_down_src) as f_big_src:
        content_big_src=f_big_src.readlines()
    with open(big_down_trg) as f_big_trg:
        content_big_trg=f_big_trg.readlines()

    small_pair = [(i, j) for i, j in zip(content_small_src, content_small_trg)]
    big_pair = [(i, j) for i, j in zip(content_big_src, content_big_trg)]
    print('set finish!')

    content_small_trg = set(content_small_trg) # compress small trg
    content_small_src = set(content_small_src) # compress small src
    length = len(content_small_src)
    print("small content data size is {}".format(len(content_small_src)))
    tmp_big = [(item[0], item[1]) for item in big_pair if item[1] not in content_small_trg]  # preprocess big data set
    print("unsame data is {}".format(len(tmp_big)))
    write_back(tmp_big, save_src, save_trg) # write back tmp_big directly

if __name__ == "__main__":
    small_up_src=sys.argv[1]   
    small_up_trg=sys.argv[2]   
    big_down_src=sys.argv[3]   
    big_down_trg=sys.argv[4]   
    save_src=sys.argv[5]                                                                  
    save_trg=sys.argv[6]
    main(small_up_src, small_up_trg, big_down_src, big_down_trg, save_src, save_trg)

