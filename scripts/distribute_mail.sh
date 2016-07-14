current_dir=/var/jenkins/projects/prd-hix/bin/abs-build-scripts/properties
for i in `cat $current_dir/distribute.txt`; do ssmtp $i < $1; done