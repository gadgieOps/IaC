# Ansible Playbook: u24-cis.yml

This playbook is designed to implement and enforce the CIS (Center for Internet Security) benchmarks for Ubuntu 24.04 systems. It ensures that the system adheres to industry-standard security practices.

## Features

- Automates the application of CIS security controls.
- Configures system settings to meet compliance requirements.
- Provides a repeatable and consistent method for securing Ubuntu 24.04.

## Requirements

- Ansible 2.9 or later.
- Ubuntu 24.04 target systems.
- Sudo privileges on the target systems.

## Usage

1. Run the playbook

    ```bash
    ansible-playbook -i inventories/<inventory> playbooks/u24-cis.yml
    ```

2. Review audits for next steps

## Runtime Variables

- `-e auditonly=true`: Runs the playbook in audit mode only, without enforcing compliance.
- `-e audit=false`: Enforces compliance without running the audit.
