# 🛠️ Ubuntu 24.04 Vagrant Box Builder (VMware Desktop)

This packer file contains a simple [Packer](https://www.packer.io/) template to create a **Vagrant box** based on **Ubuntu 24.04** (`bento/ubuntu-24.04`) using the `vmware_desktop` provider. Fundamentally all that is provisioned is a command to re-enable cloud-init so the image can be used as a "cloud image" for southbound vagrant processes.

---

## 🚀 Getting Started

### ✅ Prerequisites

Install the plugin if you haven't:

```bash
packer plugins install github.com/hashicorp/vagrant
```

---

## 🏗️ Build the Box

To build the Vagrant box:

```bash
packer init .
packer build .
```

This will produce a `.box` file in output-noble.
