# 🧪 Kubernetes Staging Cluster with Vagrant + VMware

This Vagrant configuration sets up a **three-node Kubernetes staging cluster** using Ubuntu 24.04 virtual machines, powered by the `vmware_desktop` provider.

Cloud-init is used to configure provision the VMs. The intention is to not rely on Vagrant's in built mechanisms and to focus on building a realistic representation of my physical infastructure. There is effort to disable some of vagrant's mechanisms as to try and more closely imitate the production environment.

---

## Requirements

- [Vagrant](https://www.vagrantup.com/)
- [VMware Fusion / Workstation Pro](https://www.vmware.com/products/workstation-pro.html)
- [vagrant-vmware-desktop plugin](https://developer.hashicorp.com/vagrant/docs/providers/vmware/desktop)

---

## Box Used

- **Base Box:** `gadgie/ubuntu24.04`

This box will be automatically downloaded the first time you run `vagrant up`. This box is based of bento/ubuntu-24.04, it simply has cloud-init re-enabled.

---

## Configuration

Configuration is found in config.rb with basic input validation.

---

## Usage

### Start the cluster

```bash
vagrant up
```

### SSH into a node

```bash
ssh -l gadge -i <key path> <node ip>
```

### Shut down the cluster

```bash
vagrant halt
```

### Destroy the cluster

```bash
vagrant destroy -f
```

---

## Notes

### 1. **VMware Network Setup Required**

If the private network does not work as expected or Vagrant throws an error regarding missing networks, you may need to **manually add a network in VMware** before running `vagrant up`.

Refer to this issue for a step-by-step workaround:  
[DetectionLab Issue #602](https://github.com/clong/DetectionLab/issues/602)

```bash
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cfgcli vnetcfgadd VNET_3_DHCP no
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cfgcli vnetcfgadd VNET_3_NAT yes
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cfgcli vnetcfgadd VNET_3_HOSTONLY_SUBNET 192.168.6.0
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cfgcli vnetcfgadd VNET_3_HOSTONLY_NETMASK 255.255.255.224
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cfgcli vnetcfgadd VNET_3_VIRTUAL_ADAPTER yes
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --configure
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --stop
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --start
```

---

### 2. Network Address Reservation

VMware automatically reserves specific addresses in a configured subnet:

- **First Address**: Reserved for the host itself (192.168.6.1)
- **Second Address**: Reserved for the NAT gateway (192.168.6.2)

This means your VMs should use IP addresses starting from 192.168.6.3 and onwards. Be sure to account for these reservations when planning your network configuration.

---

### 3. **Manually Start the VMware Utility**

In some environments, the **VMware Utility service** (used by Vagrant to interact with VMware) may not be running automatically.

If you get errors like "Unable to connect to the VMware utility", follow the official documentation to start the utility manually:

[VMware Utility Documentation](https://developer.hashicorp.com/vagrant/docs/providers/vmware/vagrant-vmware-utility)

> Example for macOS:

```bash
sudo launchctl load -w /Library/LaunchDaemons/com.vagrant.vagrant-vmware-utility.plist
```

### 4. **Generating the `cloud-init.iso`**

To provision the VMs using **Cloud-init**, a `cloud-init.iso` is created using a simple Bash script. This ISO includes both the `user-data` and `meta-data` files, which are used by Cloud-init during the VM’s first boot to configure system settings, users, packages, and more.

```bash
./build-iso.sh
```

This can also be achieved at runtime by setting BUILD_ISO = true in config.rb.

### 5. **macOS Networking Caveat (local network access required)

If you’re using macOS, you might encounter issues where VSCode or your terminal cannot SSH into the VM or access the local Vagrant network. This is due to macOS security settings that restrict local network access for apps.

### Fix

1. Open **System Settings**.
2. Navigate to **Privacy & Security → Local Network**.
3. Enable network access for:
    - **Visual Studio Code**
    - Your preferred Terminal app (e.g., **Terminal**, **iTerm2**)

Without this, tools like vagrant ssh may hang or fail due to blocked network permissions.

### 6. **Refreshing SSH Keys with `refresh-keys.sh`**

The `refresh-keys.sh` script provides a convenient way to manage SSH known hosts when recreating VMs with the same IP addresses.

```bash
./refresh-keys.sh <ip_address>
```

This script:

- Removes the specified IP address from your `~/.ssh/known_hosts` file
- Clears any cached SSH keys for that host
- Prevents "Host key verification failed" errors when connecting to rebuilt VMs
- If an IP Address is not provided, it simply clears and scans the three IP's assigned to the nodes

Run this script after destroying and recreating the cluster to ensure smooth SSH connections to the kubernetes nodes.
