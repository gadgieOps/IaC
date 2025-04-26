# Terraform Remote Backend Setup

This directory contains Terraform configurations that create an S3 bucket to serve as a remote backend for Terraform state files.

## Overview

To solve the chicken and egg situation of needing a remote backend before you can create one, this setup follows a two-phase approach:

1. Initially use a local backend to provision the S3 bucket and DynamoDB table (if used for state locking)
2. Migrate the state to the newly created remote S3 backend
