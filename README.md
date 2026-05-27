# AWS Scalable Web with WAF, ALB and Auto Scaling

### Why I built this
I learned Load Balancer and Auto Scaling on AWS and wanted to prove I can build a website that does not crash when traffic spikes. I built it first in the AWS Console, then documented it here so anyone can recreate it in 5 minutes and delete it after.

Think of it like a chai shop that opens more counters automatically when the line gets long.

---

### What happens when you open the website
1. You type the link
2. **WAF** (Web Application Firewall) checks for bad requests and blocks them
3. **ALB** (Application Load Balancer) picks the least busy server
4. **Auto Scaling** adds servers if CPU goes high, removes them when quiet
5. You see: "Welcome to My Scalable Site — Served by Nginx on Docker"

---

### What is WAF?
WAF is the security guard in front. It blocks common attacks before they reach your server.

**Rules I used:**
- AWSManagedRulesCommonRuleSet
- SQL injection rule
- XSS rule
- IP reputation list
- Rate-based rule (blocks >2000 requests/5min)

### What is Load Balancer?
The traffic cop. It spreads users across healthy servers.

**Types in AWS:**
- ALB (Layer 7, HTTP) — I used this
- NLB (Layer 4, TCP)
- GWLB (for firewalls)
- Classic (old)

### Why Launch Template?
It's a saved recipe for EC2: AMI, t2.micro, Docker installed, run Nginx. Auto Scaling uses it so every new server is identical.

### What is Auto Scaling?
The manager that watches CPU.
- Min: 1, Max: 5, Desired: 1
- Scale out when CPU > 60% for 2 min
- Scale in when CPU < 30% for 5 min

---

### How I used Docker and Nginx
I did not install software by hand. The Launch Template starts Docker and runs the official `nginx:alpine` image. Nginx serves a simple static HTML page that shows the EC2 instance ID. This proves the load balancer is working.

Because it's Docker, every server boots in 30 seconds with the exact same website.

---

### How I made it live (and kept it free)
1. Built in AWS Console: WAF → ALB → Target Group → Launch Template → ASG
2. Tested with `curl` to ALB DNS
3. Ran `stress-ng --cpu 2 --timeout 180` to force scaling from 1 to 2-3 servers
4. Took screenshots for docs/
5. Deleted everything: ASG → ALB → WAF

Total cost < ₹10 for 20 minutes on free tier.
