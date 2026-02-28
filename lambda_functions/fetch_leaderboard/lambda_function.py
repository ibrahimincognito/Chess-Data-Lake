import json
import os
import boto3
import requests
from datetime import datetime

s3 = boto3.client('s3')
RAW_BUCKET = os.environ['RAW_BUCKET']
MODES = ['blitz', 'rapid', 'bullet']
TOP_N = 100   # API returns 100, not 200

def lambda_handler(event, context):
    date_str = datetime.utcnow().strftime('%Y-%m-%d')
    for mode in MODES:
        url = f'https://lichess.org/api/player/top/{TOP_N}/{mode}'
        try:
            resp = requests.get(url)
            resp.raise_for_status()
            data = resp.json()
            key = f'raw/leaderboard/{date_str}/{mode}.json'
            s3.put_object(
                Bucket=RAW_BUCKET,
                Key=key,
                Body=json.dumps(data),
                ContentType='application/json'
            )
            print(f"Uploaded {mode} to {key}")
        except Exception as e:
            print(f"Failed to fetch {mode}: {str(e)}")
    return {"status": "success", "date": date_str}