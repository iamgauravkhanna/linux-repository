# !/bin/bash

while true
do
cd /home/ubuntu/Oracle/MW/user_projects/domains/base_domain/catalina.base_IS_UNDEFINED/logs > employer.log
sleep 1s
done

# sudo truncate -s 0

# !/bin/bash

for i in $(ls)
do
  if [[ $(wc -c $i | cut -d" " -f1) -le 100 ]]; then
    echo $(wc -c $i)
  fi
done

#!/bin/bash

file1= wc -c space.sh | cut -d" " -f1

echo $file1

if [$file1 -gt 1]

then

echo "File Size Exceeded"

else

echo "no action"

fi
