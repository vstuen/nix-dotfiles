#!/usr/bin/env python3
import argparse
import bcrypt
import json

def main():
    parser = argparse.ArgumentParser(description='Command line utility to generate and validate bcrypt hashes')

    sub_parsers = parser.add_subparsers(dest='command', help='sub-command help')

    check_parser = sub_parsers.add_parser('check', help='Check if a password matches a hash')
    check_parser.add_argument('password', nargs='?', help='The password to either hash or validate')
    check_parser.add_argument('hash', help='The hash to validate the given password from')

    hash_parser = sub_parsers.add_parser('hash', help='Generate a bcrypt hash')
    hash_parser.add_argument('password', nargs='?', help='The password to hash')
    hash_parser.add_argument('--rounds', type=int, help='The number of rounds to use for hashing')
    hash_parser.add_argument('--salt', help='The salt to use for hashing')

    destructure_parser = sub_parsers.add_parser('destructure', help='Destructure a bcrypt hash')
    destructure_parser.add_argument('hash', nargs='?', help='The hash to destructure')

    args = parser.parse_args()

    if args.command == 'check':
        password = args.password or input()
        if bcrypt.checkpw(password.encode(), args.hash.encode()):
            print("Password matches the hash")
        else:
            print("Password does not match the hash")
    elif args.command == 'hash':
        password = args.password or input()
        rounds = args.rounds or 10
        # Replace 2b with 2a to match the MW bcrypt implementation. These two versions are compatible
        salt = (args.salt or bcrypt.gensalt(rounds=rounds).decode()).replace('2b', '2a')
        hash = bcrypt.hashpw(password.encode(), salt.encode())
        print(hash.decode())
    elif args.command == 'destructure':
        hash = args.hash or input()
        hash_parts = hash.split('$')
        destructured = { 
            'version': hash_parts[1],
            'rounds': int(hash_parts[2]),
            'salt': hash_parts[3][0:22],
            'hash': hash_parts[3][22:],
            'full_salt': '$' + '$'.join([ *hash_parts[1:3], hash_parts[3][0:22] ])
        }

        print(json.dumps(destructured))
    else:
        parser.print_help()

if __name__ == '__main__':
    main()
