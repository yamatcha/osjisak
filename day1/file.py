str =input()
newstr=[]
while len(str)!=0:
    newstr.append(str[:16])
    str=str[16:]
    # print(len(str))
def createLine(l):
    s=[]
    while len(l)!=0:
        s.append(l[:2])
        l=l[2:]
    line="DB 0x"
    line+= ", 0x".join(s)
    return line

for i in newstr:
    print(createLine(i))