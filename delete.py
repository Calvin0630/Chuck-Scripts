import random
data = [x for x in range(20)]
for x in range(len(data)):
    data[x] = random.randint(-100,100)

print(data)