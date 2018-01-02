#!/bin/bash

## This script will run packer
## AWS Profile name is passed on the command, so make sure to update to a real profile name


## Run Packer
AWS_PROFILE=personal /usr/local/bin/packer build ./kafka_ami.json

