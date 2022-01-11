import csv
import os

path = 'nodered/FinalDesc'
node_names = [os.path.splitext(filename)[0] for filename in os.listdir(path)]
print(node_names)

with open('nodered/desc.txt', 'w') as f:
    for item in node_names:
        f.write("%s\n" % item.lower())
