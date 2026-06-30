#!/bin/bash

UUID_FILE="/etc/xray/uuid"

if [ ! -f "$UUID_FILE" ]; then
    uuidgen > "$UUID_FILE"
fi

UUID=$(cat "$UUID_FILE")

PORT=${PORT:-10000}
WS_PATH=${WS_PATH:-/vmess}

cat > /etc/xray/config.json <<EOF
{
  "log": {
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "port": $PORT,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "$UUID",
            "alterId": 0
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "$WS_PATH"
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
EOF

echo "================================="
echo "VMESS DETAILS"
echo "UUID : $UUID"
echo "PORT : $PORT"
echo "PATH : $WS_PATH"
echo "HOST : YOUR_RENDER_DOMAIN"
echo "TLS  : ENABLED BY RENDER"
echo "================================="

exec /usr/local/bin/xray run -config /etc/xray/config.json
