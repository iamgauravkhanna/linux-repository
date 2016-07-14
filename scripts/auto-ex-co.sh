#!/bin/bash
CODE_BASE=/cygdrive/c/hcentive-code/server/COHIX_Base #
SOURCE_LOC=/cygdrive/c/hcentive-code/build/exco/ #
echo "[INFO] Current Source Contents"
ls -lrt $SOURCE_LOC #
sleep 2 #
cd $SOURCE_LOC #
chmod -R 777 $SOURCE_LOC #
echo "[INFO] Removing Source Content"
rm -rf  #
sleep 3 #
mkdir agent employer individual #
echo "[INFO] Transferring Config to Source Location"
cp -r $CODE_BASE/config $SOURCE_LOC #
echo "[INFO] Transferring ShopJob to Source Location"
cp -r $CODE_BASE/applications/shop-jobs/target/smallgroup  $SOURCE_LOC #
echo "[INFO] Transferring Agent to Source Location"
cp -r $CODE_BASE/applications/agent-hix-portal/target/agent-hix-portal-3.2.0-Patch3/* $SOURCE_LOC/agent #
echo "[INFO] Transferring Employer to Source Location"
cp -r $CODE_BASE/applications/employer-hix-portal/target/employer-public-3.2.0-Patch3/* $SOURCE_LOC/employer #
echo "[INFO] Transferring Individual to Source Location"
cp -r $CODE_BASE/applications/individual-hix-portal/target/individual-webapp-public-3.2.0-Patch3/* $SOURCE_LOC/individual #
chmod -R 777 $SOURCE_LOC #
echo "[INFO] Artifacts Transfer Finished"
chmod -R 777 $SOURCE_LOC #
echo "[INFO] Updated Source Content"
ls -lrt #
echo "[INFO] Archive Build"
tar -cvf build.tar.gz * #
echo "[INFO] Build Transfer to EX-CO"
scp $SOURCE_LOC/build.tar.gz ubuntu@ex-co.demo.hcentive.com:/mnt/cohix/latest/ #