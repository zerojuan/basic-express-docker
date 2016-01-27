#!/bin/bash
SERVICE_NAME="express-test-service"
IMAGE_VERSION="v_"${BUILD_NUMBER}
TASK_FAMILY="basic-express"
REGION="ap-southeast-2"

# Create a new task definition for this build
sed -e "s;%BUILD_NUMBER%;${BUILD_NUMBER};g" ./config/basic-express.json > basic-express-v_${BUILD_NUMBER}.json
aws ecs register-task-definition --family basic-express --cli-input-json file://basic-express-v_${BUILD_NUMBER}.json --region ${REGION}

# Update the service with the new task definition and desired count
TASK_REVISION=`aws ecs describe-task-definition --task-definition basic-express --region ${REGION} | egrep "revision" | tr "/" " " | awk '{print $2}' | sed 's/"$//'`
DESIRED_COUNT=`aws ecs describe-services --services ${SERVICE_NAME} --region ${REGION} | egrep -m 1 "desiredCount" | tr "/" " " | awk '{print $2}' | sed 's/,$//'`
if [ ${DESIRED_COUNT} = "0" ]; then
    DESIRED_COUNT="1"
fi

aws ecs update-service --cluster default --service ${SERVICE_NAME} --task-definition ${TASK_FAMILY}:${TASK_REVISION} --desired-count ${DESIRED_COUNT} --region ${REGION}
