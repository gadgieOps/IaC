#!/bin/bash

# Build cloud-init ISO
echo Creating cloud-init ISO...
mkisofs -output ./seeds/cloud-init.iso -volid cidata -joliet -rock ./seeds/user-data ./seeds/meta-data