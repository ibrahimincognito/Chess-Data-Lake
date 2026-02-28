import json
import os
import boto3
import awswrangler as wr
import pandas as pd

s3 = boto3.client('s3')
PROCESSED_BUCKET = os.environ['PROCESSED_BUCKET']

def lambda_handler(event, context):
    print("Received event:", json.dumps(event))
    # Get the S3 object details from the trigger event
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    
    # Only process leaderboard JSON files
    if not key.startswith('raw/leaderboard/') or not key.endswith('.json'):
        return {"status": "skipped", "reason": "not a leaderboard file"}
    
    # Parse date and mode from key (raw/leaderboard/2026-02-17/blitz.json)
    parts = key.split('/')
    date_str = parts[2]          # e.g., 2026-02-17
    mode = parts[3].replace('.json', '')   # e.g., blitz
    
    # Download JSON from S3
    resp = s3.get_object(Bucket=bucket, Key=key)
    content = json.loads(resp['Body'].read().decode('utf-8'))
    users = content.get('users', [])
    
    # Transform
    records = []
    for rank, user in enumerate(users, start=1):
        perf = user.get('perfs', {}).get(mode, {})
        records.append({
            'username': user['username'],
            'ranking': rank,
            'rating': perf.get('rating'),
            'performance': mode,
            'snapshot_date': date_str
        })
    
    if not records:
        return {"status": "empty"}
    
    df = pd.DataFrame(records)
    
    # Write to processed bucket using awswrangler (partitioned by performance and snapshot_date)
    out_path = f"s3://{PROCESSED_BUCKET}/leaderboard/"
    wr.s3.to_parquet(
        df=df,
        path=out_path,
        dataset=True,
        mode='append',
        partition_cols=['performance', 'snapshot_date']
    )
    
    return {"status": "success", "rows": len(df)}