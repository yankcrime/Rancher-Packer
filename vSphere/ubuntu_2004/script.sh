# Reset the machine-id value. This has known to cause issues with DHCP
#
echo -n > /etc/machine-id

# Fix netplan for DHCP
#
cat <<EOF > /etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    ens192:
      dhcp4: yes
      dhcp-identifier: mac
EOF

# Remove 127.0.1.1 line from /etc/hosts
#
sed -i '/127.0.1.1/d' /etc/hosts

# Reset any existing cloud-init state
#
cloud-init clean -s -l
