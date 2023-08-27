#!/bin/bash

sudo docker-compose -f /home/ec2-user/q_parts/docker-compose.yml down

docker rmi -f $1

sudo docker-compose -f /home/ec2-user/q_parts/docker-compose.yml up -d
echo "Check for deleting the old images...."

output=$(docker images -q -f dangling=true)

# Check if the output is not empty
if [ -n "$output" ]; then
    echo "There some old images and it would be deleted: $output"
    docker rmi $(docker images -q -f dangling=true)
else
    echo "There are no old versions of the images.... "
fi
#docker rmi $(docker images -q -f dangling=true)

