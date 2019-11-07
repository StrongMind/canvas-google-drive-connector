#!/bin/bash

# usage: ./deploy.sh staging f0478bd7c2f584b41a49405c91a439ce9d944657
# license: public domain

TAG=$2

NAME=canvas-google-lti-connector
ECR_REPO=google-lti-connector
ENVIRONMENT=$1
EB_BUCKET=elasticbeanstalk-us-west-2-448312246740

ZIP=$TAG.zip

echo $TAG
echo $ZIP

aws configure set default.region us-west-2

# Authenticate against our Docker registry
eval $(aws ecr get-login --no-include-email)

# Generate Dockerrun.aws.json
ansible-playbook -i "localhost", write-dockerrun.yml --vault-password-file=~/.vault_pass.txt --extra-vars="TAG=$TAG ECR_REPO=$ECR_REPO"

# Zip up the Dockerrun file (feel free to zip up an .ebextensions directory with it)
zip -r $ZIP Dockerrun.aws.json

aws s3 cp $ZIP s3://$EB_BUCKET/$ZIP

# Create a new application version with the zipped up Dockerrun file
aws elasticbeanstalk create-application-version --application-name $NAME \
    --version-label $TAG --source-bundle S3Bucket=$EB_BUCKET,S3Key=$ZIP

# Update the environment to use the new application version
aws elasticbeanstalk update-environment --environment-name canvas-google-lti-connector-$ENVIRONMENT \
      --version-label $TAG

# Cleanup bro!
rm $ZIP
rm Dockerrun.aws.json
