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

📸 Screenshot:
![VPC](./screenshots/vpc.png)

---

## 🌐 Step 2: Create Subnets

📸 Screenshot:
![Subnets](./screenshots/subnet.png)

---

## 🌍 Step 3: Attach Internet Gateway

📸 Screenshot:
![Internet Gateway](./screenshots/internet-gateway.png)

---

## 🛣️ Step 4: Configure Route Table

📸 Screenshot:
![Route Table](./screenshots/route-table.png)

---

## 💻 Step 5: EC2 Instances Running

📸 Screenshot:
![EC2 Instances](./screenshots/ec2-instances.png)

---

## ⚙️ Step 6: Create Launch Template

📸 Screenshot:
![Launch Template](./screenshots/launch-template.png)

---

## 🎯 Step 7: Create Target Group

📸 Screenshot:
![Target Group](./screenshots/target-group.png)

---

## 🌍 Step 8: Create Application Load Balancer

📸 Screenshot:
![Load Balancer](./screenshots/load-balancer.png)

---

## 🔁 Step 9: Create Auto Scaling Group

📸 Screenshot:
![Auto Scaling Group](./screenshots/auto-scaling-group.jpeg)

---

## 📊 Step 10: Configure CloudWatch Alarm

📸 Screenshot:
![CloudWatch Alarm](./screenshots/cloud-watch-metrics.jpeg)

---

## 🌐 Step 11: Verify Load Balancing Output

### 🔹 Instance (AZ-1)
![Output AZ1](./screenshots/output-az1.png)

### 🔹 Instance (AZ-2)
![Output AZ2](./screenshots/output-az2.png)

---

# 💻 User Data Script

This project uses a **user-data script** to automate instance setup.

### 🔧 Features:
- Installs Nginx
- Starts & enables service
- Fetches metadata using IMDSv2
- Generates dynamic HTML page

---

# 🎯 Key Features

- ✅ High Availability (Multi-AZ)
- ✅ Auto Scaling based on CPU utilization
- ✅ Load Balanced traffic distribution
- ✅ Self-healing infrastructure
- ✅ Dynamic instance-level visualization

---

# 📈 Real-World Use Case

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