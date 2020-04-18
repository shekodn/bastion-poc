# Bastion Host Proof of Concept

### TL;DR
Deploying a Bastion Host PoC in AWS using CloudFormation.

![overview](./docs/diagram.png)

The idea of implementing a Bastion Host is being able to reduce the attack
surface by doing 2 things:

1. Remove the application instances (could also be database instances) or other
servers that are not meant to be open to the world.

2. Be able to harden one machine (the bastion) and not
each and every other server in our infrastructure. The ~~more~~ less the
merrier.

## Getting Started

### Prerequisites
Make sure you create a key pair in us-east-1 availability zone. We will use it
to connect to our instance.

### Set the vars

```
# deploy.sh

STACK_NAME=bastion-poc
REGION=us-east-1
CLI_PROFILE=<your-aws-profile-with-an-appropiate-role>
EC2_INSTANCE_TYPE=t2.micro
KEY_NAME=<your-key-pair-name>
```

### Run the script
```
./deploy.sh
```

After a couple of minutes you should see 2 IPs. If so, we are golden ;)

###### If you want to debug or see what happened go to the respective CloudFormation stack in the AWS console.

### Config your ssh config file

Go to ```~/.ssh/config``` and add the following hosts:
```
...

### The Bastion Host
Host bastion-host-poc
    HostName <public-ip-from-output>
    User ec2-user
    Port 22
    IdentityFile ~/.ssh/<your-key-pair-private-key>

### The App Host
Host app-host-poc
    HostName <private-ip-from-output>
    User ec2-user
    IdentityFile ~/.ssh/<your-key-pair-private-key>
    ProxyJump bastion-host-poc
```
