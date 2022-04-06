import sys

def select(path,attack_pos,num):
    n=int(num)
    h_num=0
    h_value=[]
    h_text=[]

    p_num=0
    p_value=[]

    a_num=0
    a_value=[]

    pos_content=[]
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
            h_length=len(h_text[0])
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
            if len_s<=n:
                pos_content.append("[-1]")
                h_num=0
                p_num=0
                a_num=0
                h_value.clear()
                h_text.clear()                      
                p_value.clear()                                 
                a_value.clear()
                continue
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

            min_pos = ['0' for i in range(n)]
            attack_list_tag=['-1' for i in range(n)]
            for i in range(n):
                min_pos[i]=min(p_value[max_pos][:h_length-1])
                index = p_value[max_pos].index(min_pos[i])
                attack_list_tag[i]=index
                p_value[max_pos][index]=0

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

            attack_list_src_pos=[]
            flag=0
            for i in attack_list_tag:
                for j in range(len(arr_tag)):
                    if i==arr_tag[j]:
                        if arr_src[j]>=len_s:
                            flag=1
                            break
                        attack_list_src_pos.append(arr_src[j])
                        
                        break
            if flag==0:
                pos_content.append(str(attack_list_src_pos))
            else:
                pos_content.append("[-1]")
            
            h_num=0
            p_num=0
            a_num=0
            h_value.clear()
            h_text.clear()                      
            p_value.clear()                                 
            a_value.clear()
    with open(attack_pos,'w') as a1:
        for line in pos_content:
            a1.write(line)
            a1.write('\n')
        
        
if __name__=='__main__':
    data_file=sys.argv[1]
    attack_pos=sys.argv[2]
    num=sys.argv[3]
    select(data_file, attack_pos, num)
