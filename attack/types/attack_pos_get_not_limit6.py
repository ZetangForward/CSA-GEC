import sys

def select(path,result_pos,result_sen):
    l=0
    h_num=0
    h_value=[]
    h_text=[]

    p_num=0
    p_value=[]

    a_num=0
    a_value=[]

    with open(path) as f:
        content=f.readlines()
    for line in content:
        if line.startswith('S-'):
            sen=line.split('\t')
            sen=sen[1].strip()
            sen_s=sen.split(' ')
            len_s=len(sen_s)
            continue
        if line.startswith('H-'):           
            h_num+=1
            h=line.split('\t')
            h_value.append(float(h[1]))
            h_text.append(h[2][:-1])
        if line.startswith('P-'):                   
            p_num+=1
            line_p=line.split('\t')
            p=line_p[1]
            p=p.split(' ')
            p_b=[]
            for i in p:
                p_b.append(float(i))                 
            p_value.append(p_b)
        if line.startswith('A-'):

            a_num+=1
            if line.endswith('\n'):
                a=line[:-1]
            else:
                a=line[:]

            a=a.split('\t')
            a=a[1]
            a_value.append(a)

        if a_num>=5:
            h_max=-1
            tag=0
            max_pos=0
            for value in h_value:
                if value>h_max:
                    h_max=value
                    h_max=tag
                tag+=1
            p_max=p_value[max_pos][:]
            h_text_word=str(h_text[max_pos]).split(' ')
            h_length=len(h_text_word)

            sum=0
            count=0
            mean=0
            for i in range(h_length):
                sum=sum+p_value[max_pos][i]
                count+=1
            mean=sum/count

            attack_list_tag=[]
            attack_acount=0
            for i in range(h_length):
                if p_value[max_pos][i]<mean:
                    attack_list_tag.append(1)
                    attack_acount+=1
                if p_value[max_pos][i]>=mean:
                    attack_list_tag.append(0)

            temp_src=0
            temp_trg=0
            arr_src=[]
            arr_tag=[]
            flag=0

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
            att_pos=0
            for i in range(len_s):
                attack_list_src.append(0)
            for j in attack_list_src_pos:
                attack_list_src[j]=1
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
    attack_file=sys.argv[1] 
    result_pos=sys.argv[2] 
    result_sen=sys.argv[3] 
    select(attack_file,result_pos,result_sen)