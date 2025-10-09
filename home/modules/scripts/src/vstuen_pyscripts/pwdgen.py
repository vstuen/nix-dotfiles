#!/usr/bin/env python3
import argparse
import random
import string

def main():
    defaultLength = 10

    # Parse command line arguments
    parser = argparse.ArgumentParser(description='Generate a random password')

    # Add arguments, if a single argument is added, it is the length of the password to generate
    parser.add_argument('length', nargs='?', default=defaultLength, type=int, help=f'length of password (default: {defaultLength})')
    parser.add_argument('-S', '--no-symbols', action='store_true', help='exclude symbols')
    parser.add_argument('-N', '--no-numbers', action='store_true', help='exclude numbers')
    parser.add_argument('-A', '--no-letters', action='store_true', help='exclude letters')

    # Parse arguments
    args = parser.parse_args()

    # Error if all character types are excluded
    if args.no_symbols and args.no_numbers and args.no_letters:
        parser.error('All character types are excluded')

    # Create character set to use
    charset = ''
    if not args.no_symbols:
        charset += string.punctuation
    if not args.no_numbers:
        charset += string.digits
    if not args.no_letters:
        charset += string.ascii_letters

    # Generate password
    password = ''.join(random.choice(charset) for _ in range(args.length))
    print(password, end='')

if __name__ == '__main__':
    main()
