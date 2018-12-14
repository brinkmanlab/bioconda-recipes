#!/bin/bash

samtools view 

function install_htslib(){
    # Download and install htslib. Compiled stuff is in `pwd`/htslib 
    pushd .
    rm -f htslib-1.8.tar.bz2
    wget https://github.com/samtools/htslib/releases/download/1.8/htslib-1.8.tar.bz2
    tar xf htslib-1.8.tar.bz2
    rm htslib-1.8.tar.bz2
    mv htslib-1.8 htslib
    cd htslib
    ./configure --prefix=`pwd`
    make -j 4
    make install
    popd
}
git clone https://github.com/mskcc/facets.git
pushd .
cd facets/inst/extcode/
echo 'INSTALLING HTSLIB'
install_htslib
echo 'HTSLIB DONE'
ln -s `pwd`/htslib/lib/libhts.a `pwd`/htslib/lib/libhts-static.a
echo 'INSTALLING SNP-PILEUP'
g++ -std=c++11 -I `pwd`/htslib/include snp-pileup.cpp -L `pwd`/htslib/lib -lhts-static -o snp-pileup -lcurl -lz -lpthread -lcrypto -llzma -lbz2
./snp-pileup --help
popd

echo 'SNP-PILEUP DONE'

$R -e 'library(RColorBrewer); print("DONE")'

# bash setup.sh --bin_dir $PREFIX/bin
