cadena= 'bbacbabc'

def create_dictionary(characters):
    dictionary = []
    for i in characters:
        if(i in dictionary):
            continue
        else: 
            dictionary.append(i)
    return dictionary



def index_character(chain_characters, character):
    size = len(chain_characters)
    i = 0
    while i < size:
        if character == chain_characters[i]:
            return i
        i+=1
    return -1


def compression():
    dictionary = create_dictionary('abc')
    print(dictionary)
    w = ''
    salida = []
    j = 0
    for i in cadena:
        k = i
        wk = w+k
        if (index_character(dictionary,wk) > -1): # indica que wk no esta en diccionario
            w = wk
        else:
            dictionary.append(wk)
            flag = index_character(dictionary,w)
            if flag == -1:
                pass
            else:
                salida.append(flag)    
            w = k
    if w:
        salida.append(index_character(dictionary,w))
    return salida,dictionary
print(compression())




