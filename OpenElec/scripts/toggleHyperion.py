#!/usr/bin/python

import subprocess
import signal
import os

process_name = "hyperiond"

proc = subprocess.Popen(["pgrep", process_name], stdout=subprocess.PIPE, 
stderr=subprocess.PIPE) 
stdout, stderr = proc.communicate()

# stdout  contains the PID when boblight-x11 is running.  Otherwise, it will be empty!
# print "debug: stdout variable: ", stdout


# check whether boblight-x11 is not running.
if stdout == '':
   os.system("/storage/hyperion/bin/hyperiond.sh /storage/.config/hyperion.config.json > /dev/null 2>&1 &") 
else:
   pid = int(stdout)
   os.system("killall hyperiond")
