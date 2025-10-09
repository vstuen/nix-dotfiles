#!/usr/bin/env python3

import sys
import urllib.parse


def main():
    # Read argument or from stdin, encode entire string, including slashes in path and protocol.
    if len(sys.argv) > 1:
        print(urllib.parse.quote(sys.argv[1], safe=''))
    else:
        for line in sys.stdin:
            print(urllib.parse.quote(line.rstrip('\n'), safe=''))


if __name__ == "__main__":
    main()