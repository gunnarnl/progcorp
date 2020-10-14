import csv
import os
import re
import sys

def progRows(lines):
    filenames = [getFileName(l.rstrip()) for l in lines[::3]]
    vbgs = [me2Lemma(l.rstrip()) for l in lines[1::3]]
    bes = [l.rstrip() for l in lines[2::3]]
    if len(filenames) != len(vbgs) != len(bes):
        raise Exception("Rows are different lengths.")
    else:
        return zip(vbgs, bes, filenames)

def getFileName(line):
    pattern = r'/([a-z0-9-.]*)\.psd'
    # regex = re.compile(pattern)
    return re.search(pattern, line).group(1)

def me2Lemma(line):
    pattern = r"@l=([a-zA-Z0-9'-+]+)@"
    match = re.search(pattern, line)
    if match != None:
        return match.group(1)
    else:
        return line

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
