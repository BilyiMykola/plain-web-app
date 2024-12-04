#!/bin/bash

sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo usermod -aG docker ec2-user
newgrp docker

docker run --detach --publish 80:80 --name plain-web-app m567/plain-web-app-image

docker run -detach --name watchtower -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --interval 10 --cleanup
