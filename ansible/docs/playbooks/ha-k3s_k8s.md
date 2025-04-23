# High-Availability Kubernetes Deployment Playbooks

## ha-k3s.yml

This playbook installs a highly available Kubernetes cluster using [K3s](https://k3s.io/), a lightweight Kubernetes distribution.

### ha-k3s Features

- Uses embedded etcd for high availability
- Lightweight installation suitable for edge, IoT, and resource-constrained environments
- Simpler deployment process with fewer dependencies
- Includes built-in components like Traefik Ingress Controller

### When to use ha-k3s

- When you need a production-grade Kubernetes cluster with minimal resource requirements
- For edge computing or IoT scenarios
- When you prefer simplified management with fewer moving parts

## ha-k8s.yml

This playbook installs a highly available "vanilla" Kubernetes cluster using [kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/), the official Kubernetes bootstrapping tool.

### ha-k8s Features

- Standard Kubernetes deployment with external etcd cluster
- Full flexibility and control over all Kubernetes components
- Suitable for enterprise environments with specific compliance needs

### When to use ha-k8s

- When you need complete control over all Kubernetes components
- For enterprise deployments requiring specific configurations
- When compatibility with upstream Kubernetes is critical
- For scenarios requiring advanced customization options

## High Availability Architecture

Both playbooks implement a robust high-availability architecture for the Kubernetes control plane using:

### HAProxy Load Balancing

- Installs and configures HAProxy on dedicated load balancer nodes
- Distributes API server traffic across all control plane nodes
- Health checks ensure traffic is only sent to operational control plane nodes
- Provides a single endpoint for all Kubernetes API communications

### Keepalived for Failover

- Implements a floating Virtual IP (VIP) that always points to an active load balancer
- Automatic failover if the primary load balancer becomes unavailable
- Ensures continuous access to the Kubernetes API even during node failures
- Uses VRRP (Virtual Router Redundancy Protocol) for reliable state management

This architecture ensures there is no single point of failure in accessing the Kubernetes control plane.

## Network Security Implementation

### UFW Firewall Configuration

- Configures Ubuntu's Uncomplicated Firewall (UFW) on all cluster nodes
- Implements point-to-point allowance for Kubernetes control traffic only
- Restricts communication paths to essential service flows:
  - API server to kubelet communications (10250/tcp)
  - Control plane to etcd traffic (2379-2380/tcp)
  - Kubernetes API server communications (6443/tcp)
  - Container networking interfaces (CNI) traffic
- Blocks all other non-essential traffic between nodes

This locked-down networking approach enhances cluster security by minimizing the attack surface and adhering to the principle of least privilege.

## Usage

To deploy a cluster, run:

```bash
ansible-playbook -i inventories/<k3s or k8s>-staging.yml --vault-password-file <secrets file> playbooks/ha-<k3s or k8s>.yml
```
