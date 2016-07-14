			svn_path="svn ls https://hcentive.jira.com/svn/PLATFORM/branches"
			prop_file=svn_props
			current_dir=/var/jenkins/projects/prd-hix/bin/abs-build-scripts/bin
	if [ -f $current_dir/temp.txt ];then
			rm -rf $current_dir/temp.txt
	fi
	if [ -f $current_dir/temp1.txt ];then
			rm -rf $current_dir/temp1.txt
	fi
	if [ -f $current_dir/../properties/$prop_file.txt ];then
			rm -rf $current_dir/../properties/$prop_file.txt
	fi
	for i in `$svn_path`
		do
			echo $i >> $current_dir/temp.txt
		done

	for branch in `cat $current_dir/temp.txt | cut -d "/" -f1`
		do
			echo -n $branch, >> $current_dir/temp1.txt
		done
	cd $current_dir/../properties
	if [ -f $current_dir/../properties/$prop_file.txt ];then
			rm -rf $current_dir/../properties/$prop_file.txt
	fi
	svn update
	:>$prop_file.txt
	sed 's/^/branches=private-exchange,/g' $current_dir/temp1.txt > $current_dir/../properties/$prop_file.txt
	cd $current_dir/../properties
	svn commit -m "new branch has been added" $current_dir/../properties/$prop_file.txt