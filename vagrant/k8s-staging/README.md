# 🧪 Kubernetes Staging Cluster with Vagrant + VMware

This Vagrant configuration sets up a **three-node Kubernetes staging cluster** using Ubuntu 24.04 virtual machines, powered by the `vmware_desktop` provider.

Each VM is provisioned with a static IP, dedicated disk, and custom compute resources — perfect for testing multi-node environments like Kubernetes.

---

## 🔧 Requirements

Before you get started, make sure you have the following installed:

- [Vagrant](https://www.vagrantup.com/)
- [VMware Fusion / Workstation Pro](https://www.vmware.com/products/workstation-pro.html)
- [vagrant-vmware-desktop plugin](https://developer.hashicorp.com/vagrant/docs/providers/vmware/desktop)

---

## 📦 Box Used

- **Base Box:** `bento/ubuntu-24.04`

This box will be automatically downloaded the first time you run `vagrant up`.

---

## 🖥️ VM Configuration

Three VMs will be created:

| Node Name        | IP Address     | Memory | CPUs | Disk  |
|------------------|----------------|--------|------|-------|
| k8s-staging-1    | 192.168.6.2    | 4 GB   | 2    | 96 GB |
| k8s-staging-2    | 192.168.6.3    | 4 GB   | 2    | 96 GB |
| k8s-staging-3    | 192.168.6.4    | 4 GB   | 2    | 96 GB |

- Hostnames are automatically set per node.
- Each VM is on a **private network** with static IP configuration.
- GUI is disabled (headless mode).
- `linked_clone` is disabled for full provisioning of virtual disks.

---

## 🚀 Usage

### Start the cluster

```bash
vagrant up
```

### SSH into a node

```bash
vagrant ssh k8s-staging-1
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

## ⚠️ Known Issues & Troubleshooting

### 1. 💡 **VMware Network Setup Required**

If the private network does not work as expected or Vagrant throws an error regarding missing networks, you may need to **manually add a network in VMware** before running `vagrant up`.

Refer to this issue for a step-by-step workaround:  
👉 https://github.com/clong/DetectionLab/issues/602

```bash
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cfgcli vnetcfgadd VNET_2_DHCP no
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cfgcli vnetcfgadd VNET_2_HOSTONLY_SUBNET 192.168.6.0
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cfgcli vnetcfgadd VNET_2_HOSTONLY_NETMASK 255.255.255.224
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cfgcli vnetcfgadd VNET_2_VIRTUAL_ADAPTER yes
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --configure
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --stop
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --start
```

---

### 2. 🛠️ **Manually Start the VMware Utility**

In some environments, the **VMware Utility service** (used by Vagrant to interact with VMware) may not be running automatically.

If you get errors like "Unable to connect to the VMware utility", follow the official documentation to start the utility manually:

👉 https://developer.hashicorp.com/vagrant/docs/providers/vmware/vagrant-vmware-utility

> Example for macOS:
```bash
sudo /Library/Application\ Support/HashiCorp/Vagrant-vmware-utility/vagrant-vmware-utility
```
