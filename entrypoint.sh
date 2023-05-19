#!/bin/bash
apt-get update && apt-get install -y wget unzip
nx=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 4)
xpid=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 8)
# [ -n "${ver}" ] && wget -O $nx.zip https://github.com/XTLS/Xray-core/releases/download/v${ver}/Xray-linux-64.zip
# [ ! -s $nx.zip ] && wget -O $nx.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip

# "flow":"xtls-rprx-direct" "flow":"xtls-rprx-vision"
wget -O $nx.zip https://github.com/XTLS/Xray-core/releases/download/v1.8.1/Xray-linux-64.zip

unzip $nx.zip xray && rm -f $nx.zip
wget -N https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat
wget -N https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat
chmod a+x xray && mv xray $xpid
sed -i "s/uuid/$uuid/g" ./config.json
sed -i "s/uuid/$uuid/g" /etc/nginx/nginx.conf
WWW=4
[ -n "${WWW}" ] && rm -rf /usr/share/nginx/* && wget -c -P /usr/share/nginx "https://gitlab.com/rwkgyg/doprax-xray/-/raw/main/3w/html${WWW}.zip" && unzip -o "/usr/share/nginx/html${WWW}.zip" -d /usr/share/nginx/html
cat config.json | base64 > config
rm -f config.json

# argo与加密方案出自fscarmen
#wget -N https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
#chmod +x cloudflared-linux-amd64
#./cloudflared-linux-amd64 tunnel --url http://localhost:8080 --no-autoupdate > argo.log 2>&1 &
#sleep 10
#ARGO=$(cat argo.log | grep -oE "https://.*[a-z]+cloudflare.com" | sed "s#https://##")

xver=`./$xpid version | sed -n 1p | awk '{print $2}'`
UA_Browser="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36"
v4=$(curl -s4m6 ip.sb -k)
v4l=`curl -sm6 --user-agent "${UA_Browser}" http://ip-api.com/json/$v4?lang=zh-CN -k | cut -f2 -d"," | cut -f4 -d '"'`

cat > /usr/share/nginx/html/qwert.html<<-EOF
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>ZZZ-ZZZ</title>
    <style type="text/css">
        body {
            font-family: Geneva, Arial, Helvetica, san-serif;
        }
        div {
            margin: 0 auto;
            text-align: left;
            white-space: pre-wrap;
            word-break: break-all;
            max-width: 80%;
            margin-bottom: 10px;
        }
    </style>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<div>
****************************************************************
当前网络的IP $v4
<script type="text/javascript">
document.write(Date(Date.now()).toString())
</script>
vl----------------------------------------------------------------vl
</div>
<div>
443、2053、2083、2087、2096、8443
80、8080、8880、2052、2082、2086、2095
$uuid
</div>
</body>
</html>
EOF

nginx
base64 -d config > config.json; ./$xpid -config=config.json
