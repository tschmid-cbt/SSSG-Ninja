# SSSG Ninja

## Overview
Site Shield is the fancy name for IP white listing of Akamai, it provides an additional layer of protection that helps prevent attackers from bypassing cloud-based protections to target the application origin. 

Security Group is the security component of AWS, it acts as a virutal firewall for insstances to controls the inbount/outbound traffics.

With the frequent site shield cidr updates (add or remove cidr) and the different acknowledge order for add and remove operations, it becomes difficult to keep the security groups up to date. Also you have to keep track of the security group usage, as it may reach the limits.

SSSG Ninja is the all-in-one management tool for SSSG (Site Shield Security Group), it not only makes recommendations but also can do the jobs for you. Here are current supported features:

- [x] Make recommendations based on health check
- [x] Add missed site shield cidr to security groups
- [x] Add new site shield cidr to security groups
- [x] Remove obsolete site shield cidr from security groups
- [x] Check the security group limits
- [x] Check site shield map information
- [x] Search cidr in security groups
- [x] Acknowledge site shield change
- [x] Debug mode logging

## Lambda Fork
SSSG Ninja was modified to run in AWS's serverless architecture.  In doing so some static configuration files need to be modified, and to ensure the tool is working as intended you should monitor cloudwatch accordingly.

This is a lambda function to update AWS Security Groups with IP CIDR blocks obtained from Akamai's API.  To manage the API user - within the Luna Portal navigate to Configure > Organization > Manage APIs.  The user you create will
have a base URL we configure to send API requests, as well as auth tokens. These are configured in file sssg.py. File sssg.py must also have the Security Groups listed in line:  siteshield_sg_groups = and the appropriate
siteshield_map_ids listed above it.  To view the map ID simply view the output of the lambda.

## Terminologies
If you want to deep dive into the tool, here are a few terms you need to know  

| Terminology       | Description            
| ------------- |-------------  | 
| current cidr   | current site shield production cidr
| proposed cidr  | new site shield production cidr   
| new cidr			 | additional cidr to current site shield production cidr   
| staging cidr   | site shield staging cidr  
| configed cidr  | source cidr in security groups  
| trusted cidr   | non site shield cidr but colocate within security groups
| missed cidr    | missed site shield production or staging cidr in security groups  
| obsolete cidr  | obsolete site shield cidr in security groups
| empty slots		 | free security group rule space  

## Installation
Refer the example section for details  
1. Clone the project   
2. Edit sssg.py modifying anything with CHANGE-ME to your account specific details.  Recommend adding more than one Security Group as the current CIDRs are approaching AWS limits.
3. Edit push.sh with the credentials profile name and lamdba function name.  Edit securitygroup/__init__.py with the AWS region you are modifying.
4. Push configuration up to lambda with ./push.sh and in the console set the runtime to Python 3.6 and Handler to sssg.event_handler and test to get map IDs, if necessary.
5. Modify sssg.py with map IDs and push again, if needed.  
6. Add a trigger using CloudWatch Events with sceduled expression rate(1 day) to enable daily updates.
7. Add lambdas in every region where you have Akamai origins and add the security groups to all origins.

## Limitations
The original SSSG Ninja has the flexibility to run individual components of the script by passing args on the command line.  This solution is meant to fully automate the solution without the need to manage the underlying infrastructure.  Cloudwatch logs must be monitored to verify functionality.
