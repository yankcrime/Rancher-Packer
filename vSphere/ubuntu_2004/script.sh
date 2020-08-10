export DEBIAN_FRONTEND=noninteractive

# Apply updates and cleanup Apt cache
#
apt-get update ; apt-get -y dist-upgrade
apt-get install -y python3-pip

# Install cloud-init datasource for VMware GuestInfo
#
curl -sSL https://raw.githubusercontent.com/vmware/cloud-init-vmware-guestinfo/master/install.sh | sh -

apt-get -y autoremove
apt-get -y clean

# Disable swap - generally recommended for K8s, but otherwise enable it for other workloads
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Reset the machine-id value. This has known to cause issues with DHCP
#
truncate -s 0 /etc/machine-id
rm /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id

# Reset any existing cloud-init state
#
cloud-init clean -s -l