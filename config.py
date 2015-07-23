import sys
import requests
import json

headers = { 'Fastly-Key': 'cbfd61cfacb6136b3d1670c196205edd',
            'Accept': 'application/json',
            'Content-Type': 'application/x-www-form-urlencoded'}


fastly_api = "https://api.fastly.com/"
