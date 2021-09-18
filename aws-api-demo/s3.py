#!/usr/bin/env python3

import boto3

client = boto3.client('s3')

# Let's use Amazon S3
s3 = boto3.resource('s3')
# Print out bucket names
for bucket in s3.buckets.all():
    print(bucket.name)
    response = client.get_bucket_location(Bucket=bucket.name)
    print(response['LocationConstraint'])
