#!/bin/sh

# ------------------------------------
# WP-MICRO
# ------------------------------------
# @author: admin@tropicloud.net
# version: 0.3
# ------------------------------------

user="wordpress"
home="/home/$user"
wpm="/var/wpm"
web="/var/wpm/web"

# ------------------------------------
# wpm functions
# ------------------------------------

for f in /wpm/bin/*; do
	. $f
done

# ------------------------------------
# wpm commands
# ------------------------------------

  if [[  $1 == 'setup'  ]];     then wpm_setup $@
elif [[  $1 == 'start'  ]];     then wpm_start $@
elif [[  $1 == 'stop'  ]];      then wpm_stop $@
elif [[  $1 == 'restart'  ]];   then wpm_restart $@
elif [[  $1 == 'reload'  ]];    then wpm_reload $@
elif [[  $1 == 'shutdown'  ]];  then wpm_shutdown $@
elif [[  $1 == 'status'  ]];    then wpm_status $@
elif [[  $1 == 'log'  ]];       then wpm_log $@
elif [[  $1 == 'login'  ]];     then wpm_login $@
elif [[  $1 == 'root'  ]];      then wpm_root $@

else echo "
----------------------------------------------------
  WP-MICRO  - www.tropicloud.net
----------------------------------------------------  

  HOW TO USE:
  
  wpm start                 # Start all processes
  wpm start <name>          # Start a specific process
  wpm stop                  # Stop all processes
  wpm stop <name>           # Stop a specific process
  wpm status                # Get status for all processes
  wpm status <name>         # Get status for a single process
  wpm restart               # Restart all processes
  wpm restart <name>        # Restart a specific process
  wpm reload                # Restart Supervisord
  wpm shutdown              # Stop the container
  wpm log                   # Display last 1600 *bytes* of main log file
  wpm login                 # Login as npstack user
  wpm root                  # Login as root

----------------------------------------------------  

"
fi
