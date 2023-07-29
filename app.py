#!/bin/env python
# _*_coding:utf-8_*_
import os
from flask import *

app = Flask(__name__)

users = {
    "v2rayadmin": "v2ray@123456",
}


def login_required(view_func):
    """
    登录验证装饰器
    :param view_func:
    :return:
    """
    def wrapper(*args, **kwargs):
        if "username" not in request.cookies or "password" not in request.cookies:
            return redirect(url_for("login"))

        username = request.cookies.get("username")
        password = request.cookies.get("password")

        if not validate_user(username, password):
            return redirect(url_for("login"))

        return view_func(*args, **kwargs)

    wrapper.__name__ = view_func.__name__
    return wrapper


def validate_user(username, password):
    """
    用户验证函数
    :param username: 用户名
    :param password: 密码
    :return:
    """
    return username in users and users[username] == password


@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        username = request.form.get("username")
        password = request.form.get("password")

        if validate_user(username, password):
            # 登录成功，设置 cookie
            resp = redirect(url_for("index"))
            resp.set_cookie("username", username)
            resp.set_cookie("password", password)
            return resp
        else:
            return "登录失败，用户名或密码错误"

    return render_template("login.html")


@app.route("/logout")
def logout():
    # 清除 cookie 并重定向到登录页面
    resp = redirect(url_for("login"))
    resp.delete_cookie("username")
    resp.delete_cookie("password")
    return resp


@app.route('/', methods=['GET'])
@login_required
def index():
    out1 = os.popen('cat ./current_v2ray_port.txt').read()
    out2 = os.popen('firewall-cmd --list-all').read()
    return render_template('index.html', rinetd=out1, firewall=out2)


@app.route('/refresh', methods=['POST'])
def refresh():
    # 执行 auto_refresh_v2ray_porter.sh
    output = os.popen('./auto_refresh_v2ray_porter.sh').read()
    print(output)
    return_code = os.popen('echo $?').read().strip()
    # 判断命令是否执行成功
    if return_code == '0':
        return 'success'
    else:
        return 'error'


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, threaded=True)
