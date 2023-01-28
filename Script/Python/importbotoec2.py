import boto3.ec2
'''
conn = boto.ec2.connect_to_region('ap-south-1')
reservations = conn.get_all_instances()
for r in reservations:
    for i in r.instances:
        print('%s\t%s' % (i.id, i.launch_time))'''

get_boto3_session(start_url, sso_region, account_id, role_name, *, region,
    login=False,
    sso_cache=None,
    credential_cache=None)