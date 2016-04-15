#!/usr/bin/env bash

apt-get update

#install git
apt-get install -y git

#install anaconda
miniconda=Miniconda2-latest-Linux-x86_64.sh
cd /vagrant
if [[ ! -f $miniconda
    wget --quiet http://repo.continuum.io/miniconda/$miniconda
fi
chmod +x $miniconda
./$miniconda -b -p /opt/anaconda

conda_path=/opt/anaconda/bin
echo $conda_path

cat >> /home/vagrant/.bashrc << END
# add for anaconda install
PATH=:$conda_path:\$PATH
END

#install jupyter
$conda_path/conda install jupyter

#install numpy
$conda_path/conda install numpy

#install pandas
$conda_path/conda install pandas

#install scipy
$conda_path/conda install scipy

#install matplotlib
$conda_path/conda install matplotlib

#install statsmodels
$conda_path/conda install statsmodels

#install seaborn
$conda_path/conda install seaborn

#install dependencies for reading from html
$conda_path/conda install beautiful-soup
$conda_path/conda install html5lib
$conda_path/conda install lxml

#install dependencies for reading data from Excel
$conda_path/conda install xlrd
$conda_path/conda install openpyxl

#install scikit-learn
$conda_path/conda install scikit-learn

#install statsmodels
$conda_path/conda install statsmodels

#install spyder
$conda_path/conda install spyder

#install numexpr (needed for .query() on pandas dataframe)
$conda_path/conda install numexpr