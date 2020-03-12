#!/bin/bash
set -e

BAKED_IMAGE_ID=$(jq -r '.builds[0].artifact_id' manifest.json | cut -d: -f2)
echo "Baked image ID: ${BAKED_IMAGE_ID}"

SOURCE_IMAGE_ID=$(grep -m 1 "Found Image ID:" output.log | awk '{print $NF}')
echo "Source image ID: ${SOURCE_IMAGE_ID}"

SOURCE_IMAGE_INFO=$(aws ec2 describe-images \
    --image-ids $SOURCE_IMAGE_ID \
    --query 'Images[0].{OwnerId:OwnerId,Name:Name,CreationDate:CreationDate}')

echo "Tagging image..."
aws ec2 create-tags \
    --resources $BAKED_IMAGE_ID \
    --tags \
        Key=SourceImageId,Value=$SOURCE_IMAGE_ID \
        Key=SourceImageOwnerId,Value=$(echo $SOURCE_IMAGE_INFO | jq -r .OwnerId) \
        Key=SourceImageName,Value=$(echo $SOURCE_IMAGE_INFO | jq -r .Name) \
        Key=SourceImageCreationDate,Value=$(echo $SOURCE_IMAGE_INFO | jq -r .CreationDate)
