To ensure the log rotation script runs regularly, you can schedule it using cron:

crontab -e

Add an entry to run the rotate_logs.sh script daily, for example:

0 0 \* \* \* rotate_logs.sh

This entry runs the script every day at midnight. Save and exit the crontab file. The script will now run automatically at the scheduled time.
