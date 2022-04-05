"""
对/data1/tzc/fkq/output/test.nbest.tok(test.best.tok)的每一条数据进行被标记的token的替换，
并进行相似度计算，选出最相似的句子，作为输出结果。

"""

from transformers import DistilBertTokenizer, DistilBertModel
import torch
import torch.nn.functional as F
import os
import json
import heapq
import random
import numpy as np
from similarity import similarity
import re
from rules import word_rules
os.environ["CUDA_VISIBLE_DEVICES"] = "1"

dict_path='/data1/tzc/fkq/output/data/corr_to_err_dict1'
attack_pos_path='/data1/tzc/fkq/generate/attack_pos_2.txt'
attack_sen_path='/data1/tzc/fkq/generate/attack_sen_2-5.txt'

result_path='/data1/tzc/fkq/generate/result_pos__2.txt'

tokenizer =  DistilBertTokenizer.from_pretrained('distilbert-base-cased')
model = DistilBertModel.from_pretrained('distilbert-base-cased').cuda()

with open(dict_path,'r') as f1:
    js=f1.read()
    dict=json.loads(js)
    # print(dict)
with open(attack_pos_path) as f2:
    pos=f2.readlines()
with open(attack_sen_path) as f3:
    sen=f3.readlines()


def a_res(samples, m):
    """
    :samples: [(item, weight), ...]
    :k: number of selected items
    :returns: [(item, weight), ...]
    """

    heap = [] # [(new_weight, item), ...]
    for sample in samples:
        wi = sample[1]
        ui = random.uniform(0, 1)
        ki = ui ** (1/wi)

        if len(heap) < m:
            heapq.heappush(heap, (ki, sample))
        elif ki > heap[0][0]:
            heapq.heappush(heap, (ki, sample))

            if len(heap) > m:
                heapq.heappop(heap)

    return [item[1] for item in heap]




def search_token(sen_ori,raw,column):
    c=int(column)
    attack_token=''
    attack_token_dict=[] # 被攻击的token在字典中的替换值们
    sen_all=[]

    sen_att=sen_ori.strip().split(' ')
    new_sentence=list(sen_att) # 复制一份，进行token的修改
    
    pre_token = sen_att[c]
    if pre_token!="'":
        post_token = re.sub("'", '', pre_token)
    else:
        post_token="'"
    if post_token in dict:    
        attack_token=post_token
        attack_token_dict=dict[attack_token] 
        
        for token in attack_token_dict: # 遍历字典里的所有备选token
            new_sentence[c]=token
            sen_temp=new_sentence[:]
            sen_all.append(sen_temp) # 所有的候选句子列表

        sen_all = list(map(lambda x: ' '.join(x), sen_all))

        # 计算句子间相似度
        can_scores = similarity(sen[raw].strip(), sen_all, tokenizer, model)
        # print(can_scores)

        # 随机采样
        sample_lst=[]
        for i in range(len(can_scores)):
            sentence = sen_all[i]
            score = can_scores[i]
            sentence_pair = (sentence, score)
            sample_lst.append(sentence_pair)
        new_sentence=a_res(sample_lst,1)
        
        return str(new_sentence[0][0]) # 返回随机采样得到的句子
    else:# 如果在字典中找不到对应的单词，原样输出
        new_word=word_rules(sen_ori,c)
        new_sentence[c]=new_word
        new_sentence_str=' '.join(new_sentence)
        return new_sentence_str
    
result=""
def traversal(r,c_all):
    global result # 每一个token被攻击完后，生成的句子
    for i in range(len(c_all)):
        if i==0:
            result=search_token(sen[r],r,c_all[i])
        else:
            result=search_token(result,r,c_all[i])
    return result # 攻击完所有的token，返回最终结果
        
    
def search(dict_path,pos_path,sen_path):
    
    r=0 # 当前在第几行
    c_all=[] # 所有值为1（要被攻击的）的token的位置
    count=0
    print(count)
    with open(result_path,'w') as result_file:
        for line in pos: 
            count+=1 
            #print(count)        
            num=line[1:-2]
            if num=='-1':
                print(str(count)+'-1!')
                if sen[r].endswith('\n'):
                    result_file.write(sen[r]) # 将结果写入文件
                else:
                    result_file.write(sen[r]+ '\n') # 将结果写入文件
                r+=1
                continue
            list_c=num.strip().split(',')
            for i in list_c:
                c_all.append(i) 


            print(c_all)
            res=traversal(r,c_all) 
            print(sen[r])
            print(str(r)+ " "+ str(res))
            
            if str(res).endswith('\n'):
                result_file.write(str(res)) # 将结果写入文件
            else:
                result_file.write(str(res) + '\n') # 将结果写入文件
            c_all.clear()
   
            r+=1
        


if __name__=='__main__':
    search(dict_path,attack_pos_path,attack_sen_path)