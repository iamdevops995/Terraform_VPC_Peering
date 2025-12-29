# Container image that runs your code
FROM amazon/aws-cli:2.17.44
RUN yum update -y  && yum install -y curl jq 
#
COPY entrypoint.sh /entrypoint.sh
#
RUN chmod +x /entrypoint.sh &&
#
# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]