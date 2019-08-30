#!/bin/bash
set -eu

STAGE="${1:-dev}"
echo "Deploying static assets to ${STAGE}..."

BUCKET_NAME=$(aws --profile krlozadan \
    cloudformation describe-stacks \
    --stack-name "graphql-news-app-${STAGE}" \
    --query "Stacks[0].Outputs[?OutputKey=='WebSiteBucket'] | [0].OutputValue" \
    --output text)

WEBSITE_URL=$(aws --profile krlozadan \
    cloudformation describe-stacks \
    --stack-name "graphql-news-app-${STAGE}" \
    --query "Stacks[0].Outputs[?OutputKey=='WebSiteUrl'] | [0].OutputValue" \
    --output text)

aws --profile krlozadan s3 sync --acl 'public-read' --delete ./static/ "s3://${BUCKET_NAME}/"

echo "Bucket URL: ${WEBSITE_URL}"
