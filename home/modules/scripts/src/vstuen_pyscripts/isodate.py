#!/usr/bin/env python3

def main():
    import argparse
    import datetime

    parser = argparse.ArgumentParser(description='Print ISO8601 dates, times, and datetimes')

    date_or_time_group = parser.add_mutually_exclusive_group()
    date_or_time_group.add_argument('--date', action='store_true', help='Print only the date')
    date_or_time_group.add_argument('--time', action='store_true', help='Print only the time')

    zone_group = parser.add_mutually_exclusive_group()
    zone_group.add_argument('--local', action='store_true', help='Discard zone information')
    zone_group.add_argument('--zone', help='Set the zone (as an offset from UTC in hours)')

    args = parser.parse_args()

    # Working datetime object
    dt = datetime.datetime.now().astimezone()


    if args.local:
        dt = dt.replace(tzinfo=None)
    elif args.zone:
        dt = dt.astimezone(datetime.timezone(datetime.timedelta(hours=int(args.zone))))

    if args.date:
        print(dt.date().isoformat())
    elif args.time:
        print(dt.time().isoformat(timespec='milliseconds'))
    else:
        print(dt.isoformat(timespec='milliseconds'))

if __name__ == '__main__':
    main()