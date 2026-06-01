#!/usr/bin/env python3
import requests
import sys
import os

APP_URL = os.getenv("APP_URL", "http://localhost")

try:
    resp = requests.get(APP_URL, timeout=10)
    if resp.status_code == 200:
        print("Health check passed!")
        sys.exit(0)
    else:
        print(f"Health check failed with status {resp.status_code}")
        sys.exit(1)
except Exception as e:
    print(f"Error during health check: {e}")
    sys.exit(1)
