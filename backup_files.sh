# Backup script 

#!/bin/bash
backup=/mybackup/etc-$(date +%Y-%m-%d).tgz	# variable 'backup'
tar -cvf $backup /etc 						          # backsup /etc to /mybackup/etc/-$(date +%Y-%m-%d).tgz

# Append date to filename: filename-"`date +"%Y-%m-%d"`".log