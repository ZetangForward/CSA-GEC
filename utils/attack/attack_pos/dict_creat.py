import json
import string
import sys
punc = string.punctuation
def creat_dict(path_m2_1,path_m2_2,path_m2_3,path_dict):
    dict={}
    A=[]
    S=[]
    i=0
    with open(path_m2_1) as f1:
        content1=f1.readlines()
    with open(path_m2_2) as f2:
        content2=f2.readlines()
    with open(path_m2_3) as f3:
        content3=f3.readlines()
    content=content1+content2+content3
    for line in content:
        i+=1
        if line.startswith('S'):
            S=line.strip().split(' ')
            S=S[1:]
        
        S_right=list(S)
        if line.startswith('A'):
            a_temp=line.strip().split(' ')
            pos=a_temp[1]
            con=a_temp[2]
            con=con.split('|||')
            if con[1].startswith('R:'):
                S_right[int(pos)]=con[2]
                dict.setdefault(con[2],[]).append(S[int(pos)])               

    
    
    for key,value in dict.items():
        value_temp=[]
        for i in value:
            if key == i:
                continue
            if i in punc and key not in punc:
                continue
            value_temp.append(i)
        list_value = list(set(value_temp))

        dict[key]=list_value

        dict_copy={}
        for key,value in dict.items():    
            if value!=[]:
                dict_copy[key]=value
    js=json.dumps(dict)
    with open(path_dict,'w') as f4:
        f4.write(js)

if __name__=='__main__':
    path_m2_1=sys.argv[1]
    path_m2_2=sys.argv[2]
    path_m2_3=sys.argv[3]
    path_dict=sys.argv[4]
    creat_dict(path_m2_1,path_m2_2,path_m2_3,path_dict)