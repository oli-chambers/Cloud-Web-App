#! /usr/bin/env bash


set -eo pipefail

## Deploys the networking stack
if [[ -z "${STUDENT_NAME}" ]]; then
  echo "STUDENT_NAME is not set"
  exit 1
fi

readonly STACK_NAME="${STUDENT_NAME}-networking" #set student name for creation of the vpc
readonly TEMPLATE_FILE="$(dirname "${BASH_SOURCE[0]}")/../cloudformation/networking.yml" #template file for network config
readonly AWS_DEFAULT_REGION="eu-west-2"

aws cloudformation deploy \
  --stack-name "${STACK_NAME}" \
  --template-file "${TEMPLATE_FILE}" \
  --capabilities CAPABILITY_IAM \
  --no-fail-on-empty-changeset \
  --tags "StudentName=${STUDENT_NAME}" \
  --region "${AWS_DEFAULT_REGION}" 


sleep 10 #this should enable the user data script to run
public_key=$(ssh-keyscan -t ed25519 3.11.219.5)
echo "$public_key" >> ~/.ssh/known_hosts
#copies the github private key for the ec2 instance to the ec2 instance.
scp -i ~/SDS_cw2/SDS-cw2/keys/ssh-into-ec2.pem ~/SDS_cw2/SDS-cw2/keys/ec2_to_github ec2-user@3.11.219.5:/home/ec2-user/.ssh/ec2_to_github
#copies the ec2 setup script to the ec2 instance
scp -i ~/SDS_cw2/SDS-cw2/keys/ssh-into-ec2.pem ~/SDS_cw2/SDS-cw2/deploy/ec2-setup.sh ec2-user@3.11.219.5:/home/ec2-user