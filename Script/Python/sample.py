import boto3

session = boto3.Session(
    profile_name='NotDefault',
    region_name='ap-southeast-2'
)

print(session.available_profiles)

client = session.client(
    'ec2'
)