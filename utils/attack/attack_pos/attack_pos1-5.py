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
os.environ["CUDA_VISIBLE_DEVICES"] = "0"

dict_path='/data1/tzc/fkq/output/data/corr_to_err_dict'
attack_pos_path='/data1/tzc/fkq/generate/attack_pos_1.txt'
attack_sen_path='/data1/tzc/fkq/generate/attack_sen_1-5.txt'

result_path='/data1/tzc/fkq/generate/result_pos__1.txt'

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

    heap = []
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
    attack_token_dict=[]
    sen_all=[]

    sen_att=sen_ori.strip().split(' ')
    new_sentence=list(sen_att)
    
    pre_token = sen_att[c]
    if pre_token!="'":
        post_token = re.sub("'", '', pre_token)
    else:
        post_token="'"
    if post_token in dict:    
        attack_token=post_token
        attack_token_dict=dict[attack_token] 
        
        for token in attack_token_dict:
            new_sentence[c]=token
            sen_temp=new_sentence[:]
            sen_all.append(sen_temp)

        sen_all = list(map(lambda x: ' '.join(x), sen_all))

        can_scores = similarity(sen[raw].strip(), sen_all, tokenizer, model)

        sample_lst=[]
        for i in range(len(can_scores)):
            sentence = sen_all[i]
            score = can_scores[i]
            sentence_pair = (sentence, score)
            sample_lst.append(sentence_pair)
        new_sentence=a_res(sample_lst,1)
        
        return str(new_sentence[0][0])
    else:
        new_word=word_rules(sen_ori,c)
        new_sentence[c]=new_word
        new_sentence_str=' '.join(new_sentence)
        return new_sentence_str

def traversal(r,c):

    result=search_token(sen[r],r,c)
    return result
        
    
def search(dict_path,pos_path,sen_path):
    
    r=0
    c=0
    c_all=0
    count=0
    with open(result_path,'w') as result_file:
        for line in pos:
            count+=1 
            num=line[1:-2]
            if num=='-1':
                print(str(count)+'-1!')
                if sen[r].endswith('\n'):
                    result_file.write(sen[r])
                else:
                    result_file.write(sen[r]+ '\n')
                c=0
                r+=1
                continue
            c_all=num
        

            print(c_all)
            res=traversal(r,c_all) 
            print(sen[r])
            print(str(r)+ " "+ str(res))
            
            if str(res).endswith('\n'):
                result_file.write(str(res))
            else:
                result_file.write(str(res) + '\n')
      
            c=0
            r+=1
        


if __name__=='__main__':
    search(dict_path,attack_pos_path,attack_sen_path)