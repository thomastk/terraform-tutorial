Terraform Tutorial that describes how an Amazon Linux VM is spun up on AWS and Wordpress is installed on it.

Configuration

1. In the env, set these AWS credentials that point to your AWS account that is used for this tutorial:
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY

2. In variables.tf, update these variables specific to your environment.
private_key_path
public_key_path

Also, look at the other variables set in variables.tf so they are compatible with your environment and AWS account.

3. In provisioners/install-wordpress-amzn-linux.sh, following configs are hardcoded: 
MySQL database name
database user name
database user password

If needed update those but not required if you are OK with default settings.
