# Load testing cluster

## Prerequisites

1. Install [terraform](https://www.terraform.io/downloads.html)
1. Ensure you have aws credentials in `~/.aws/credentials`
1. Nodejs

## Deploying cluster

1. First you need to configure parameters. Look at `compile-user-data.js`. Important ones are `CLOUD_URL`, `CLIENTS`, `DEVICES`

1. Compile `.user-data` file `node compile-user-data`

1. Start cluster `terraform apply -var 'key_name=<keypair name>'`

1. To remove cluster `terraform destroy -var 'key_name=<keypair name>'`
