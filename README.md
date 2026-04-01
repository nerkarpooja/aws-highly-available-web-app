# 🚀 Highly Available Auto Scaling Web Architecture on AWS

<p align="center">
  <img src="https://img.shields.io/badge/AWS-Cloud-orange?style=for-the-badge&logo=amazonaws" />
  <img src="https://img.shields.io/badge/EC2-Compute-blue?style=for-the-badge&logo=amazon-ec2" />
  <img src="https://img.shields.io/badge/AutoScaling-Dynamic-green?style=for-the-badge&logo=amazonec2" />
  <img src="https://img.shields.io/badge/LoadBalancer-ALB-yellow?style=for-the-badge&logo=amazonaws" />
  <img src="https://img.shields.io/badge/CloudWatch-Monitoring-red?style=for-the-badge&logo=amazonaws" />
</p>

---

## 📌 Overview

This project demonstrates a **Highly Available, Fault-Tolerant, and Scalable Web Architecture** on AWS.

It uses **Auto Scaling + Load Balancer + Multi-AZ deployment** to ensure:
- Zero downtime
- Automatic recovery
- Traffic distribution
- Dynamic scaling based on CPU usage

---

## 🏗️ Architecture

> 📌 Add your architecture diagram here

![Architecture](./screenshots/architecture.png)

---

## ⚙️ Tech Stack

| Service | Purpose |
|--------|--------|
| EC2 | Web server (Nginx) |
| ALB | Distributes traffic |
| ASG | Auto scaling |
| VPC | Network isolation |
| CloudWatch | Monitoring |
| Nginx | Web server |

---

# 🚀 Step-by-Step Implementation

---

## 🧩 Step 1: Create VPC

- Created custom VPC
- Enabled DNS support

📸 Screenshot:
![VPC](./screenshots/01-vpc.png)

---

## 🌐 Step 2: Create Subnets

- 2 Public Subnets
- Different Availability Zones

📸 Screenshot:
![Subnets](./screenshots/02-subnets.png)

---

## 🌍 Step 3: Attach Internet Gateway

- Enables internet access

📸 Screenshot:
![Internet Gateway](./screenshots/03-internet-gateway.png)

---

## 🛣️ Step 4: Configure Route Table

- Added route:
  - `0.0.0.0/0 → IGW`

📸 Screenshot:
![Route Table](./screenshots/04-route-table.png)

---

## 💻 Step 5: Launch EC2 Instances (via ASG later)

- Instances will be created using Launch Template
- Distributed across multiple AZs

📸 Screenshot:
![EC2 Instances](./screenshots/05-ec2-instances.png)

---

## ⚙️ Step 6: Create Launch Template

- AMI: Amazon Linux
- Instance Type: t2.micro
- Added User Data Script (Nginx + dynamic HTML)

📸 Screenshot:
![Launch Template](./screenshots/06-launch-template.png)

---

## 🎯 Step 7: Create Target Group

- Protocol: HTTP
- Port: 80
- Health checks enabled

📸 Screenshot:
![Target Group](./screenshots/07-target-group.png)

---

## 🌍 Step 8: Create Application Load Balancer

- Internet-facing
- Listener: HTTP (80)
- Attached Target Group

📸 Screenshot:
![Load Balancer](./screenshots/08-load-balancer.png)

---

## 🔁 Step 9: Create Auto Scaling Group

- Min: 2
- Desired: 2
- Max: 5
- Multi-AZ deployment

📸 Screenshot:
![Auto Scaling Group](./screenshots/09-auto-scaling-group.png)

---

## 📊 Step 10: Configure CloudWatch Alarm

- Scale Out: CPU > 70%
- Scale In: CPU < 30%

📸 Screenshot:
![CloudWatch Alarm](./screenshots/10-cloudwatch-alarm.png)

---

## 🌐 Step 11: Verify Load Balancing Output

Access ALB DNS and refresh multiple times:

### 🔹 Instance (AZ-1)
![Output AZ1](./screenshots/11-output-az1.png)

### 🔹 Instance (AZ-2)
![Output AZ2](./screenshots/12-output-az2.png)

---

# 💻 User Data Script

This project uses a **user-data script** to automate instance setup.

### 🔧 Features:
- Installs Nginx
- Starts & enables service
- Fetches metadata using IMDSv2
- Generates dynamic HTML page

### 📌 Output displays:
- Instance ID
- Availability Zone
- Region
- Private IP

---

# 🎯 Key Features

- ✅ High Availability (Multi-AZ)
- ✅ Auto Scaling based on CPU utilization
- ✅ Load Balanced traffic distribution
- ✅ Self-healing infrastructure
- ✅ Dynamic instance-level visualization

---

# 📈 Real-World Use Case

This architecture is similar to:
- Production web applications
- SaaS platforms
- Scalable backend systems

---

# 📌 Conclusion

This project demonstrates a **production-grade AWS architecture** with:

- Scalability  
- Fault tolerance  
- High availability  
- Automation  

---

# 👨‍💻 Author

**Pooja Nerkar**

---

# ⭐ If you like this project

Give it a ⭐ on GitHub!