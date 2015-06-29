#!/bin/sh

# WP SUBMARINE
# ---------------------------------------------------------------------------------
# @author: admin@tropicloud.net
# version: 0.1
# ---------------------------------------------------------------------------------

export user="wordpress"
export home="/home/$user"
export www="$home/www"
export web="$www/web"

# FUNCTIONS
# ---------------------------------------------------------------------------------

for f in /wps/bin/*; do source $f; done


# COMMANDS
# ---------------------------------------------------------------------------------

  if [[  $1 == 'build'  ]];     then wps_build $@
elif [[  $1 == 'start'  ]];     then wps_start $@
elif [[  $1 == 'stop'  ]];      then wps_stop $@
elif [[  $1 == 'restart'  ]];   then wps_restart $@
elif [[  $1 == 'reload'  ]];    then wps_reload $@
elif [[  $1 == 'shutdown'  ]];  then wps_shutdown $@
elif [[  $1 == 'status'  ]];    then wps_status $@
elif [[  $1 == 'log'  ]];       then wps_log $@
elif [[  $1 == 'ps'  ]];        then wps_ps $@
elif [[  $1 == 'login'  ]];     then wps_login $@
elif [[  $1 == 'root'  ]];      then wps_root $@
elif [[  $1 == 'adminer'  ]];   then wps_adminer $@


# HELP
# ---------------------------------------------------------------------------------

else echo "
----------------------------------------------------
  WP-MICRO  - www.tropicloud.net
----------------------------------------------------  

  HOW TO USE:
  
  wps start                 # Start all processes
  wps start <name>          # Start a specific process
  wps stop                  # Stop all processes
  wps stop <name>           # Stop a specific process
  wps status                # Get status for all processes
  wps status <name>         # Get status for a single process
  wps restart               # Restart all processes
  wps restart <name>        # Restart a specific process
  wps reload                # Restart Supervisord
  wps shutdown              # Stop the container
  wps ps                    # List all container processes
  wps log                   # Display last 1600 *bytes* of main log file
  wps login                 # Login as wordpress user
  wps root                  # Login as root

----------------------------------------------------  

"
fi
