import argparse

def rm_same(file1, file2):
    content1, content2 = [], []
    with open(file1, 'r') as f1:
        with open(file2, 'r') as f2:
            for sen1, sen2 in zip(f1, f2):
                if sen1 != sen2:
                    content1.append(sen1)
                    content2.append(sen2)
    return content1, content2

def writeback(new_file1, new_file2, content1, content2):
    print("{} length is :".format(new_file1) + str(len(content1)))
    print("{} length is :".format(new_file2) + str(len(content2)))
    with open(new_file1, 'w') as f1:
        f1.writelines(content1)
    with open(new_file2, 'w') as f2:
        f2.writelines(content2)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="remove same sentences in the parallal data")
    parser.add_argument("--src", type=str)
    parser.add_argument('--trg', type=str)
    parser.add_argument('--new_src', type=str)
    parser.add_argument('--new_trg', type=str)
    args = parser.parse_args()
    content1, content2 = rm_same(args.src, args.trg)
    writeback(args.new_src, args.new_trg, content1, content2)



