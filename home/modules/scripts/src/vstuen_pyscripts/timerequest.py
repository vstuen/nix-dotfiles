#!/usr/bin/env python3

import sys
import requests
import time


def main():
    # Read URLs from command line or stdin
    urls = []
    if len(sys.argv) > 1:
        urls.append(sys.argv[1])
    else:
        for line in sys.stdin:
            urls.append(line)

    # Function to sanitize a URL, and add protocol if needed
    def sanitize_url(url):
        if not url.startswith("http://") and not url.startswith("https://"):
            url = "https://" + url
        return url

    # Function to get the execution time of request to a URL
    def get_request_time(url):
        start = time.time()
        requests.get(sanitize_url(url))
        total_time = time.time() - start
        return int(total_time * 1000)


    for url in urls:
        print(url + ": " + str(get_request_time(url)) + " ms")

if __name__ == "__main__":
    main()