#!/usr/bin/env bash

# setup base operating system
apt-get update
apt-get upgrade -y
apt-get install -y gfortran 
apt-get install -y build-essential
apt-get install -y x11-common 
apt-get install -y libx11-dev 
apt-get install -y xserver-xorg-dev 
apt-get install -y xserver-xorg 
apt-get install -y libxt-dev 
# tools for compiling obabel
apt-get install -y cmake 
apt-get install -y libeigen3-dev zlib1g-dev libeigen2-dev libcairo2-dev python-dev

# install common bioinfo/cheminfo packages
apt-get install -y blast2
apt-get install -y hmmer

# compile and install R
mkdir /tmp/compileR
cd /tmp/compileR
wget http://cran.cnr.berkeley.edu/src/base/R-3/R-3.0.2.tar.gz
tar xvfz R-3.0.2.tar.gz
cd R-3.0.2
./configure
make
make check
make info
make install
make install-info
cd ~/ 
rm -rf /tmp/compileR

# install prereqs for building R packages
apt-get install -y curl libcurl4-openssl-dev
apt-get install -y libgsl0-dev libgsl0ldbl
apt-get install -y libxml2 libxml2-dev 

# compile and install openbabel
mkdir /tmp/compileOB
cd /tmp/compileOB
wget -O ob.tgz http://downloads.sourceforge.net/project/openbabel/openbabel/2.3.2/openbabel-2.3.2.tar.gz?r=http%3A%2F%2Fopenbabel.org%2Fwiki%2FGet_Open_Babel&ts=1388802736&use_mirror=superb-dca2
tar xvfz ob.tgz
mkdir build
cd build
cmake ../openbabel-2.3.2 -DPYTHON_BINDINGS=ON
make -j2
make install
cd ~/
rm -rf /tmp/compileOB

# install R packages
printf "source(\"http://bioconductor.org/biocLite.R\")
biocLite()
biocLite(c(\"ShortRead\", \"Biostrings\", \"IRanges\", \"BSgenome\", \"rtracklayer\", \"biomaRt\",
\"ChemmineR\", \"fmcsR\", \"bioassayR\", \"cellHTS2\", \"RCurl\", \"ape\", \"eiR\", \"ChemmineOB\"))
" | R --slave

# clean up
apt-get clean
