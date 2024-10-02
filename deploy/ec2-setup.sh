#!/bin/bash -xe

chmod 600 /home/ec2-user/.ssh/ec2_to_github 
echo 'Host github.com\n  IdentityFile /home/ec2-user/.ssh/ec2_to_github' >> /home/ec2-user/.ssh/config 
chmod 600 /home/ec2-user/.ssh/config 

cd /home/ec2-user && eval "$(ssh-agent -s)"
cd /home/ec2-user && ssh-add /home/ec2-user/.ssh/ec2_to_github

cd /home/ec2-user && git clone git@github.com:oli-csc/aaf-internal-notes-system.git #we will need to clone this repo on the ec2 instance in order to run the application 

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash 
source ~/.bashrc 
nvm install 14.16.0 
nvm use 14.16.0

cd /home/ec2-user/aaf-internal-notes-system/01-notebook && npm install
cd /home/ec2-user/aaf-internal-notes-system/01-notebook && node server.js 8080 &
cd /home/ec2-user/aaf-internal-notes-system/01-notebook && sudo python3 -m http.server 80