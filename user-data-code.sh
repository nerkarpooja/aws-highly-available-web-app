#!/bin/bash
yum update -y
yum install -y nginx
systemctl start nginx
systemctl enable nginx

# IMDSv2 - get token first, then use it for all metadata calls
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/placement/availability-zone)
REGION=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/placement/region)
PRIVATE_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/local-ipv4)

python3 - << PYEOF
instance_id = "$INSTANCE_ID"
az          = "$AZ"
region      = "$REGION"
private_ip  = "$PRIVATE_IP"

html = """<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>HA Auto Scaling Project</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&family=Syne:wght@400;800&display=swap" rel="stylesheet"/>
<style>
*{{box-sizing:border-box;margin:0;padding:0}}
:root{{--bg:#0a0a0f;--card:#13131f;--border:#1e1e2e;--g:#00f5a0;--b:#00d9f5;--p:#f500f5;--o:#f5a000;--r:#f55000;--t:#e8e8f0;--m:#6b6b8a}}
body{{background:var(--bg);color:var(--t);font-family:'Syne',sans-serif;padding:24px}}
body::before{{content:'';position:fixed;inset:0;background-image:linear-gradient(var(--border) 1px,transparent 1px),linear-gradient(90deg,var(--border) 1px,transparent 1px);background-size:50px 50px;opacity:.3;z-index:0;pointer-events:none}}
.wrap{{position:relative;z-index:1;max-width:1100px;margin:0 auto}}
.hero{{padding:60px 0 40px}}
.eyebrow{{font-family:'Space Mono',monospace;font-size:10px;letter-spacing:4px;text-transform:uppercase;color:var(--g);margin-bottom:16px;display:flex;align-items:center;gap:10px}}
.eyebrow::before{{content:'';width:28px;height:1px;background:var(--g);box-shadow:0 0 8px var(--g)}}
h1{{font-size:clamp(36px,6vw,72px);font-weight:800;line-height:1.05;margin-bottom:24px}}
.c1{{color:var(--t)}}.c2{{background:linear-gradient(90deg,var(--g),var(--b));-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text}}.c3{{background:linear-gradient(90deg,var(--p),var(--o));-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text}}
.badges{{display:flex;flex-wrap:wrap;gap:10px;margin-bottom:40px}}
.badge{{padding:6px 14px;border-radius:4px;font-family:'Space Mono',monospace;font-size:10px;letter-spacing:1px;text-transform:uppercase;font-weight:700;border:1px solid}}
.bg{{border-color:var(--g);color:var(--g);background:rgba(0,245,160,.1)}}
.bb{{border-color:var(--b);color:var(--b);background:rgba(0,217,245,.1)}}
.bp{{border-color:var(--p);color:var(--p);background:rgba(245,0,245,.1)}}
.bo{{border-color:var(--o);color:var(--o);background:rgba(245,160,0,.1)}}
.ibox{{background:var(--card);border:1px solid var(--g);border-radius:10px;padding:20px 24px;display:grid;grid-template-columns:repeat(auto-fit,minmax(160px,1fr));gap:16px;box-shadow:0 0 30px rgba(0,245,160,.12);margin-bottom:60px}}
.il{{font-family:'Space Mono',monospace;font-size:9px;letter-spacing:2px;text-transform:uppercase;color:var(--m);margin-bottom:4px}}
.iv{{font-family:'Space Mono',monospace;font-size:13px;color:var(--g);word-break:break-all}}
.dot{{display:inline-block;width:7px;height:7px;border-radius:50%;background:var(--g);box-shadow:0 0 8px var(--g);animation:pulse 1.5s infinite;margin-right:5px}}
.sec{{margin-bottom:56px}}
.tag{{font-family:'Space Mono',monospace;font-size:9px;letter-spacing:4px;text-transform:uppercase;margin-bottom:10px}}
h2{{font-size:clamp(24px,3.5vw,40px);font-weight:800;margin-bottom:32px;line-height:1.1}}
.grid2{{display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:16px}}
.card{{background:var(--card);border:1px solid var(--border);border-radius:10px;padding:22px 18px;transition:transform .2s}}
.card:hover{{transform:translateY(-3px)}}
.ct{{height:3px;border-radius:10px 10px 0 0;margin:-22px -18px 16px}}
.ci{{font-size:28px;margin-bottom:10px}}
.cn{{font-size:14px;font-weight:800;margin-bottom:4px}}
.cr{{font-family:'Space Mono',monospace;font-size:9px;letter-spacing:1.5px;text-transform:uppercase;margin-bottom:8px}}
.cd{{font-size:12px;color:var(--m);line-height:1.55}}
.stat-row{{display:grid;grid-template-columns:repeat(auto-fit,minmax(140px,1fr));gap:14px;margin-bottom:24px}}
.stat{{background:var(--card);border:1px solid var(--border);border-radius:10px;padding:20px;text-align:center}}
.sn{{font-size:42px;font-weight:800;line-height:1}}
.sl{{font-family:'Space Mono',monospace;font-size:9px;letter-spacing:2px;text-transform:uppercase;color:var(--m);margin-top:4px}}
.pcard{{background:var(--card);border:1px solid var(--border);border-radius:10px;padding:22px}}
.pt{{font-size:13px;font-weight:800;color:var(--o);margin-bottom:16px}}
.pr{{display:flex;justify-content:space-between;padding:10px 0;border-bottom:1px solid var(--border);font-family:'Space Mono',monospace;font-size:11px}}
.pr:last-child{{border-bottom:none}}
.pk{{color:var(--m)}}.pv{{color:var(--g);font-weight:700}}
.ha{{display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:16px}}
.hc{{background:var(--card);border:1px solid var(--border);border-radius:10px;padding:26px 20px;position:relative;overflow:hidden}}
.hn{{font-size:60px;font-weight:800;position:absolute;top:-8px;right:12px;opacity:.06;line-height:1}}
.hi{{font-size:28px;margin-bottom:12px}}
.ht{{font-size:15px;font-weight:800;margin-bottom:8px}}
.hd{{font-size:12px;color:var(--m);line-height:1.6}}
footer{{border-top:1px solid var(--border);padding:28px 0;text-align:center;font-family:'Space Mono',monospace;font-size:10px;color:var(--m)}}
footer span{{color:var(--g)}}
@keyframes pulse{{0%,100%{{opacity:1}}50%{{opacity:.4}}}}
</style>
</head>
<body>
<div class="wrap">

<section class="hero">
  <div class="eyebrow">Cloud Engineering Internship -- Project Set 6</div>
  <h1>
    <span class="c1">Highly Available</span><br>
    <span class="c2">Auto Scaling</span><br>
    <span class="c3">Web Architecture</span>
  </h1>
  <div class="badges">
    <span class="badge bg">&#x1F30D; Multi-AZ</span>
    <span class="badge bb">&#x1F504; Auto Scaling</span>
    <span class="badge bp">&#x2696;&#xFE0F; Load Balanced</span>
    <span class="badge bo">&#x2705; Zero SPOF</span>
  </div>
</section>

<div class="ibox">
  <div><div class="il">Status</div><div class="iv"><span class="dot"></span>&#x1F7E2; LIVE</div></div>
  <div><div class="il">Instance ID</div><div class="iv">{instance_id}</div></div>
  <div><div class="il">Avail. Zone</div><div class="iv">{az}</div></div>
  <div><div class="il">Region</div><div class="iv">{region}</div></div>
  <div><div class="il">Private IP</div><div class="iv">{private_ip}</div></div>
</div>

<section class="sec">
  <div class="tag" style="color:var(--b)">// Tech Stack</div>
  <h2>Technologies Used</h2>
  <div class="grid2">
    <div class="card">
      <div class="ct" style="background:linear-gradient(90deg,var(--g),var(--b))"></div>
      <div class="ci">&#x1F5A5;&#xFE0F;</div>
      <div class="cn">Amazon EC2</div>
      <div class="cr" style="color:var(--g)">Compute</div>
      <div class="cd">Amazon Linux 2 with Nginx. Bootstrapped via Launch Template user data.</div>
    </div>
    <div class="card">
      <div class="ct" style="background:linear-gradient(90deg,var(--b),var(--p))"></div>
      <div class="ci">&#x2696;&#xFE0F;</div>
      <div class="cn">App Load Balancer</div>
      <div class="cr" style="color:var(--b)">Traffic Distribution</div>
      <div class="cd">Layer-7 ALB routes HTTP traffic to healthy instances. Health checks every 30s.</div>
    </div>
    <div class="card">
      <div class="ct" style="background:linear-gradient(90deg,var(--p),var(--o))"></div>
      <div class="ci">&#x1F504;</div>
      <div class="cn">Auto Scaling Group</div>
      <div class="cr" style="color:var(--p)">Elasticity</div>
      <div class="cd">Scales EC2 count 2 to 5 based on CPU utilization across 2 AZs.</div>
    </div>
    <div class="card">
      <div class="ct" style="background:linear-gradient(90deg,var(--o),var(--r))"></div>
      <div class="ci">&#x1F310;</div>
      <div class="cn">Amazon VPC</div>
      <div class="cr" style="color:var(--o)">Networking</div>
      <div class="cd">Custom VPC, 2 public subnets in different AZs, IGW, route tables.</div>
    </div>
    <div class="card">
      <div class="ct" style="background:linear-gradient(90deg,var(--r),var(--g))"></div>
      <div class="ci">&#x1F4CA;</div>
      <div class="cn">CloudWatch</div>
      <div class="cr" style="color:var(--r)">Monitoring</div>
      <div class="cd">CPU alarms trigger scale-out and scale-in. Logs all scaling events.</div>
    </div>
    <div class="card">
      <div class="ct" style="background:linear-gradient(90deg,var(--g),var(--p))"></div>
      <div class="ci">&#x1F537;</div>
      <div class="cn">Nginx</div>
      <div class="cr" style="color:var(--g)">Web Server</div>
      <div class="cd">Installed via yum, enabled via systemd. Serves on port 80.</div>
    </div>
  </div>
</section>

<section class="sec">
  <div class="tag" style="color:var(--g)">// ASG Config</div>
  <h2>Scaling Configuration</h2>
  <div class="stat-row">
    <div class="stat"><div class="sn" style="color:var(--g)">2</div><div class="sl">Min Instances</div></div>
    <div class="stat"><div class="sn" style="color:var(--b)">2</div><div class="sl">Desired</div></div>
    <div class="stat"><div class="sn" style="color:var(--p)">5</div><div class="sl">Max Instances</div></div>
    <div class="stat"><div class="sn" style="color:var(--o)">2</div><div class="sl">Avail. Zones</div></div>
  </div>
  <div class="pcard">
    <div class="pt">&#x1F4C8; Target Tracking Scaling Policy</div>
    <div class="pr"><span class="pk">Policy Type</span><span class="pv">Target Tracking</span></div>
    <div class="pr"><span class="pk">Metric</span><span class="pv">CPUUtilization</span></div>
    <div class="pr"><span class="pk">Scale-Out Trigger</span><span class="pv">CPU &gt; 70%</span></div>
    <div class="pr"><span class="pk">Scale-In Trigger</span><span class="pv">CPU &lt; 30%</span></div>
    <div class="pr"><span class="pk">Cooldown Period</span><span class="pv">300 seconds</span></div>
    <div class="pr"><span class="pk">Health Check</span><span class="pv">ELB -- port 80</span></div>
  </div>
</section>

<section class="sec">
  <div class="tag" style="color:var(--r)">// HA Strategy</div>
  <h2>High Availability Design</h2>
  <div class="ha">
    <div class="hc">
      <div class="hn" style="color:var(--g)">01</div>
      <div class="hi">&#x1F3D7;&#xFE0F;</div>
      <div class="ht">Multi-AZ Redundancy</div>
      <div class="hd">Instances spread across 2 AZs. AZ failure routes traffic to healthy AZ automatically.</div>
    </div>
    <div class="hc">
      <div class="hn" style="color:var(--b)">02</div>
      <div class="hi">&#x2696;&#xFE0F;</div>
      <div class="ht">Load Distribution</div>
      <div class="hd">ALB evenly distributes requests. Unhealthy instances removed from rotation in 30s.</div>
    </div>
    <div class="hc">
      <div class="hn" style="color:var(--p)">03</div>
      <div class="hi">&#x1F4C8;</div>
      <div class="ht">Elastic Scaling</div>
      <div class="hd">CloudWatch CPU alarms auto-provision instances on spikes and remove them when idle.</div>
    </div>
    <div class="hc">
      <div class="hn" style="color:var(--o)">04</div>
      <div class="hi">&#x1F504;</div>
      <div class="ht">Self-Healing</div>
      <div class="hd">ASG replaces failed instances automatically, maintaining desired capacity at all times.</div>
    </div>
  </div>
</section>

<footer>
  &#x2601;&#xFE0F; Cloud Engineering Internship &nbsp;|&nbsp; Project Set-6 &nbsp;|&nbsp; Instance: <span>{instance_id}</span> &nbsp;|&nbsp; AZ: <span>{az}</span>
</footer>

</div>
</body>
</html>""".format(instance_id=instance_id, az=az, region=region, private_ip=private_ip)

with open('/usr/share/nginx/html/index.html', 'w', encoding='utf-8') as f:
    f.write(html)
print("HTML written successfully")
PYEOF

chmod 644 /usr/share/nginx/html/index.html
systemctl restart nginx
echo "$(date): Deployed. Instance=$INSTANCE_ID AZ=$AZ" >> /var/log/deploy.log
