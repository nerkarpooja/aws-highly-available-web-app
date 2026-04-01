# Highly Available Web Application Architecture on AWS
 (using Auto Scaling &amp; Load Balancer)

## Project Overview

This project demonstrates how to design and deploy a **Highly Available Web Application Architecture on AWS** using an **Application Load Balancer (ALB)** and **Auto Scaling Group (ASG)**.

The infrastructure distributes incoming traffic across multiple EC2 instances and automatically scales resources based on demand. This ensures **high availability, scalability, and fault tolerance**.

By deploying resources across **multiple Availability Zones**, the architecture eliminates **single points of failure** and ensures continuous application availability even during instance failure or traffic spikes.

**AWS Region Used:**
`eu-north-1 (Stockholm)`

---

# Architecture Diagram

![Architecture Diagram](screenshots/architecture-diagram.png)

## Architecture Flow

User → Application Load Balancer → Auto Scaling Group → EC2 Instances (Multi-AZ)

1. Users send requests to the application.
2. The **Application Load Balancer (ALB)** receives and distributes traffic.
3. Traffic is forwarded to EC2 instances registered in the **Target Group**.
4. The **Auto Scaling Group** maintains the desired number of instances.
5. **CloudWatch monitors CPU metrics** and triggers scaling events.

---

# Technologies Used

* Amazon EC2
* Amazon VPC
* Application Load Balancer (ALB)
* Auto Scaling Group (ASG)
* Amazon CloudWatch
* Amazon Linux 2
* Apache Web Server

---

# Project Architecture

The infrastructure consists of several AWS components that work together to provide a highly available environment.

---

# 1. Virtual Private Cloud (VPC)

A **custom VPC** was created to isolate the cloud environment and manage networking resources.

Configuration:

* CIDR Block: `10.0.0.0/16`
* Region: `eu-north-1`

### Screenshot

![VPC](screenshots/vpc-created.png)

---

# 2. Public Subnets

Two public subnets were created in **different Availability Zones** to provide redundancy and high availability.

Subnets:

* Public Subnet 1 – `eu-north-1a`
* Public Subnet 2 – `eu-north-1b`

These subnets host the **Application Load Balancer and EC2 instances**.

### Screenshot

![Subnets](screenshots/subnets.png)

---

# 3. Internet Gateway

An **Internet Gateway (IGW)** allows resources inside the VPC to communicate with the internet.

Route configuration:

`0.0.0.0/0 → Internet Gateway`

### Screenshot

![Internet Gateway](screenshots/internet-gateway.png)

---

# 4. Route Table

A route table was configured for public subnets to allow outbound internet access.

Configuration:

Destination → `0.0.0.0/0`
Target → `Internet Gateway`

### Screenshot

![Route Table](screenshots/route-table.png)

---

# 5. Security Group

A security group controls inbound and outbound traffic to EC2 instances.

Inbound Rules:

* HTTP (Port 80) → Anywhere
* SSH (Port 22) → My IP

### Screenshot

![Security Group](screenshots/security-group.png)

---

# 6. Launch Template

A **Launch Template** defines the EC2 configuration used by the Auto Scaling Group.

Configuration:

* AMI: Amazon Linux 2
* Instance Type: `t2.micro`
* Security Group: `web-sg`
* User Data Script for automatic web server installation

### Screenshot

![Launch Template](screenshots/launch-template.png)

### User Data Script

```
#!/bin/bash
yum update -y
yum install httpd -y

systemctl start httpd
systemctl enable httpd

echo "<h1>Highly Available Web Application</h1>" > /var/www/html/index.html
echo "<h2>Instance ID: $(hostname)</h2>" >> /var/www/html/index.html
```

This script automatically installs and starts **Apache Web Server** and displays the **instance hostname**, which helps verify load balancing.

---

# 7. Target Group

A **Target Group** routes traffic from the Application Load Balancer to EC2 instances.

Configuration:

* Protocol: HTTP
* Port: 80
* Health Check Path: `/`
* Success Code: `200`

The load balancer continuously monitors instance health.

### Screenshot

![Target Group](screenshots/target-group.png)

---

# 8. Application Load Balancer

An **internet-facing Application Load Balancer** distributes incoming traffic across EC2 instances.

Features:

* Listener on HTTP Port 80
* Traffic forwarding to Target Group
* Health checks for EC2 instances

This ensures requests are evenly distributed across available servers.

### Screenshot

![ALB](screenshots/alb-config.png)

---

# 9. Auto Scaling Group

The **Auto Scaling Group** ensures the application always has the required number of EC2 instances running.

Configuration:

Minimum Capacity: `2`
Desired Capacity: `2`
Maximum Capacity: `5`

Instances are distributed across multiple Availability Zones to increase availability.

### Screenshot

![ASG](screenshots/asg-config.png)

---

# 10. Scaling Policy

A **Target Tracking Scaling Policy** was configured to automatically adjust capacity based on CPU utilization.

Configuration:

Metric → Average CPU Utilization
Target Value → `50%`

Scaling behavior:

* CPU > 50% → Launch new EC2 instance
* CPU < 50% → Terminate extra instances

### Screenshot

![Scaling Policy](screenshots/scaling-policy.png)

---

# 11. CloudWatch Monitoring

Amazon CloudWatch monitors EC2 metrics such as:

* CPU Utilization
* Instance Count
* Network Traffic

CloudWatch metrics automatically trigger scaling policies when thresholds are reached.

### Screenshot

![Cloudwatch Metrics](screenshots/cloudwatch-metrics.png)

---

# High Availability Strategy

This architecture ensures high availability using the following strategies:

* Multi-Availability Zone deployment
* Load balancing across multiple EC2 instances
* Automatic instance replacement on failure
* Dynamic scaling based on CPU demand

If an instance becomes unhealthy, the **Application Load Balancer stops routing traffic to it**, and the **Auto Scaling Group launches a replacement instance automatically**.

---

# Testing and Validation

The system was tested to confirm that load balancing and auto scaling function correctly.

---

## Load Balancer Test

The Load Balancer DNS was accessed through a browser. Refreshing the page shows responses from **different EC2 instances**, proving that traffic is distributed across servers.

![Load Balancer Test](screenshots/application-running.png)

---

## Failover Test

One EC2 instance was manually terminated.

Result:

The Auto Scaling Group automatically launched a new instance to maintain the desired capacity.

---

## Auto Scaling Activity Logs

Scaling activities can be observed in the Auto Scaling **Activity History**.

![ASG Activity](screenshots/asg-recovery.png)

---

## Resource Cleanup (Deletion Steps)

After completing the project and testing the architecture, it is recommended to delete all AWS resources created during this project to avoid unnecessary charges.

Resources should be deleted in the **reverse order of creation** to prevent dependency errors.

### Deletion Steps

1. **Delete Auto Scaling Group**

   * Navigate to EC2 → Auto Scaling Groups
   * Select the Auto Scaling Group (`web-asg`)
   * Click **Actions → Delete**
   * Confirm deletion and terminate associated instances.

2. **Delete Application Load Balancer**

   * Navigate to EC2 → Load Balancers
   * Select the load balancer (`web-alb`)
   * Click **Actions → Delete**

3. **Delete Target Group**

   * Go to EC2 → Target Groups
   * Select `web-target-group`
   * Click **Actions → Delete**

4. **Delete Launch Template**

   * Navigate to EC2 → Launch Templates
   * Select `web-template`
   * Click **Actions → Delete Template**

5. **Terminate Remaining EC2 Instances**

   * Go to EC2 → Instances
   * Select any remaining instances
   * Click **Instance State → Terminate**

6. **Delete Security Group**

   * Navigate to EC2 → Security Groups
   * Select `web-sg`
   * Click **Delete**

7. **Delete Route Table**

   * Go to VPC → Route Tables
   * Select the route table (`public-rt`)
   * Delete it.

8. **Detach and Delete Internet Gateway**

   * Go to VPC → Internet Gateways
   * Select `ha-project-igw`
   * Click **Actions → Detach from VPC**
   * Then delete the Internet Gateway.

9. **Delete Subnets**

   * Navigate to VPC → Subnets
   * Delete `public-subnet-1` and `public-subnet-2`.

10. **Delete VPC**

    * Finally go to VPC → Your VPCs
    * Select `ha-project-vpc`
    * Click **Actions → Delete VPC**

Following these steps ensures that all resources created for the project are properly removed and no additional AWS costs are incurred.


# Project Repository Structure

```
aws-highly-available-web-app
│
├── architecture
│   └── architecture-diagram.png
│
├── screenshots
│   ├── vpc-created.png
│   ├── subnets.png
│   ├── internet-gateway.png
│   ├── route-table.png
│   ├── security-group.png
│   ├── launch-template.png
│   ├── target-group.png
│   ├── alb-config.png
│   ├── asg-config.png
│   ├── scaling-policy.png
│   ├── load-balancer-test.png
│   └── asg-activity.png
│
└── README.md
```

---

# Conclusion

This project demonstrates how to build a **highly available and scalable web application infrastructure on AWS**.

By combining:

* Application Load Balancer
* Auto Scaling Group
* CloudWatch Monitoring
* Multi-Availability Zone deployment

the system can automatically adapt to traffic changes while maintaining application availability.

This architecture reflects real-world cloud infrastructure practices used to ensure **reliability, scalability, and fault tolerance** in production environments.
