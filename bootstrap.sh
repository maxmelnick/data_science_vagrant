#!/usr/bin/env bash

start_seconds="$(date +%s)"
echo "Welcome to the initialization script."

ping_result="$(ping -c 2 8.8.4.4 2>&1)"
if [[ $ping_result != *bytes?from* ]]; then
    echo "Network connection unavailable. Try again later."
    exit 1
fi

# install git
apt_packages=(
    git
)

sudo apt-get update
sudo apt-get upgrade

echo "Installing apt-get packages..."
sudo apt-get install -y ${apt_packages[@]}
sudo apt-get clean

#install anaconda
anaconda=Anaconda2-4.0.0-Linux-x86_64.sh
cd /vagrant
if [ ! -f $anaconda ]
	then
		echo "No Anaconda install file pre-loaded. Downloading Anaconda"
		echo "NOTE: downloading and installing Anaconda2-4.0.0-Linux-x86_64.sh"
    	wget --quiet http://repo.continuum.io/archive/$anaconda
fi
chmod +x $anaconda

sudo -u root ./$anaconda -b -p /opt/anaconda

conda_path=/opt/anaconda/bin
echo $conda_path

cat >> /home/vagrant/.bashrc << END
# add for anaconda install
PATH=:$conda_path:\$PATH
END

# Preemptively accept Github's SSH fingerprint, but only
# if we previously haven't done so.
fingerprint="$(ssh-keyscan -H github.com)"
if ! grep -qs "$fingerprint" ~/.ssh/known_hosts; then
    echo "$fingerprint" >> ~/.ssh/known_hosts
fi

# Vagrant should've created /srv/www according to the Vagrantfile,
# but let's make sure it exists even if run directly.
if [[ ! -d '/srv/notebooks' ]]; then
    sudo mkdir '/srv/notebooks'
    sudo chown vagrant:vagrant '/srv/notebooks'
fi


jupyter=$conda_path/jupyter-notebook
log="/home/vagrant/jupyter.log"
jupyter_args="--ip=0.0.0.0 --notebook-dir=/srv/notebooks"
run="start-stop-daemon --start --chuid vagrant:vagrant --exec $jupyter -- $jupyter_args >> $log 2>&1 &"
eval $run

cat << UPSTART | sudo tee /etc/init/jupyter.conf > /dev/null
description "Anaconda for Data Science"
author "maxmelnick <maxmelnick@gmail.com>"

start on vagrant-mounted MOUNTPOINT=/srv/notebooks

exec $run
UPSTART

end_seconds="$(date +%s)"
echo "-----------------------------"
echo "Provisioning complete in "$(expr $end_seconds - $start_seconds)" seconds"
echo "You can now use 'less -S +F $log' to monitor jupyter notebook server."










