import matplotlib.pyplot as plt

strValues = open("bytes.txt").read().split()
floatValues = [0]*len(strValues)
for x in range(len(strValues)) :
    floatValues[x] = float(strValues[x])
    print(str(floatValues[x])+', ')


plt.plot(floatValues)
plt.ylabel('some numbers')
plt.show()