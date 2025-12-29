#!/bin/sh
EC2_NAME=$1
SSH_KEY_PATH=$2
PUBLIC_IP=$3
# Install jq if not already installed
yum install -y jq
# Get the private IP address of the instance with the given SERVER_NAME tag and ping it
touch /tmp/ip_address.txt
ssh -i ${SSH_KEY_PATH} ubuntu@${PUBLIC_IP}
aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=${EC2_NAME}" \
    --query "Reservations[].Instances[].PrivateIpAddress" \
    --output text > /tmp/ip_address.txt
ping -c 4 $(cat /tmp/ip_address.txt)
cat <<EOF
################################
SERVER_NAME: $SERVER_NAME
SERVER_IP: $(cat /tmp/ip_address.txt)
################################
EOF