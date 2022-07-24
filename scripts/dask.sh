#!/bin/bash

# RDP client
sudo apt update && sudo apt upgrade --yes
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo /etc/init.d/ssh restart
sudo usermod --password $(echo password | openssl passwd -1 -stdin) ubuntu
sudo DEBIAN_FRONTEND="noninteractive" apt install -y xfce4
sudo apt install -y xrdp xfce4-goodies tightvncserver
echo xfce4-session> $HOME/.xsession
sudo cp $HOME/.xsession /etc/skel
sudo sed -i '0,/-1/s//ask-1/' /etc/xrdp/xrdp.ini

# Google chrome
if [[ -f ./google-chrome-stable_current_amd64.deb ]]
then
  sudo rm ./google-chrome-stable_current_amd64.deb
fi
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb --yes

# AWS CLI
if [[ -f ./awscliv2.zip ]]
then
  sudo rm ./awscliv2.zip
fi
if [[ -d ./aws ]]
then
  sudo rm -r ./aws
fi
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Docker engine
sudo apt-get remove -y docker docker-engine docker.io containerd runc
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
if [[ -d /etc/apt/keyrings ]]
then
  sudo rm -r /etc/apt/keyrings
fi
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo apt-get install -y docker-compose
sudo chmod 666 /var/run/docker.sock
sudo usermod -aG docker $USER

# Python system
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt-get update
sudo apt install -y python3.8 python3-pip
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 10
python -m pip install --upgrade pip

 # Conda
if [[ -f $HOME/conda3.sh ]]
then
  sudo rm $HOME/conda3.sh
fi
wget https://repo.anaconda.com/archive/Anaconda3-2022.05-Linux-x86_64.sh -O ~/conda3.sh
bash ~/conda3.sh -b -p $HOME/conda3
eval "$(/home/ubuntu/conda3/bin/conda shell.bash hook)"
conda init
conda config --set auto_activate_base false

# Dask env
conda config --env --set always_yes true

conda create -n dask python=3.8.13 ipython --yes
conda activate dask
conda install -c conda-forge -n dask -y eccodes nodejs

echo 'jinja2==3.0.3
bokeh==2.4.3
boto3==1.20.24
botocore==1.23.24
jsonschema==4.7.2
jupyter-client==7.3.4
jupyter-core==4.11.1
jupyter-server==1.18.1
jupyter-server-proxy==3.2.1
jupyterlab==3.4.4
jupyterlab-pygments==0.2.2
jupyterlab-server==2.15.0
ipykernel==6.15.1
ipython==8.4.0
setuptools==61.2.0
toolz==0.11.2
xarray[complete]==0.21.1
git+https://github.com/intake/kerchunk.git@0.0.5
cloudpickle==2.0.0
dask==2022.1.1
distributed==2022.1.1
msgpack==1.0.2
toolz==0.11.2
tornado==6.1
pandas==1.3.4
numpy==1.21.5
graphviz==0.8.1
click==8.0.4
dask-cloudprovider==2022.1.0
jedi==0.18.1
s3fs==2022.1.0
fsspec==2022.1.0
h5netcdf==0.13.1
numcodecs==0.9.1
blosc==1.10.6
lz4==3.1.10
pickle5==0.0.11
retry==0.9.2
pyyaml==6.0
seawater==3.3.4
awswrangler==2.14.0
netCDF4==1.6.0
tqdm==4.63.0
zarr==2.11.0
dask-labextension==5.2.0
aioboto3==9.3.1
aiobotocore[boto3]==2.1.0
urllib3==1.26.7
'>dask-requirements.in
python -m pip install pip --upgrade
python -m pip install pip-tools
python -m piptools compile dask-requirements.in
pip install -r dask-requirements.txt

python -m ipykernel install --user --name dask --display-name "Python (vietnguyen-dask)"

conda config --env --remove-key always_yes

echo "conda activate dask" >> ~/.bashrc
echo "export AWS_PROFILE=nonproduction-admin" >> ~/.bashrc

conda deactivate

# Reboot
sudo reboot
