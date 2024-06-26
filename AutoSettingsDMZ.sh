#!/bin/bash

output="iptables.log"
DMZIpAddr="192.168.254.3"
RouterIPAddr="192.168.254.1"
telnetOpenURL="http://${RouterIPAddr}/usr=CMCCAdmin&psw=aDm8H%25MdA&cmd=1&telnet.gch"
telnetCloseURL="http://${RouterIPAddr}/usr=CMCCAdmin&psw=aDm8H%25MdA&cmd=0&telnet.gch"
getPublicIPAddrURL="http://ipv4.rehi.org/ip"
vHostAddr0="192.168.254.2"

uName="CMCCAdmin"
passwd="aDm8H%MdA"


Port_HTTP=1080
Port_HTTPS=1443


echo "This Programmer will Setting route iptables for HX3-4sProLite Router "
IPAddress=$(cat ip.txt)
echo "从文件读取的IP地址:"$'\t'${IPAddress} >> $output
pIPAddress=$(curl -s -A ""  ${getPublicIPAddrURL})
echo "从网络获取公网IP地址:"$'\t'${pIPAddress} >> $output


if [ "$IPAddress" = "$pIPAddress" ]; then
  echo "两次ip地址一致，不需要进行一下步骤！程序退出！" >> $output
  exit 0
else
  echo "IP地址不一致，设置路由器..." >> $output
  setTelnet=$(curl -s -A ""  ${telnetOpenURL})
  echo "设置Telnet结果:"${setTelnet} >> $output

                echo "设置Telnet 成功！" >> $output
                echo "准备Telnet 连接....." >> $output
/usr/bin/expect -d <<-EOF
                spawn telnet ${RouterIPAddr}
                expect  "Login:*"
                send "$uName\r"
                expect  "Password:*"
                send "$passwd\r"
                expect  "*$"
                send "su\r"
                expect  "Password:"
                send "$passwd\r"
				
                expect "*#"
                send "iptables -t nat -A dmzmapp -i ppp0 -d ${pIPAddress} -j DNAT --to-destination ${DMZIpAddr} \r"
                expect "*#"
                send "iptables -t filter -A dmzmapp -i ppp0  -d ${DMZIpAddr}  -j ACCEPT\r"




				expect "*#"
				send  "iptables -A ipfilter -p tcp -s ${vHostAddr0} --sport ${Port_HTTP}-j DROP\r"
				expect "*#"
				send  "iptables -t nat -D portmapp -p TCP -i ppp0 -d ${pIPAddress}  --dport ${Port_HTTP}:${Port_HTTP} -j DNAT --to-destination ${vHostAddr0}:${Port_HTTP}-${Port_HTTP}\r"
				expect "*#"
				send  "iptables -t nat -D portmapp -p UDP -i ppp0 -d ${pIPAddress}  --dport ${Port_HTTP}:${Port_HTTP} -j DNAT --to-destination ${vHostAddr0}:${Port_HTTP}-${Port_HTTP}\r"
				expect "*#"
				send  "iptables -t filter -D portmapp -p TCP -i ppp0  -d ${vHostAddr0} --dport ${Port_HTTP}:${Port_HTTP} -j ACCEPT\r"
				expect "*#"
				send  "iptables -t filter -D portmapp -p UDP -i ppp0  -d ${vHostAddr0} --dport ${Port_HTTP}:${Port_HTTP} -j ACCEPT\r"
				expect "*#"
				send  "iptables -t nat -A portmapp -p TCP -i ppp0 -d ${pIPAddress}  --dport ${Port_HTTP}:${Port_HTTP} -j DNAT --to-destination ${vHostAddr0}:${Port_HTTP}-${Port_HTTP}\r"
				expect "*#"
				send  "iptables -t nat -A portmapp -p UDP -i ppp0 -d ${pIPAddress}  --dport ${Port_HTTP}:${Port_HTTP} -j DNAT --to-destination ${vHostAddr0}:${Port_HTTP}-${Port_HTTP}\r"
				expect "*#"
				send  "iptables -t filter -A portmapp -p TCP -i ppp0  -d ${vHostAddr0} --dport ${Port_HTTP}:${Port_HTTP} -j ACCEPT\r"
				expect "*#"
				send  "iptables -t filter -A portmapp -p UDP -i ppp0  -d ${vHostAddr0} --dport ${Port_HTTP}:${Port_HTTP} -j ACCEPT\r"


				expect "*#"
				send  "iptables -A ipfilter -p tcp -s ${vHostAddr0} --sport ${Port_HTTPS}-j DROP\r"
				expect "*#"
				send  "iptables -t nat -D portmapp -p TCP -i ppp0 -d ${pIPAddress}  --dport ${Port_HTTPS}:${Port_HTTPS} -j DNAT --to-destination ${vHostAddr0}:${Port_HTTPS}-${Port_HTTPS}\r"
				expect "*#"
				send  "iptables -t nat -D portmapp -p UDP -i ppp0 -d ${pIPAddress}  --dport ${Port_HTTPS}:${Port_HTTPS} -j DNAT --to-destination ${vHostAddr0}:${Port_HTTPS}-${Port_HTTPS}\r"
				expect "*#"
				send  "iptables -t filter -D portmapp -p TCP -i ppp0  -d ${vHostAddr0} --dport ${Port_HTTPS}:${Port_HTTPS} -j ACCEPT\r"
				expect "*#"
				send  "iptables -t filter -D portmapp -p UDP -i ppp0  -d ${vHostAddr0} --dport ${Port_HTTPS}:${Port_HTTPS} -j ACCEPT\r"
				expect "*#"
				send  "iptables -t nat -A portmapp -p TCP -i ppp0 -d ${pIPAddress}  --dport ${Port_HTTPS}:${Port_HTTPS} -j DNAT --to-destination ${vHostAddr0}:${Port_HTTPS}-${Port_HTTPS}\r"
				expect "*#"
				send  "iptables -t nat -A portmapp -p UDP -i ppp0 -d ${pIPAddress}  --dport ${Port_HTTPS}:${Port_HTTPS} -j DNAT --to-destination ${vHostAddr0}:${Port_HTTPS}-${Port_HTTPS}\r"
				expect "*#"
				send  "iptables -t filter -A portmapp -p TCP -i ppp0  -d ${vHostAddr0} --dport ${Port_HTTPS}:${Port_HTTPS} -j ACCEPT\r"
				expect "*#"
				send  "iptables -t filter -A portmapp -p UDP -i ppp0  -d ${vHostAddr0} --dport ${Port_HTTPS}:${Port_HTTPS} -j ACCEPT\r"

                expect EOF
EOF
                echo "login Success!"  >> $output
                if [ -n "$pIPAddress" ]; then
                        echo "$pIPAddress" >ip.txt
                        echo "写入IP地址完成。。。" >> $output
                fi
        fi

echo "${pIPAddress}" >> $output
setTelnet=$(curl -s -A ""  ${telnetCloseURL})
