#!/bin/bash

# 当前配置端口
current_v2ray_port_path=./current_v2ray_port.txt
# rinetd 配置地址
rinetd_conf_path=./rinetd.conf
# 订阅配置地址
clash_2_vmess_conf_path=/mnt/soft/openresty/nginx/html/vmess2clash.yml
vmess_subscribe_conf_path=/mnt/soft/openresty/nginx/html/sv2_vmess.txt
# vmess 订阅地址配置
vmess_subscribe_name=japan-vmess
vmess_host=xxxxx
vmess_id=xxxx
vmess_proxy_path=/xxx


# 获取当前维护端口
current_v2ray_port=$(cat $current_v2ray_port_path)
echo "当前维护端口: $current_v2ray_port"

# 将当前维护端口+1创建更新端口
((upgrade_port=current_v2ray_port+1))
echo "替换端口为: $upgrade_port"

# rinetd 配置端口调整
sed -i "s/$current_v2ray_port/$upgrade_port/g" $rinetd_conf_path

# rinetd 转发调整
rinetd -c $rinetd_conf_path

# 调整clash订阅链接
sed -i "s/$current_v2ray_port/$upgrade_port/g" $clash_2_vmess_conf_path

# 调整Vmess订阅链接
subscribe_txt="{\"ps\":\"$vmess_subscribe_name\",\"add\":\"$vmess_host\",\"port\":\"$upgrade_port\",\"id\":\"$vmess_id\",\"aid\":\"0\",\"scy\":\"none\",\"net\":\"ws\",\"type\":\"\",\"host\":\"\",\"path\":\"$vmess_proxy_path\",\"tls\":\"tls\",\"allowInsecure\":false,\"v\":\"2\",\"protocol\":\"vmess\"}"
echo "vmess订阅文本: $subscribe_txt"
echo ""
subscribe_txt_base64=$(echo -n "$subscribe_txt" | base64)
final_subscribe_txt_base64=$(echo -n "vmess://$subscribe_txt_base64" | tr -d '\n' | base64)
echo "vmess最终base64: $final_subscribe_txt_base64"
echo -n "$final_subscribe_txt_base64" | tr -d '\n' > $vmess_subscribe_conf_path

# 调整当前端口维护地址
sed -i "s/$current_v2ray_port/$upgrade_port/g" $current_v2ray_port_path