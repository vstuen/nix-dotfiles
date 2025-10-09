#!/usr/bin/env python3
import os
import argparse
import argcomplete
import re
from datetime import datetime, date, timedelta

import requests


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description='Command line utility to manage time tracking for Widerøe Employees.')

    subparsers = parser.add_subparsers(dest='command', help='sub-command help')

    # Configure command
    subparsers.add_parser('configure', help='Configure the utility')

    # Register command
    register_parser = subparsers.add_parser('reg', aliases=['r'], help='Register time')
    register_parser.add_argument('timeFrom', type=str,
                                 help='Starting time to register, accepted formats: `HH`, `HHMM`, `HH:MM` or `now`')
    register_parser.add_argument('timeTo', type=str,
                                 help='Ending time to register, accepted formats: `HH`, `HHMM`, `HH:MM` or `now`')
    register_parser.add_argument('-d', '--date', type=str,
                                 help='Date to register the time, accepted format: `YYYY-MM-DD`, `now`, or a relative number - e.g. -1 for yesterday',
                                 default='now')
    register_parser.add_argument('-l', '--lunch', action='store_true',
                                 help='Flag to indicate that the registration should include lunch. '
                                      'Default behaviour is to include lunch if the registration is '
                                      'longer than 4 hours.')
    register_parser.add_argument('-L', '--no-lunch', action='store_true',
                                 help='Flag to indicate that the registration should not include lunch. '
                                      'Default behaviour is to include lunch if the registration is '
                                      'longer than 4 hours.')

    # Stamp in command
    stamp_in_parser = subparsers.add_parser('stamp_in', aliases=['si'], help='Stamp in')
    stamp_in_parser.add_argument('duration', type=str,
                                 help='The expected duration of the work day in the format 7h45m or just 7h', nargs='?',
                                 default='8h')
    # Stamp out command
    stamp_out_parser = subparsers.add_parser('stamp_out', aliases=['so'], help='Stamp out')
    stamp_out_parser.add_argument('duration', type=str,
                                  help='The actual duration of the work day in the format 7h45m or just 7h')
    stamp_out_parser.add_argument('-f', '--force', action='store_true',
                                  help='If there is an existing registration and the `duration` argument is given, '
                                       'override the starting time of the registration with the value derived from '
                                       'the argument instead of throwing an error')

    argcomplete.autocomplete(parser)
    return parser.parse_args()


def read_config(): 
    config_path = os.path.join(os.path.expanduser('~'), '.config', 'wftime', 'config.properties')
    with open(config_path, 'r') as file:
        content = file.read()
    config = {}
    for line in content.split('\n'):
        if line:
            key, value = line.split('=')
            config[key] = value
    return config

def auth():
    url = 'https://wideroe.no.gipsonline.com/api/v1/auth/'

    config = read_config()
    payload = f'login={config["username"]}&password={config["password"]}'
    headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
    }

    response = requests.request('POST', url, headers=headers, data=payload).json()
    if 'errors' in response and not response['errors']:
        return response['data'][0]['jwt']
    else:
        print(response)
        raise Exception('Error authenticating')


def register_hours(lunch: bool, time_from: datetime, time_to: datetime):
    print(f"From: {time_from}. To: {time_to}.")
    print(f"Duration: {time_to - time_from}")
    print(f"Lunch: {'yes' if lunch else 'no'}")

    bearer_token = auth()
    url = 'https://wideroe.no.gipsonline.com/api/v1/salary/hours/'
    # TODO Check for overlapping time

    # TODO : get employeeId from config
    payload = {'employeeId': '3874',
               'salaryTypeId': '116',
               'date': (time_from.strftime('%Y-%m-%d')),
               'timeFrom': (time_from.strftime('%H:%M')),
               'timeTo': (time_to.strftime('%H:%M')),
               'lunch': '1' if lunch else '0',
               'updateHourList': '1'}
    headers = {
        'Accept': 'application/json',
        'Authorization': f"Bearer {bearer_token}"
    }

    response = requests.request('POST', url, headers=headers, data=payload).json()
    if 'errors' in response and not response['errors']:
        print('OK')
    else:
        print(response)
        raise Exception('Error registering hours')


def parse_date_arg(date_str: str) -> date:
    # If date is integer, it is a relative date
    if date_str.lstrip('-').isdigit():
        return datetime.now().date() + timedelta(days=int(date_str))

    if date_str == 'now':
        return datetime.now().date()
    return datetime.strptime(date_str, '%Y-%m-%d').date()


def parse_time_arg(actual_date: date, time_str: str):
    now = datetime.now()
    if time_str == 'now':
        return now
    if ':' in time_str:
        time_format = '%H:%M'
    elif len(time_str) == 2:
        time_format = '%H'
    elif len(time_str) == 4:
        time_format = '%H%M'
    else:
        raise ValueError('Invalid time format')
    return datetime.combine(actual_date, datetime.strptime(time_str, time_format).time())


def check_lunch(args: argparse.Namespace, time_from: datetime, time_to: datetime):
    lunch = hasattr(args, 'lunch') and args.lunch
    no_lunch = hasattr(args, 'no_lunch') and args.no_lunch
    if lunch and no_lunch:
        raise ValueError('Both lunch and no-lunch flags are set, please choose one')
    return not no_lunch and (lunch or (time_to - time_from).seconds > 4 * 60 * 60)


def parse_duration(duration: str) -> timedelta:
    rgx = re.compile(r'(?P<hours>\d+)([h:](?P<minutes>\d+)m?)?')
    match = rgx.match(duration)
    if not match:
        raise ValueError('Invalid duration format, use e.g. 7h45m, 7h or 7:45')

    hours = int(match.group('hours'))
    minutes = int(match.group('minutes')) if match.group('minutes') else 0
    return timedelta(hours=hours, minutes=minutes)


def handle_reg_command(args: argparse.Namespace):
    print('Registering time')
    actual_date = parse_date_arg(args.date)
    time_from = parse_time_arg(actual_date, args.timeFrom)
    time_to = parse_time_arg(actual_date, args.timeTo)
    lunch = check_lunch(args, time_from, time_to)
    register_hours(lunch, time_from, time_to)


def handle_stamp_in_command(args: argparse.Namespace):
    # TODO : simple stamp in, register amount of hours from now based on the args given.
    #        Perhaps utilize comments on the registration for helping out coordination
    #        with the stamp out function
    pass


def handle_stamp_out_command(args: argparse.Namespace):
    # TODO : stamp out:
    #          - 1: if there are no registered hours for the day, register the hours based on the args given
    #          - 2: if there are registered hours for the day and no duration is given, stamp out
    #          - 3: if there are registered hours for the day and a duration is given and the force flag is not set,
    #            throw an error
    #          - 4: if there are registered hours for the day, a duration is given and the force flag is set,
    #            override the registration if the resulting interval overlaps with the existing registration

    # For now, assume scenario 1
    duration = parse_duration(args.duration)

    time_to = datetime.now()
    time_from = time_to - duration
    lunch = check_lunch(args, time_from, time_to)
    register_hours(lunch, time_from, time_to)


def handle_configure(args: argparse.Namespace):
    # TODO : configuration wizard
    pass


def main():
    args = parse_args()
    if args.command == 'reg' or args.command == 'r':
        handle_reg_command(args)
    if args.command == 'stamp_in' or args.command == 'si':
        handle_stamp_in_command(args)
    if args.command == 'stamp_out' or args.command == 'so':
        handle_stamp_out_command(args)
    if args.command == 'configure':
        handle_configure(args)


if __name__ == '__main__':
    main()
