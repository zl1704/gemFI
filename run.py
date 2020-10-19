import os


res = os.popen("build/ARM/gem5.opt  configs/example/se.py -c  configs/fi/qs-arm").read()

#print(res)
