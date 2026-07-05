# ==================================================
# PROJECT VKJ - Virtual Network Security
# MikroTik CHR Configuration
# ==================================================

# =====================
# IDENTITY
# =====================

/system identity
set name=VKJ-Router

# =====================
# IP ADDRESS
# =====================

/ip address
add address=7.7.7.1/24 interface=ether2 comment="DMZ Gateway"
add address=192.168.56.1/24 interface=ether3 comment="LAN Gateway"

# =====================
# DHCP CLIENT (INTERNET)
# =====================

/ip dhcp-client
add interface=ether1 disabled=no comment="Internet DHCP"

# =====================
# DNS
# =====================

/ip dns
set allow-remote-requests=yes servers=8.8.8.8,1.1.1.1

# =====================
# NAT
# =====================

/ip firewall nat

# Internet Access
add chain=srcnat \
    out-interface=ether1 \
    action=masquerade \
    comment="MASQUERADE INTERNET"

# HTTP Port Forwarding
add chain=dstnat \
    protocol=tcp \
    dst-port=80 \
    action=dst-nat \
    to-addresses=7.7.7.2 \
    to-ports=80 \
    comment="HTTP TO DMZ"

# HTTPS Port Forwarding (opsional)
add chain=dstnat \
    protocol=tcp \
    dst-port=443 \
    action=dst-nat \
    to-addresses=7.7.7.2 \
    to-ports=443 \
    comment="HTTPS TO DMZ"

# =====================
# FIREWALL FILTER
# =====================

/ip firewall filter

# Allow Established & Related
add chain=forward \
    connection-state=established,related \
    action=accept \
    comment="ALLOW ESTABLISHED"

# Drop Invalid
add chain=forward \
    connection-state=invalid \
    action=drop \
    comment="DROP INVALID"

# Allow Ping to Router
add chain=input \
    protocol=icmp \
    action=accept \
    comment="ALLOW PING ROUTER"

# Allow HTTP from External to DMZ
add chain=forward \
    protocol=tcp \
    in-interface=ether1 \
    dst-address=7.7.7.2 \
    dst-port=80 \
    action=accept \
    comment="ALLOW HTTP TO DMZ"

# Allow HTTPS from External to DMZ
add chain=forward \
    protocol=tcp \
    in-interface=ether1 \
    dst-address=7.7.7.2 \
    dst-port=443 \
    action=accept \
    comment="ALLOW HTTPS TO DMZ"

# Allow DMZ to Internet
add chain=forward \
    src-address=7.7.7.2 \
    out-interface=ether1 \
    action=accept \
    comment="DMZ TO INTERNET"

# Allow DMZ to Database
add chain=forward \
    protocol=tcp \
    src-address=7.7.7.2 \
    dst-address=192.168.56.10 \
    dst-port=3306 \
    action=accept \
    comment="DMZ TO MYSQL"

# Block External to MySQL
add chain=forward \
    protocol=tcp \
    in-interface=ether1 \
    dst-port=3306 \
    action=drop \
    comment="BLOCK MYSQL EXTERNAL"

# Block External to LAN
add chain=forward \
    in-interface=ether1 \
    dst-address=192.168.56.0/24 \
    action=drop \
    comment="BLOCK EXTERNAL TO LAN"

# Default DROP
add chain=forward \
    action=drop \
    comment="DROP ALL"

# =====================
# SERVICES
# =====================

/ip service
set telnet disabled=yes
set ftp disabled=yes
set www disabled=yes
set api disabled=yes
set api-ssl disabled=yes

# SSH hanya dari LAN
set ssh address=192.168.56.0/24

# =====================
# NOTES
# =====================
# External Network : DHCP (10.0.2.x)
# DMZ Network      : 7.7.7.0/24
# Database LAN     : 192.168.56.0/24
#
# DMZ Server       : 7.7.7.2
# Database Server  : 192.168.56.10
#
# Docker:
# APP1 -> 8081
# APP2 -> 8082
#
# Reverse Proxy:
# /app1
# /app2
#
# Suricata IDS:
# HTTP ACCESS DETECTED
# MYSQL ACCESS DETECTED
# PING DETECTED
#
# ==================================================