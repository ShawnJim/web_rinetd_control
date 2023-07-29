# web_rinetd_control

简单的web控制rinetd转发端口，用于复活被墙端口

## 文件说明

### [auto_refresh_v2ray_porter.sh](auto_refresh_v2ray_porter.sh)

刷新脚本, 需要配置

### [current_v2ray_port.txt](current_v2ray_port.txt)

配置当前 `rinetd` 的代理端口，用于刷新 `rinetd` 管理的配置文件端口.

### [rinetd.conf](rinetd.conf)

rinetd 配置文件

## 部署

安装依赖

- python3
- [rinetd](https://github.com/samhocevar/rinetd)
- python-flask
- openresty

```shell
git clone https://github.com/ShawnJim/web_rinetd_control.git
pip install -r requirements.txt
python3 app.py
```