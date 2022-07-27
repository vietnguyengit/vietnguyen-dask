# vietnguyen-dask
:warning: This is repo is temporarily set as public for the ease of development progress and intented to be used by internal `AODN` personnel only.


### 1. Cloudformation
Use `stackman` to deploy a `SageMaker` notebook instance with ready to use environment including Python 3.8.13 and its dependencies.

:warning: Select `conda_dask` as your notebook environment.

:warning: Make sure the `source` and `destination` buckets you want to use are permitted in the `IAM role` for creating the `SageMaker` notebook instance.

:warning: `SageMaker` cannot leave the notebook running for countless hours without discruption/kernel timeout issues. And you have to keep your browser open while the notebook running. 


### 2. Bash script
Use the included bash script if you need to use an EC2 instance for running the notebook without discruption/timeout issues.

The script will automate many installation processes for running the notebook without Python dependencies issues.

- First, create an `Ubuntu 20.04` instance with at least `16GB` memory. Then allow port `22` and `3389` to UTAS IP range or your private IP.

- Then, `SSH` to the instance and clone this repo.

- Make sure to configure `AWS authentication` on this EC2 instance: `~/.aws/config` and `~/.aws/credentials`

- Then `cd vietnguyen-dask/scripts` and run `chmod +x dask.sh`, and finally run `./dask.sh` (:warning: **NOTE**: you might want to change password for RDP connection, run `nano dask.sh`)

- Use `Remmina` to access the created instance via `RDP` protocol.

- Use the `Terminal` and run `jupyter lab`

### 3. Fargate cluster
:warning: Make sure you create an `IAM role` for creating the cluster with permissions to access `S3` buckets and `ECS services`.
