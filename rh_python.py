#!/usr/bin/env python3

import argparse
import sys
import random
import os.path

def load(input_file):
    """
    Load string for processing from file or stdin

    :param input_file: path to file or None
    :type input_file: str|None
    :raise: FileExistsError if input file does not exist
    :return: loaded text
    :rtype: str
    """
    if input_file:
        # check existence of input file
        if not os.path.isfile(input_file):
            raise FileExistsError('Input file does not exists.')
        f = open(input_file)
    else:
        f = sys.stdin
    text = f.read()
    if input_file:
        f.close()
    return text

def shuffle(text):
    """
    Process given text to paragraphs, shuffle them and join them again

    :param text: text to process
    :type text: str
    :return: shuffled text
    :rtype: str
    """
    if text:
        # if there is not new line at the end of file, add now and remove at the end
        new_line = True
        if text[-1] != '\n':
            new_line = False
            text += '\n'

        list_to_shuffle = []
        lines = text.split('\n')
        paragraph = ''
        # process by line so more empty lines consecutively will have "empty" paragraphs
        while lines:
            line = lines.pop(0)
            if line:
                paragraph += line + '\n'
            else:
                list_to_shuffle.append(paragraph)
                paragraph = ''
        if line:
            list_to_shuffle.append(paragraph)

        random.shuffle(list_to_shuffle)
        text = '\n'.join(list_to_shuffle)
        # If there where no new line on end of file, remove from end
        if not new_line:
            text = text[:-1]
    return text

def store(output_file, text):
    """
    Store string after processing to file or stdout

    :param input_file: path to file or None
    :type input_file: str|None
    :param text: text to store
    :type text: str
    """
    f = open(output_file, 'w') if output_file else sys.stdout
    f.write(text)
    if output_file:
        f.close()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Shuffle paragraphs')
    parser.add_argument('-i', '--input-file', action='store', help='input file (stdin if omitted)')
    parser.add_argument('-o', '--output-file', action='store', help='output file (stdout if omitted)')
    args = parser.parse_args()

    text = load(args.input_file)
    text = shuffle(text)
    store(args.output_file, text)
