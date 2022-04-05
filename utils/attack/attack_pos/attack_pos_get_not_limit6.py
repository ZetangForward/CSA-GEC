"""
2021.11.4
"""
# attack_file='/data1/tzc/fkq/gigaword-attack/generate.nbest.tok'
# result_pos='/data1/tzc/fkq/gigaword-attack/attack_pos_not--limit7.txt'
# result_sen='/data1/tzc/fkq/gigaword-attack/attack_sentence_not--limit7.txt'
attack_file='/home/tzc/GEC/fairseq_old/examples/translation/script/output/test/test.nbest.tok'
result_pos='/data1/tzc/fkq/data/pos/temp_pos'
result_sen='/data1/tzc/fkq/data/pos/temp_sen'
def select(path):
    l=0
    h_num=0 # 记录是该s的第几个h
    h_value=[] # 存放h的值
    h_text=[] # 存放h的文字部分

    p_num=0
    p_value=[] # 存放所有的概率

    a_num=0
    a_value=[] # 存放所有的对应对

    with open(path) as f:
        content=f.readlines()
    ll=0
    for line in content:
        ll+=1
        if (ll%10000==1):
            print(ll)
        if line.startswith('S-'):
            sen=line.split('\t')
            sen=sen[1].strip()
            sen_s=sen.split(' ')
            len_s=len(sen_s)
            continue
        if line.startswith('H-'):
            # print('H-')                    
            h_num+=1
            h=line.split('\t')
            h_value.append(float(h[1]))
            h_text.append(h[2][:-1])
            # print(h_value)
            # print(h_text)
        if line.startswith('P-'):                   
            p_num+=1
            line_p=line.split('\t')
            # if ll>=12000000:
            #     print(line_p)
            p=line_p[1]
            # print(p)
            p=p.split(' ')
            p_b=[]
            for i in p:
                p_b.append(float(i))                 
            p_value.append(p_b)
            # print(p_value)
        if line.startswith('A-'):

            a_num+=1
            if line.endswith('\n'):
                a=line[:-1]
            else:
                a=line[:]

            a=a.split('\t')
            a=a[1]
            a_value.append(a)
            # print(a_value)

        # 一组数据结束
        if a_num>=5:
            h_max=-1
            tag=0 # 最小的组的序号（0-4）
            max_pos=0
            for value in h_value:
                if value>h_max:
                    h_max=value
                    h_max=tag
                tag+=1
            p_max=p_value[max_pos][:]
            # print(p_max)

             # 目标端句子的长度,有效长度
            h_text_word=str(h_text[max_pos]).split(' ')
            h_length=len(h_text_word)
            # print(h_length)
  
            # 求有效长度内小概率的均值
            sum=0
            count=0
            mean=0
            for i in range(h_length):
                sum=sum+p_value[max_pos][i]
                count+=1
            mean=sum/count

            # 寻找H-0最小的组中 所有小于均值的概率 的位置
            attack_list_tag=[]
            attack_acount=0
            for i in range(h_length):
                if p_value[max_pos][i]<mean:
                    attack_list_tag.append(1)
                    attack_acount+=1
                if p_value[max_pos][i]>=mean:
                    attack_list_tag.append(0)
            # print(attack_list_tag)
            
               
            # 读取src-trg序列到两个数组
            temp_src=0
            temp_trg=0
            arr_src=[] # 存放一组对应关系中，src端数字
            arr_tag=[] # 存放一组对应关系中，tag端数字
            flag=0 # 偶数为在读取src端，奇数为在读取tag端

            for i in a_value[max_pos]:
                if i=='-'or i==' ':
                    flag+=1
                    continue
                if flag==0:
                    temp_src=temp_src*10+int(i)
                elif flag%2==0:
                    if temp_src==0:
                        arr_tag.append(temp_trg)
                    temp_trg=0
                    temp_src=temp_src*10+int(i)

                if flag%2==1:
                    if temp_trg==0:
                        arr_src.append(temp_src)
                    temp_src=0
                    temp_trg=temp_trg*10+int(i)
                if temp_trg>=h_length-1:
                    break      
            arr_tag.append(temp_trg)    
            # print(arr_src)
            # print(arr_tag)


            pos_t=0
            attack_list_src=[]
            attack_list_src_pos=[]
            for i in range(len(attack_list_tag)):
                if attack_list_tag[i]==1:
                    for j in range(len(arr_tag)):
                        if arr_tag[j]==i:
                            if arr_src[j]>=len_s:
                                continue
                            attack_list_src_pos.append(arr_src[j])
                            break
            # print(attack_list_src_pos)
            att_pos=0
            for i in range(len_s):
                attack_list_src.append(0)
            for j in attack_list_src_pos:
                # if j>len_s-1:
                #     continue
                attack_list_src[j]=1
            # print(attack_list_src)
            with open(result_pos,'a') as a1:
                a1.write(str(attack_list_src))
                a1.write('\n')
            with open(result_sen,'a') as a2:
                a2.write(str(sen))
                a2.write('\n')

            h_num=0
            p_num=0
            a_num=0
            h_value.clear()
            h_text.clear()                      
            p_value.clear()                                 
            a_value.clear()
        
        


if __name__=='__main__':
    select(attack_file)