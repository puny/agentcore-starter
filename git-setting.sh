#!/bin/bash

aws s3 sync s3://namkj-s3/dev/gpg/ ~/.ssh/
aws s3 cp s3://namkj-s3/dev/aws/keypair/github-ssh-key ~/.ssh/

cat > ~/.ssh/config << EOF
Host github.com
  HostName github.com
  User puny
  IdentityFile /home/ec2-user/.ssh/github-ssh-key
  IdentitiesOnly yes
EOF

chmod 600 ~/.ssh/*

gpg --import ~/.ssh/gpg-private-puny428@nate
gpg --import ~/.ssh/gpg-public-puny428@nate

git config --global user.name "namkj"
git config --global user.email "puny428@nate.com"

git config --global user.signingkey D916BF2E
git config --global commit.gpgsign true