#!/usr/bin/env python3

import argparse
import argcomplete
import sys
import urllib.parse

def main():
    # Read argument or from stdin, encode entire string, including slashes in path and protocol.
    parser = argparse.ArgumentParser(description='Command line utility to decompose and query URL components.')
    parser.add_argument('url', nargs='?', type=str, help='URL to decompose and query.')
    parser.add_argument('query', type=str, help='URL to decompose and query.')
    
    argcomplete.autocomplete(parser)

    url = parser.parse_args().url or input()
    query = parser.parse_args().query

    # Parse URL
    parsed_url = urllib.parse.urlparse(url)

    # For now, only support extracting values from the query string.
    query_string = urllib.parse.parse_qs(parsed_url.query)
    if query in query_string:
        print('\n'.join(query_string[query]))
    else:
        print('')

if __name__ == "__main__":
    main()