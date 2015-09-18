#!/bin/bash
pushd package/echosrv;./activate.sh START;popd
#sleep 2
pushd package/echosrv_test/;./activate.sh TEST;popd
#sleep 2
pushd package/echosrv;./activate.sh STOP;popd

