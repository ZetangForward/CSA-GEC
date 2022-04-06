import nltk
from nltk import word_tokenize
from nltk.tag import map_tag
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

    fuyin=['by','cy','dy','fy','gy','hy','jy','ky','ly','my','ny','py','qy','ry','dy','ty','vy','wy','xy','zy']
    word_temp=[]
    for i in fuyin:
        if word.endswith(i):
            return word[:-1]+'ily'

    if word.endswith('ue'):
        return word[:-1]+'ly'

    if word.endswith('le'):
        return word[:-1]+'y'
    return word+'ly'
def adv(word):
    possible_adj=[]
    for ss in wn.synsets(word):
        for lemmas in ss.lemmas():
            for ps in lemmas.pertainyms():
                possible_adj.append(ps.name())

    if len(possible_adj)==0:
        return word
    return possible_adj[0]

def verb(sen):
    
    aug = naw.SpellingAug()
    augmented_texts = aug.augment(sen, n=1)
    return augmented_texts

def judge(sen,pos):
    sentence=word_tokenize(sen)
    s=nltk.pos_tag(sentence)
    s_simplified=[(word, map_tag('en-ptb', 'universal', tag)) for word, tag in s] 

    result=''

    if s_simplified[pos][1]=='NOUN':
        result=noun(s[pos][0])
    if s_simplified[pos][1]=='ADJ':
        result=adj(s[pos][0])
    if s_simplified[pos][1]=='ADV':
        result=adv(s[pos][0])
    if s_simplified[pos][1]=='VERB':
        result=verb(s[pos][0])
    

    if result=='' or result==' ':
        return s[pos][0]
    else :
        return result

def word_rules(sen,pos):
    return judge(sen,pos)
