#! /bin/bash
set -e

SHA1=$1
BUCKET=$2

ACCESS_KEY=$AWS_ACCESS_KEY_ID
SECRET_KEY=$AWS_SECRET_KEY_ID

# Deploy image to Docker Hub
docker push jimmyrosa/sunodejs:$SHA1

# Create new Elastic Beanstalk version
DOCKERRUN_FILE=$SHA1-Dockerrun.aws.json

sed "s/<TAG>/$SHA1/" < Dockerrun.aws.json.template > $DOCKERRUN_FILE
aws s3 cp $DOCKERRUN_FILE s3://$BUCKET/$DOCKERRUN_FILE
aws elasticbeanstalk create-application-version --application-name bit-portal --version-label $SHA1 --source-bundle S3Bucket=$EB_BUCKET,S3Key=$DOCKERRUN_FILE --region us-east-2

 # Update Elastic Beanstalk environment to new version
aws elasticbeanstalk update-environment --environment-name bit-portal-env --version-label $SHA1 --region us-east-2