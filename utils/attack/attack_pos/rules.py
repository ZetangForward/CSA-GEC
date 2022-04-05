# -*- coding: utf-8 -*-
# singular <-> plural
# adv <-> adj
# punc -> ''
# VBZ <-> VB
# Numerals -> unchanged
# others <-> <unk>

import nltk
from nltk import word_tokenize
from nltk.tag import pos_tag,map_tag
import inflect
from nltk.corpus import wordnet as wn
import nlpaug.augmenter.word as naw

def noun(word):
    try:
        p=inflect.engine()
    except:
        return word
    return p.plural(word)
def adj(word):
    # 1. 辅音+e  变y为i，加ly
    fuyin=['by','cy','dy','fy','gy','hy','jy','ky','ly','my','ny','py','qy','ry','dy','ty','vy','wy','xy','zy']
    word_temp=[]
    for i in fuyin:
        if word.endswith(i):
            return word[:-1]+'ily'
    # 2. 以ue结尾  去掉e，加ly
    if word.endswith('ue'):
        return word[:-1]+'ly'
    # 3. 以le结尾  去掉e，加y
    if word.endswith('le'):
        return word[:-1]+'y'
    return word+'ly'
def adv(word):
    possible_adj=[]
    for ss in wn.synsets(word):
        for lemmas in ss.lemmas(): # all possible lemmas
            for ps in lemmas.pertainyms(): # all possible pertainyms
                possible_adj.append(ps.name())
    # print(type(possible_adj[0]))
    if len(possible_adj)==0:
        return word
    return possible_adj[0]

def verb(sen):
    
    aug = naw.SpellingAug()
    augmented_texts = aug.augment(sen, n=1)
    print('verb'+sen+augmented_texts)
    return augmented_texts

def judge(sen,pos):
    sentence=word_tokenize(sen) # 分词
    s=nltk.pos_tag(sentence)
    # print(s)
    s_simplified=[(word, map_tag('en-ptb', 'universal', tag)) for word, tag in s] 
    # print(s_simplified)
    result=''
    # 名词
    if s_simplified[pos][1]=='NOUN':
        result=noun(s[pos][0])

    # 形容词->副词
    if s_simplified[pos][1]=='ADJ':
        result=adj(s[pos][0])

    # 副词->形容词
    if s_simplified[pos][1]=='ADV':

        result=adv(s[pos][0])

    # 动词
    if s_simplified[pos][1]=='VERB':
        result=verb(s[pos][0])
    

    if result=='' or result==' ':
        return s[pos][0]
    else :
        return result

def word_rules(sen,pos):
    return judge(sen,pos)

# if __name__=='__main__':
#     str="He takes a beautifully apples,"
#     print(judge(str,1))
#     # adj('aby')