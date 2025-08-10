transmission-dangerous-file-remover
Script to Remove Torrents Containing Dangerous Files from Transmission
This script automatically scans your Transmission torrents for dangerous file types (e.g., .exe, .scr, .iso, .zip, .rar) and removes any torrent containing such files along with its downloaded data. It helps protect your system from malware distributed in disguised files.

Prerequisites: Enable Transmission RPC Access, transmission-remote (tested with 3.0)
To use this script, Transmission’s RPC interface must be enabled and accessible.

Locate Transmission's settings.json file, typically in one of these locations:
/var/lib/transmission-daemon/info/settings.json (Linux system-wide)
~/.config/transmission-daemon/settings.json (per-user)

Open the file for editing:
sudo nano /var/lib/transmission-daemon/info/settings.json

Ensure the following settings are set (replace "YOUR_USERNAME" and "YOUR_PASSWORD" with your credentials):
{

"rpc-enabled": true,

"rpc-bind-address": "0.0.0.0",

"rpc-port": 9091,

"rpc-username": "YOUR_USERNAME",

"rpc-password": "YOUR_PASSWORD",

"rpc-whitelist-enabled": false

}

Restart the Transmission daemon for changes to apply:
sudo systemctl restart transmission-daemon

How to Use the Script
Place the script file (nofakes.sh) somewhere on your system, for example /home/youruser/nofakes.sh.

Make the script executable:
chmod +x /home/youruser/nofakes.sh

Edit the script to configure your Transmission RPC credentials by modifying these lines near the top : 

HOST="localhost:9091"

AUTH="YOUR_USERNAME:YOUR_PASSWORD"

and set the log dir :
LOGFILE="/<YOUR_PATH_TO_THIS_SCRIPT>/nofakes.log"

Optionally edit this line : 
BLOCKED_EXTS="exe zip rar iso scr"

How to Automate the Script with Cron
To have the script run automatically every 5 minutes:

Open your user’s crontab for editing:
crontab -e

Add this line at the end, replacing the path with where you saved the script:
*/5 * * * * /bin/bash /home/youruser/nofakes.sh >> /home/youruser/nofakes.log 2>&1

Save and exit.

The script will now run every 5 minutes, automatically removing torrents that contain blocked file types. Logs will be saved in nofakes.log for your review.

License
No license.

