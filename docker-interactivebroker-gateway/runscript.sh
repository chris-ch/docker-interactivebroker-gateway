#!/bin/bash

function create_config_jts {
# Environemnt variables
# JTS_DEBUG=false
# JTS_TIMEZONE=America/Chicago
# JTS_TRADING_MODE=p
# JTS_REMOTE_HOST_ORDER_ROUTING=cdc1.ibllc.com
# JTS_REGION=us
# JTS_PEER=zdc1.ibllc.com:4001

    cat <<EOF > $1

[IBGateway]
WriteDebug=${JTS_DEBUG:-false}
TrustedIPs=127.0.0.1
RemoteHostOrderRouting=${JTS_REMOTE_HOST_ORDER_ROUTING:-ndc1.ibllc.com}
MainWindow.Height=550
RemotePortOrderRouting=${IB_PORT_NUMBER}
LocalServerPort=4000
ApiOnly=true
MainWindow.Width=700

[Logon]
useRemoteSettings=false
TimeZone=${JTS_TIMEZONE:-America/Chicago}
tradingMode=${IB_TRADING_MODE}
colorPalletName=dark
Steps=10
Locale=en
os_titlebar=false
UseSSL=true
SupportsSSL=ndc1.ibllc.com:4000,true,20221008,false;zdc1.ibllc.com:4000,true,20221008,false
screenHeight=768
s3store=true
ibkrBranding=pro

[Communication]
2ndFactor=${IB_TOKEEN_2FA},5.2a;
Peer=${JTS_PEER:-zdc1.ibllc.com:4001}
Region=${JTS_REGION:-us}

EOF

}


create_config_jts /root/Jts/jts.ini

export IB_USERNAME=$(cat /run/secrets/ib_username)
export IB_PASSWORD=$(cat /run/secrets/ib_password)

xvfb-daemon-run /root/Jts/ibgateway/1012/ibgateway

# Tail latest in log dir
#sleep 1
#tail -f $(find $LOG_PATH -maxdepth 1 -type f -printf "%T@ %p\n" | sort -n | tail -n 1 | cut -d' ' -f 2-) &

echo 
echo ---- JTS config ----
cat /root/Jts/jts.ini
echo 

# Give enough time for a connection before trying to expose on 0.0.0.0:4003
sleep 30
echo "Forking :::${IB_PORT_NUMBER} onto 0.0.0.0:4003"
socat TCP-LISTEN:4003,fork TCP:127.0.0.1:${IB_PORT_NUMBER}
