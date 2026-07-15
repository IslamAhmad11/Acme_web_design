#!/usr/bin/env python3

import os
import sys
import time
import requests

url = os.getenv("APP_URL")

if not url:
    print("APP_URL not found")
    sys.exit(1)

for _ in range(12):
    try:
        r = requests.get(url, timeout=10)
        if r.status_code == 200:
            print("Health check passed.")
            sys.exit(0)
    except Exception:
        pass

    time.sleep(10)

print("Health check failed.")
sys.exit(1)
