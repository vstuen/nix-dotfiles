#!/usr/bin/env python3

import argparse

def main(): 
    # Function to capitalize a single word, except for common words
    def capitalize_word(word):
        common_words = ['a', 'an', 'the', 'and', 'but', 'or', 'for', 'nor', 'on', 'at', 'to', 'from', 'by', 'of', 'in', 'with']
        return word.capitalize() if word.lower() not in common_words else word

    def capitalize_all(string):
        capitalized_string = ' '.join(capitalize_word(word) for word in string.split())
        return capitalized_string[0].upper() + capitalized_string[1:]

    def capitalize(string, first_word_only):
        return string.capitalize() if first_word_only else capitalize_all(string)

    # Parse the arguments
    parser = argparse.ArgumentParser(description="Capitalize a string.")
    parser.add_argument("string", nargs="?", help="the string to capitalize")
    parser.add_argument("-f", "--first-word-only", action="store_true", help="capitalize only the first word")
    args = parser.parse_args()

    # Get the string from either stdin or the last argument
    string = (args.string or input()).lower().strip()
    capitalized_string = capitalize(string, args.first_word_only)

    print(capitalized_string, end='')

if __name__ == "__main__":
    main()
