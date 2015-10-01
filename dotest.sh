#!/bin/bash
pushd package/echosrv;./activate.sh START;popd
#sleep 2
pushd package/echosrv_test/
./activate.sh TEST
TS=$(./activate.sh teststatus)
echo "'activate.sh teststatus' returned: ${TS}"
if [ "DONE" != ${TS} ]; then
    echo "*** ERROR *** expected DONE"
fi
TR=$(./activate.sh testresults)
echo "'activate.sh testresults' returned: ${TR}"
if [ "PASS" != ${TR} ]; then
    echo "*** ERROR *** expected PASS"
fi
popd
#sleep 2
pushd package/echosrv;./activate.sh STOP;popd

