#tar - The GNU version of the tar archiving utility

#Create a new tar archive.
tar cvf archive_name.tar dirname/

#Extract from an existing tar archive.
tar xvf archive_name.tar

#View an existing tar archive.
tar tvf archive_name.tar

#grep - Searches the named input FILEs for lines containing a match to the given PATTERN.

#Search for a given string in a file (case in-sensitive search).
grep -i "the" demo_file

#Print the matched line, along with the 3 lines after it.
grep -A 3 -i "example" demo_text

#Search for a given string in all files recursively
grep -r "gaurav" *