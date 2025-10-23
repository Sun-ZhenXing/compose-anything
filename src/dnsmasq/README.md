# DNSMasq

[English](./README.md) | [中文](./README.zh.md)

This service deploys DNSMasq, a lightweight DNS forwarder and DHCP server.

## Services

- `dnsmasq`: The DNSMasq service.

## Environment Variables

| Variable Name             | Description                                          | Default Value |
| ------------------------- | ---------------------------------------------------- | ------------- |
| DNSMASQ_VERSION           | DNSMasq image version                                | `2.91`        |
| DNSMASQ_DNS_PORT_OVERRIDE | Host port mapping (maps to DNS port 53 in container) | 53            |
| TZ                        | Timezone setting                                     | `UTC`         |

Please modify the `.env` file as needed for your use case.

## Configuration

### Configure LAN DNS Resolution

Lines starting with `address` in the `dnsmasq.conf` file will be parsed as LAN DNS resolution rules.

```conf
address=/example.com/192.168.1.123
```

Router Configuration:

- Set the gateway to the router IP
- Bind the server IP address and MAC address, or assign a static IP address
- Configure the DHCP server to use the server IP address as the DNS server

## Volumes

- `dnsmasq.conf`: Configuration file for DNSMasq (mounted to `/etc/dnsmasq.conf`).

## Ports

- `53/tcp`: DNS service (TCP)
- `53/udp`: DNS service (UDP)

## Security Notes

- This service requires `NET_ADMIN` and `NET_BIND_SERVICE` capabilities to bind to privileged ports.
- Ensure proper firewall rules are in place to restrict access to the DNS service.
