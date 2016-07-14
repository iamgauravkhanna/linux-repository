chmod 777 exqa1.sh

read -p "Press Enter to Continue"

base-dir=/cygdrive/c/hcentive-code/code

cd $base-dir/build/build-tools
mvn -Dmaven.test.skip=true clean install -f pom.xml

cd /cygdrive/c/hcentive-code\code\build\
mvn -Dmaven.test.skip=true clean install -f service-deps.pom
mvn -Dmaven.test.skip=true clean install -f web-deps.pom

#cd /cygdrive/c/hcentive-code\code\build\individual-build-hix
#mvn clean install -f pom.xml -P prod
#mvn clean install -Dserver=weblogic -f pom.xml

#cd /cygdrive/c/hcentive-code\code\build\shop-build-hix
#mvn clean install -f pom.xml -P prod

#cd /cygdrive/c/hcentive-code\code\build\agent-build-hix
#mvn clean install -f pom.xml -P prod

#cd /cygdrive/c/hcentive-code\code\applications\individual-hix-jobs
#mvn clean install -f pom.xml -P prod

#cd /cygdrive/c/hcentive-code\code\applications\shop-jobs
#mvn clean install -f pom.xml -P prod

#cd /cygdrive/c/code/build/individual-build-hix

#cd /cygdrive/c/code/applications/individual-webapp-public/target

#tar -zcvf individual.tar individual

#cd /cygdrive/c/code/applications/employer-public/target

#tar -zcvf employer.tar employer

#cd /cygdrive/c/code

#tar -zcvf config.tar config

#cd /cygdrive/c/code

#tar -zcvf db.tar db

#mkdir /cygdrive/c/build

#find /cygdrive/c/code/applications/individual-webapp-public/target -iname '*.tar' -exec mv '{}' /cygdrive/c/testing/exqa/ \;

#find /cygdrive/c/code/applications/employer-public/target -iname '*.tar' -exec mv '{}' /cygdrive/c/testing/exqa/ \;

#find /cygdrive/c/code -iname '*.tar' -exec mv '{}' /cygdrive/c/testing/exqa/ \;

#find /cygdrive/c/code -iname '*.tar' -exec mv '{}' /cygdrive/c/testing/exqa/ \;