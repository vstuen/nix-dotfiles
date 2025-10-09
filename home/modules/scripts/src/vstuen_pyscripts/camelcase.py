#!/usr/bin/env python3

import argparse

def main():
    # Parse the arguments
    parser = argparse.ArgumentParser(description='Convert a string to camelcase.')
    parser.add_argument('string', nargs='?', help='the string to convert')
    parser.add_argument('-u', '--upper', action='store_true', help='convert to upper camelcase')
    args = parser.parse_args()

    # Get the string from either stdin or the last argument
    string = args.string or input()

    # Convert the string to camelcase
    camelcase = ''.join(word.capitalize() for word in string.split())
    if not args.upper:
        camelcase = camelcase[0].lower() + camelcase[1:]

    # Print the camelcase string
    print(camelcase, end='')

if __name__ == "__main__":
    main()