import errant
# 一个位置
annotator = errant.load('en')

src_path='/home/fkq/py_file/conll2014.src'
golden_path='/home/fkq/py_file/conll2014.trg'
# 要测评的文件地址
model_result_path='/home/fkq/py_file/Study/pos1'
attack_pos_path='/home/fkq/py_file/pos/attack_pos_1.txt'
# attacked_sen_path='/home/fkq/py_file/temp_attack'
with open(src_path) as f1:
    src_content=f1.readlines()
with open(golden_path) as f2:
    golden_path_content=f2.readlines()
with open(model_result_path) as f3:
    model_result_content=f3.readlines()
with open(attack_pos_path) as f4:
    attack_pos_content=f4.readlines()
# with open(attacked_sen_path) as f5:
#     attacked_sen_content=f5.readlines()
flag=0
match=0
dismatch=0
no_attack=0
error=0
for i in range(len(src_content)):
    flag=0
    print('src:'+src_content[i])
    # print('attack:'+attacked_sen_content[i])
    print('model:'+model_result_content[i])
    print('golden:'+golden_path_content[i])
    print('src_pos:'+attack_pos_content[i])

    pos_list=attack_pos_content[i][1:-2]
    print("pos_list:"+str(pos_list))
    if pos_list=='-1':
        no_attack+=1
        continue

    src = annotator.parse(src_content[i])
    golden = annotator.parse(golden_path_content[i])
    model_result=annotator.parse(model_result_content[i])
    up_pos=annotator.parse(attack_pos_content[i])
    a=annotator.align(src,golden)
    seq=str(a.align_seq)
    l=[]
    for i in range(len(seq)):
        if seq[i] == '(':
            l.append(seq[i+2])
    print("src_golden:"+str(l))
    b=annotator.align(golden,model_result)
    seq2=str(b.align_seq)
    l2=[]
    for i in range(len(seq2)):
        if seq2[i] == '(':
            l2.append(seq2[i+2]) 
    

    pos_now=int(pos_list)
    x1=0
    x2=0
    for i in range(len(l)):
        if x1==pos_now:
            if pos_now==0 :
                if l[0]=='M' or l[0]=='S':
                    x2=0
                    break   
                elif (str(l[i+1]) is not None) and (l[i+1] !='I') and (l[i+1]!='D'):
                    break
            else:
                break

        if l[i]=='M' or l[i]=='S':
            x1+=1
            x2+=1
        elif l[i]=='I':
            x2+=1
        elif l[i]=='D':
            x1+=1
    
    

    x3=0
    x4=0
    for i in range(len(l2)):
        if x3==int(x2):
            if l2[i]=='D':
                flag=1
                break
            if int(x2)==0 :
                if l2[0]=='M' or l2[0]=='S':
                    x4=0
                    break  
                elif l2[i+1] is not None:
                    if (l2[i+1] !='I') and (l2[i+1]!='D'):
                        break   
            else:
                break

        if l2[i]=='M' or l2[i]=='S':
            x3+=1
            x4+=1
        elif l2[i]=='I':
            x4+=1
        elif l2[i]=='D':
            x3+=1
    print('golden_ba_pos:'+str(x4))
    if l2[x3]!='M' or flag==1:
        flag=1
        dismatch+=1
        print('-----do not match-----')
    else:
        match+=1
        print('-----match-----')
        
print('Match sum:'+str(match))
print('Disatch sum:'+str(dismatch))
print('No attack sum:'+str(no_attack))
print('result:'+str(match/(match+dismatch)))
