
list = open('words.txt').read().split()
str = "["
for x in list :
	str+= ('"'+x+'", ')
print(str)