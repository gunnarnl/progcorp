import csv
import os
import re
import sys

def progRows(lines):
    filenames = [getFileName(l.rstrip()) for l in lines[::4]]
    vbgs = [l.rstrip() for l in lines[1::4]]
    bep = [l.rstrip() for l in lines[2::4]]
    bef = [l.rstrip() for l in lines[3::4]]
    if len(filenames) != len(vbgs) != len(bep) != len(bef):
        raise Exception("Rows are different lengths.")
    else:
        return zip(vbgs, bep, bef, filenames)

def getFileName(line):
    pattern = r'/([A-Za-z0-9-_.]*)\.stp'
    # regex = re.compile(pattern)
    return re.search(pattern, line).group(1)

def main():
    cwd = os.getcwd()
    for file in sys.argv[1:]:
        with open(file, 'r') as f:
            rows = progRows(f.readlines())
        with open(os.path.basename(os.path.splitext(file)[0])+'.csv', 'w') as c:
            writer = csv.writer(c)
            for row in rows:
                writer.writerow(row)

main()
