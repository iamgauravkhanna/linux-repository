cd /mnt
if [ ! -d = "upload" ];then
mkdir upload
cd upload 
mkdir -p weblogic tomcat weblogic/pbex_current  weblogic/pbex_backup tomcat/pbex_current tomcat/pbex_backup weblogic/temp tomcat/temp logs
cd /mnt
sudo chmod -R 777 *
else
cd /mnt/upload
mkdir -p weblogic tomcat weblogic/pbex_current  weblogic/pbex_backup tomcat/pbex_current tomcat/pbex_backup weblogic/temp tomcat/temp logs
cd /mnt
sudo chmod -R 777 *
fi
cd /home/ubuntu
sudo chmod -R 777 logs

