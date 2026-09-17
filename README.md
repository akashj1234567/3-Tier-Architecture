# 3-Tier-Architecture

1. Create AWS VPC
Create one VPC, for example:
VPC: 10.0.0.0/16
Use 2 Availability Zones for high availability.

2. Create subnets
Create 6 subnets:
AZ-1                         AZ-2

Public-Subnet-1              Public-Subnet-2
10.0.1.0/24                  10.0.2.0/24

Private-App-Subnet-1         Private-App-Subnet-2
10.0.11.0/24                 10.0.12.0/24

Private-DB-Subnet-1          Private-DB-Subnet-2
10.0.21.0/24                 10.0.22.0/24

3. Create Internet Gateway
Attach an Internet Gateway to the VPC.

Internet traffic will flow:
Internet
   ↓
Internet Gateway
   ↓
Public Subnets

4. Create NAT Gateway
Create NAT Gateway in the public subnet.
The application servers in private subnets can then access the internet for updates without being directly accessible from the internet.
Private App Server
       ↓
   NAT Gateway
       ↓
   Internet Gateway
       ↓
     Internet

5. Create Route Tables
Create:
Public Route Table
Private Application Route Table
Private Database Route Table
Public route:
0.0.0.0/0 → Internet Gateway
Private application route:
0.0.0.0/0 → NAT Gateway
Database subnets should generally have no direct internet route.

6. Create Security Groups
Create separate security groups.
Internet
   ↓
ALB Security Group
   ↓
App Security Group
   ↓
RDS Security Group
Example:
ALB SG
Allow HTTP/HTTPS from internet.
Application SG
Allow application traffic only from ALB SG.
RDS SG
Allow database port only from Application SG.
This creates the security boundary between the three tiers.

7. Create Application Load Balancer
Deploy an Application Load Balancer in the two public subnets.
Users
  ↓
ALB
  ↓
Target Group

8. Create Application Servers
Create EC2 instances in the private application subnets.
For a more production-like design, use:
Launch Template
Auto Scaling Group
2 EC2 instances
Two Availability Zones
             ALB
           /     \
        EC2-1   EC2-2
          AZ-1    AZ-2

9. Create RDS Database
Create Amazon RDS in the two private database subnets using a DB subnet group.
Example:
EC2
 ↓
RDs

10. Deploy the application
Your application could be:
Frontend → HTML/CSS/JavaScript
Backend  → Node.js / Python / Java
Database → MySQL / PostgreSQL
For a beginner project, you can use a simple application that displays data retrieved from RDS.

11. Test the architecture
 Browser
   ↓
ALB
   ↓
EC2
   ↓
RDS

ALB is reachable.
EC2 is not directly accessible from the internet.
Application can connect to RDS.
RDS is not publicly accessible.
Both AZs are configured correctly.

12. Add monitoring
Use CloudWatch for:
EC2 CPU utilization
ALB metrics
RDS metrics
Application logs




