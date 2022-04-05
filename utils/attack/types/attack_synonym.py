






import os
import json
import re
import nlpaug.augmenter.word as naw

attack_pos_path='/data1/tzc/fkq/pseudo/pseudo4_pos'
attack_sen_path='/data1/tzc/fkq/pseudo/pseudo4_sen'
result_path='/data1/tzc/data/ablation/internal-aug/syn/pseudo4_syn'

with open(attack_pos_path) as f2:
    pos=f2.readlines()
with open(attack_sen_path) as f3:
    sen=f3.readlines()

def search_token(sen_ori,column):
    """
    func: give some statcial data [not implementation]
    args:
        - simi_pair:
        - non_simi_pair:
    return:
        - same sentences (0 to default)
        - wrong sentences
    """
    sen_att=sen_ori.strip().split(' ')
    new_sentence=list(sen_att) # 复制一份，进行token的修改
    
    pre_token = sen_att[column]
    if pre_token!="'":
        post_token = re.sub("'", '', pre_token)
    else:
        post_token="'"
    aug = naw.SynonymAug(aug_src='wordnet')
    augmented_word = aug.augment(post_token)

    # print('verb '+sen_ori+' '+augmented_word)
    new_sentence[column]=augmented_word
    new_sentence_str=' '.join(new_sentence)    

    return new_sentence_str
    
result=""
def traversal(r,c_all):
    global result # 每一个token被攻击完后，生成的句子
    for i in range(len(c_all)):
        if i==0:
            result=search_token(sen[r],c_all[i])
        else:
            result=search_token(result,c_all[i])
    return result # 攻击完所有的token，返回最终结果
        
    
def search():
    
    r=0 # 当前在第几行
    c=0 # 当前在第几列
    c_all=[] # 所有值为1（要被攻击的）的token的位置

    with open(result_path,'w') as result_file:
        for line in pos:       
            for i in line:
                if i<='9' and i>='0':
                    if i=='1':
                        c_all.append(c)             
                    c+=1
            if c_all==[]:
                if sen[r].endswith('\n'):
                    result_file.write(sen[r]) # 将结果写入文件
                else:
                    result_file.write(sen[r]+ '\n') # 将结果写入文件
                # print(str(r)+ " is null")
            else:
                # print(c_all)
                res=traversal(r,c_all) 
                # print(str(r)+ " "+ str(res))
                
                if str(res).endswith('\n'):
                    result_file.write(str(res)) # 将结果写入文件
                else:
                    result_file.write(str(res) + '\n') # 将结果写入文件
                # print(res)
            c_all.clear()    
            c=0
            r+=1
        


if __name__=='__main__':
    search()