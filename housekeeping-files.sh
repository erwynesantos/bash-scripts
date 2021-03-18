# HOUSEKEEPING FILES

# Filter files according to name and created within a specific date and then zip them
zip -rTm filename.zip $(find dpa_daily_wireline_customers* -type f -newermt Nov-30-2020 ! -newermt Dec-04-2020 )

# Move Files except 1 directory
find path/to/dir/*  \! -name 'this_dir_stays_put' -type d -maxdepth 0 \ -exec mv {​​​​​​}​​​​​​ new/location \;
find . -type f -maxdepth 1 -exec mv {​​​​​​​​}​​​​​​​​ /appl/di_shareddata/di_files/source/subscriber_info/monthly/ \;
find . ! -type d -name '*.xml' ! -type d -name <foldername> -exec mv {} ./Archive \;

# Find files according to name and then list them or delete
find -type f -name "Project_Soundwave_Blaster_Planned_Wireless_20201130_20201227*" -ls
find -type f -name "Project_Soundwave_Blaster_Planned_Wireless_20201130_20201227*" - delete

# Find files and list results to a file
find / -xdev -type f -exec du -sh {} ';' | sort -rh | head -50 > /home/teradata/rootFSutil_20210129.txt 
# -xdev = don't descend to other FS or disks

# Zip files and automatically remove the files added to the zip
zip -9 -rTm maillog_01312021.zip maillog-*
# -9 = maximum compression, -m = move files after archive, -r = remove files after archive, -T = to test the files first before removing after archive

# Filter by filename and get total file size
find DAILY_PROMO_2019* -type f -exec du -ch {} + | grep total
 
# Filter by filename between date range
In example, includes files from Dec. 1 to 31, 2019 ONLY.
Jan. 1, 2020 files are EXCLUDED.
find ssl_request* -type f -newermt 2019-12-01 ! -newermt 2020-01-01 -exec du -ch {} +
 
# Filter by filename between date range & MOVE files to target directory
find file_name -type f -newermt 2019-10-31 ! -newermt 2020-01-01 -exec mv -i -v {} /appl/di_shareddata/di_files/source/txn_promo ';'
 
# Filter by filename within date range and ZIP them (METHOD 1)
find ssl_request* -type f -newermt 2019-10-01 ! -newermt 2020-01-01 | zip -Tm desmid_ssl_request_2019_logs_20200221 -@
 
# If you want to zip ALL files within date range 
find . -type f -newermt 2019-12-01 ! -newermt 2020-01-01 | zip -Tm esp00_new_frontier_deprover_logs_YYYYMMDD -@

# Filter by filename within date range and ZIP them (METHOD 2)
ls -lrth *201911* | awk '{print $9}' | xargs -I '{}' zip -Tm DAILYPROMO201911.zip '{}'

# Compare difference of two files
diff -q 1st_file_name_path 2nd_file_name_path

# Find files in the given time range inside the current directory, list them and print the filesizes only in bytes (7th column)
find . -type f -newermt June-01-2020 ! -newermt October-01-2020 -ls |  awk -F " " '{print$7}'

# Find files in the given time range inside the current directory, list them and print the filesizes only in bytes (7th column), sum them and print in bytes
find . -type f -newermt June-01-2020 ! -newermt October-01-2020 -ls |  awk -F " " '{print$7}' | awk '{ SUM += $1} END { print SUM }'

# Find files in the given time range inside the current directory, list them and print the filesizes only in bytes (7th column), sum them and print in Gigabytes
find . -type f -newermt June-01-2020 ! -newermt October-01-2020 -ls |  awk -F " " '{print$7}' | awk '{ SUM += $1} END { print SUM }' | awk '{print $1/1024/1024/1024 " GB "}'
#----------------------------------------------------------------------------------------------------------------------------------------------