#!/usr/bin/env python3

import sys
import urllib.parse


def main():
    # Read argument or from stdin, use urllib.parse.unquote to decode
    # URL-encoded strings.
    if len(sys.argv) > 1:
        print(urllib.parse.unquote(sys.argv[1]))
    else:
        for line in sys.stdin:
            print(urllib.parse.unquote(line.rstrip('\n')))

if __name__ == "__main__":
    main()