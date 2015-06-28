#!/bin/sh

# ------------------------------------
# WP-MICRO
# ------------------------------------
# @author: admin@tropicloud.net
# version: 0.3
# ------------------------------------

export user="wordpress"
export home="/home/$user"
export wpm="$home/wpm"
export web="$wpm/web"

# ------------------------------------
# wpm functions
# ------------------------------------

for f in /wpm/bin/*; do
	. $f
done

# ------------------------------------
# wpm commands
# ------------------------------------

  if [[  $1 == 'build'  ]];     then wpm_build $@
elif [[  $1 == 'start'  ]];     then wpm_start $@
elif [[  $1 == 'stop'  ]];      then wpm_stop $@
elif [[  $1 == 'restart'  ]];   then wpm_restart $@
elif [[  $1 == 'reload'  ]];    then wpm_reload $@
elif [[  $1 == 'shutdown'  ]];  then wpm_shutdown $@
elif [[  $1 == 'status'  ]];    then wpm_status $@
elif [[  $1 == 'log'  ]];       then wpm_log $@
elif [[  $1 == 'ps'  ]];        then wpm_ps $@
elif [[  $1 == 'login'  ]];     then wpm_login $@
elif [[  $1 == 'root'  ]];      then wpm_root $@
elif [[  $1 == 'adminer'  ]];   then wpm_adminer $@

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
  wpm ps                    # List all container processes
  wpm log                   # Display last 1600 *bytes* of main log file
  wpm login                 # Login as wordpress user
  wpm root                  # Login as root

----------------------------------------------------  

"
fi
