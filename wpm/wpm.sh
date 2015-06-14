#!/bin/sh

# ------------------------------------
# WP-MICRO
# ------------------------------------
# @author: admin@tropicloud.net
# version: 0.2
# ------------------------------------

user="wordpress" && home="/home/$user"

# ------------------------------------
# wpm functions
# ------------------------------------

for f in /wpm/bin/*; do
	. $f
done

# ------------------------------------
# wpm commands
# ------------------------------------

  if [[  $1 == 'setup'  ]]; then wpm_setup $@
elif [[  $1 == 'start'  ]]; then wpm_start $@
elif [[  $1 == 'login'  ]]; then wpm_login $@
elif [[  $1 == 'root'  ]];  then wpm_root $@


else echo "
----------------------------------------------------
  WP-MICRO  - www.tropicloud.net
----------------------------------------------------  

  HOW TO USE:

----------------------------------------------------  

"
fi
