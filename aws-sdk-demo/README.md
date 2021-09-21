# aws-sdk-demo credentials region and ec2 instance
Simple look at the aws sdk and how credentials, region and ec2 instances work.
- creds come from ~/.aws/credentials and if not found the ec2 metadata location is examined and roles for instance used
- region come from ~/.aws/config and if not found from ec2 metadata

## install boto3
[Quickstart](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/quickstart.html#installation)
```
venv
pip install typer boto3
```
  - ~/.aws/credentials - access and secret key
  - ~/.aws/config - region

## copy the example

```
$ cat s3.py
#!/usr/bin/env python3

import boto3

# Let's use Amazon S3
s3 = boto3.resource('s3')
# Print out bucket names
for bucket in s3.buckets.all():
    print(bucket.name)

$ ./s3.py
cloudtrail-us-west-2-433331399117
```

## run on ec2 instance

### Provision ec2 instance
In the cloud console
- Amazon Linux 2 AMI
- Review and launch

### Run on ec2
```
$ ssh ec2-user@34.219.66.229

[ec2-user@ip-172-31-18-54 ~]$ cat > s3.py <<EOF
#!/usr/bin/env python3

import boto3

# Let's use Amazon S3
s3 = boto3.resource('s3')
# Print out bucket names
for bucket in s3.buckets.all():
    print(bucket.name)

EOF
[ec2-user@ip-172-31-18-54 ~]$ pip3 install boto3
[ec2-user@ip-172-31-18-54 ~]$ python3 s3.py
Traceback (most recent call last):
  File "s3.py", line 8, in <module>
    for bucket in s3.buckets.all():
...
  File "/home/ec2-user/.local/lib/python3.7/site-packages/botocore/auth.py", line 373, in add_auth
    raise NoCredentialsError()
botocore.exceptions.NoCredentialsError: Unable to locate credentials
```
### Fix ec2 IAM problem
Back in the cloud console, select the ec2 instance
- Actions > Instance Settings > Attach/Replace IAM Role
- Branch out to create the role - aaa-s3allaccess with AWSs3fullaccess
- Attach to instance
```
[ec2-user@ip-172-31-18-54 ~]$ python3 s3.py
cloudtrail-us-west-2-433331399117
```
