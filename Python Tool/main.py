#!/usr/bin/python

from bs4 import BeautifulSoup
import re
import sys

# System arguments:
# sys.argv[1] = path for html and js file // e.g. nodered/node-red-nodes/analysis/mlsentiment/mlsentiment
# sys.argv[2] = path for csv file // e.g. nodered/results/results.csv
# sys.argv[3] = keyword for file result searching // e.g. mlsentiment/mlsentiment.js

def nodeclassify(source, sink):
    global node
    if source == '0' and sink != '0':
        node = 'START NODE'
    if source != '0' and sink != '0':
        node = 'MIDDLE NODE'
    if source != '0' and sink == '0':
        node = 'END NODE'
    print(node)


def sourceextraction(xindex, xkeyword, xstring_csv):
    source_start = 'relative:///' + xkeyword + ':'
    source_end = ':'
    res_source = re.search(source_start + '(.*)' + source_end, xstring_csv)

    inp_index = res_source.group(1)
    inp_index = inp_index.rpartition(':')[0]
    inp_index = inp_index.rpartition(':')[0]
    print("Source", xindex, "at line:", inp_index)
    source_list.append(inp_index)


def sinkextraction(xindex, xkeyword, xstring_csv):
    sink_start = '"/' + xkeyword + '","'
    sink_end = '"'
    res_sink = re.search(sink_start + '(.*)' + sink_end, xstring_csv)
    outp_index = res_sink.group(1)
    outp_index = outp_index.rpartition('","')[0]
    outp_index = outp_index.rpartition('","')[0]
    outp_index = outp_index.rpartition('","')[0]

    print("Sink", xindex, "at line:", outp_index)
    sink_list.append(outp_index)


def getDuplicatesWithInfo(listOfElems):
    ''' Get duplicate element in a list along with thier indices in list
     and frequency count'''
    dictOfElems = dict()
    index = 0
    # Iterate over each element in list and keep track of index
    for elem in listOfElems:
        # If element exists in dict then keep its index in list & increment its frequency
        if elem in dictOfElems:
            dictOfElems[elem][0] += 1
            dictOfElems[elem][1].append(index)
        else:
            # Add a new entry in dictionary
            dictOfElems[elem] = [1, [index]]
        index += 1

    dictOfElems = {key: value for key, value in dictOfElems.items() if value[0] > 1}
    return dictOfElems


file = sys.argv[1]
htmlfile = file + '.html'
with open(htmlfile, 'r') as f:
    contents = f.read()
    soup = BeautifulSoup(contents, 'html.parser')
    s_str = str(soup)

    res_in = re.search('inputs:(.*),', s_str)
    inp = res_in.group(1)

    res_out = re.search('outputs:(.*),', s_str)
    outp = res_out.group(1)
    nodeclassify(inp, outp)


    frequency = {}
    # Open the sample text file in read mode.
    csvfile = sys.argv[2]
    document_text = open(csvfile, 'r')
    # convert the string of the document in lowercase and assign it to text_string variable.
    text = document_text.read().lower()
    keyword = sys.argv[3]
    pattern = re.findall(keyword, text)
    for word in pattern:
        count = frequency.get(word, 0)
        frequency[word] = count + 1
    frequency_list = frequency.keys()
    for words in frequency_list:
        flow_nr = int(frequency[words] / 2)
        print("Number of total flows:", flow_nr)

    index = 1
    source_list = []
    sink_list = []
    sinkfile_list = []
    source_repeat_list = []
    index_list = []

    for item in text.split("\n"):
        if keyword in item:
            # print(item.strip())
            string_csv = str(item.strip())

            # Source extraction
            sourceextraction(index, keyword, string_csv)

            # Sink extraction
            sinkextraction(index, keyword, string_csv)
            index = index + 1

    dictOfSourceElems = getDuplicatesWithInfo(source_list)
    for key, source_value in dictOfSourceElems.items():
        source_repeat_list.append(source_value[1])
        index_list.append(key)

    i = 0
    j = 0
    k = 0
    js_filepath = file + '.js'
    file_js = open(js_filepath)
    content = file_js.readlines()

    while i < len(source_repeat_list):
        while j < len(source_value[1]):
            sink_list_line = sink_list[j]
            sink_string = content[int(sink_list_line) - 1]
            sinkfile_list.append(sink_string)
            j = j + 1

        while k < len(sinkfile_list) - 1:
            if sinkfile_list[k].strip() in sinkfile_list[k + 1].strip():
                print("Repeated sources and sinks in flows")
                flow_nr = flow_nr - 1
            k = k + 1

        i = i + 1

    print("Estimated flow numbers with unique sources and sinks", flow_nr)
