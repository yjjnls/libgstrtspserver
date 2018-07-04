#! /bin/bash

pushd src
sudo git am --abort
sudo git am ../patch/0001-add-property-to-set-sync-false-and-close-session.patch
popd


mkdir -p build && cd build
cmake ..
make 
sudo make install