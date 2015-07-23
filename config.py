import sys
import requests
import json

headers = { 'Fastly-Key': 'KEY',
            'Accept': 'application/json',
            'Content-Type': 'application/x-www-form-urlencoded'}


fastly_api = "https://api.fastly.com/"
