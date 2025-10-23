# 配置局域网 DNS 解析

在 `dnsmasq.conf` 文件中以 `address` 开头的行会被解析为局域网 DNS 解析。

```conf
address=/example.com/192.168.1.123
```

在路由器中设置：

- 网关为路由器 IP
- 服务器 IP 地址和 MAC 地址绑定，或给定固定 IP 地址
- DHCP 服务器设置 DNS 服务器为服务器 IP 地址
