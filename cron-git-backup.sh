#!/bin/bash
# Scheduled git backup — commits and pushes changes weekly
# Add to crontab: 0 5 * * 0 /path/to/cron-git-backup.sh

USER="your-username"

cd /home/"$USER"/
sudo -u "$USER" git add .
sudo -u "$USER" git commit -m "Scheduled Weekly Backup: $(date +"%D %T")"
sudo -u "$USER" git push
