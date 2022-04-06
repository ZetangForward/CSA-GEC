import sys
import json
import re
import nlpaug.augmenter.word as naw


def search_token(sen_ori,column):
    sen_att=sen_ori.strip().split(' ')
    new_sentence=list(sen_att)
    
    pre_token = sen_att[column]
    
    if pre_token!="'":
        post_token = re.sub("'", '', pre_token)
    else:
        post_token="'"
    aug = naw.AntonymAug()
    augmented_word = aug.augment(post_token)

    new_sentence[column]=augmented_word
    new_sentence_str=' '.join(new_sentence)    

    return new_sentence_str
    
result=""
def traversal(r,c_all):
    global result
    for i in range(len(c_all)):
        if i==0:
            result=search_token(sen[r],c_all[i])
        else:
            result=search_token(result,c_all[i])
    return result
        
    
def search(pos,sen):
    
    r=0
    c=0
    c_all=[]

    with open(result_path,'w') as result_file:
        for line in pos:  
            for i in line:
                if i<='9' and i>='0':
                    if i=='1':
                        c_all.append(c)             
                    c+=1
            if c_all==[]:
                if sen[r].endswith('\n'):
                    result_file.write(sen[r])
                else:
                    result_file.write(sen[r]+ '\n')
            else:
                res=traversal(r,c_all) 
                
                if str(res).endswith('\n'):
                    result_file.write(str(res))
                else:
                    result_file.write(str(res) + '\n')
            c_all.clear()    
            c=0
            r+=1
        


if __name__=='__main__':
    attack_pos_path=sys.argv[1] 
    attack_sen_path=sys.argv[2] 
    result_path=sys.argv[3] 

    with open(attack_pos_path) as f2:
        pos=f2.readlines()
    with open(attack_sen_path) as f3:
        sen=f3.readlines()
    search(pos,sen)