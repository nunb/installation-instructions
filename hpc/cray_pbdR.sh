#!/bin/bash


## Load/set appropriate modules and software environments 
module swap PrgEnv-cray PrgEnv-gnu/4.2.34
module load java/jdk1.7.0_45
module load acml/5.3.1

## Create installation directory on lustre space
mkdir -p /scratch/sciteam/\$USER/R-3.0.2-Install
export R_WORK_HOME=/scratch/sciteam/\$USER/R-3.0.2-Install
cd \$R_WORK_HOME

## Download R source code 
wget http://mirrors.nics.utk.edu/cran/src/base/R-3/R-3.0.2.tar.gz
tar -xzvf R-3.0.2.tar.gz
cd R-3.0.2

## Configure R
# NOTE: for better performance, do not use "--enable-memory-profiling" and "--enable-R-shlib"
./configure --prefix=\$R_WORK_HOME --enable-R-profiling --enable-memory-profiling --enable-R-shlib --enable-BLAS-shlib --enable-lto --enable-byte-compiled-packages --enable-shared --enable-long-double --with-readline --with-tcltk --with-cairo --with-libpng --with-jpeglib --with-libtiff --with-system-pcre --with-valgrind-instrumentation --with-x --with-blas=``-I/opt/acml/5.3.1/gfortran64_mp/include -L/opt/acml/5.3.1/gfortran64_mp/lib -lacml_mp'' --with-lapack > configure.log

make > make.log
make check > make_check.log
make install > make_install.log
make check-all > make_check_all.log

## Install R packages
export PATH=\$R_WORK_HOME/bin:\$PATH
export LD_LIBRARY_PATH=\$R_WORK_HOME/lib64/R/lib:\$LD_LIBRARY_PATH

mkdir -p \$R_WORK_HOME/R_pkg_sources
cd \$R_WORK_HOME/R_pkg_sources


## Download R packages
wget http://cran.r-project.org/src/contrib/rlecuyer_0.3-3.tar.gz
wget http://cran.r-project.org/src/contrib/pbdMPI_0.2-2.tar.gz
wget http://cran.r-project.org/src/contrib/pbdSLAP_0.1-8.tar.gz
wget https://github.com/wrathematics/pbdBASE/archive/master.zip
mv master pbdBASE.zip
unzip pbdBASE.zip

wget https://github.com/wrathematics/pbdDMAT/archive/master.zip
mv master pbdDMAT.zip
unzip pbdDMAT.zip

wget  https://github.com/wrathematics/SEXPtools/archive/master.zip
mv master SEXPtools.zip
unzip SEXPtools.zip

## R packages installation
R CMD INSTALL --no-test-load rlecuyer_0.3-3.tar.gz

## pbdMPI install
R CMD INSTALL --no-test-load pbdMPI --configure-args=``--with-mpi=/opt/cray/mpt/6.2.0/gni/mpich2-gnu/48/ --with-mpi-type=MPICH3''

R CMD INSTALL --no-test-load pbdSLAP_0.1-8.tar.gz
 
R CMD INSTALL --no-test-load pbdBASE

R CMD INSTALL --no-test-load pbdDMAT

R CMD INSTALL --no-test-load SEXPtools

## Copy all needed dynamic libraries to Lustre 

mkdir -p \$R_WORK_HOME/system_libs
cd \$R_WORK_HOME/
./dyn_libs_copy.sh \$R_WORK_HOME/lib64/R/lib \$R_WORK_HOME/system_libs
./dyn_libs_copy.sh \$R_WORK_HOME/lib64/R/library/pbdMPI/libs \$R_WORK_HOME/system_libs

echo ``Now you are ready to use \proglang{R} and \proglang{pbdR}. Good Luck !!!''

