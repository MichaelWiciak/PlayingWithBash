To ensure the log rotation script runs regularly, you can schedule it using cron:

crontab -e

Add an entry to run the rotate_logs.sh script daily, for example:

0 0 \* \* \* rotate_logs.sh

This entry runs the script every day at midnight. Save and exit the crontab file. The script will now run automatically at the scheduled time.

Note about setting up email:
Step 1: Download CA Certificates:
ou need to download the CA certificates bundle, which is commonly used for this purpose. You can use the CA certificates from Mozilla, which are widely trusted.

Download the CA certificates bundle:
bash
Copy code
curl -o /opt/homebrew/etc/openssl@3/certs/ca-certificates.crt https://curl.se/ca/cacert.pem
Step 2: Rehash the Certificates
Once you have the certificates, you need to rehash the directory so OpenSSL can use them:

Rehash the certificates directory:
bash
Copy code
/opt/homebrew/opt/openssl@3/bin/c_rehash /opt/homebrew/etc/openssl@3/certs
Step 3: Update msmtprc Configuration
Now, update your ~/.msmtprc file to point to the new CA certificates file:

plaintext
Copy code
defaults
auth on
tls on
tls_trust_file /opt/homebrew/etc/openssl@3/certs/ca-certificates.crt
logfile ~/.msmtp.log

account default
host smtp.example.com
port 587
from your-email@example.com
user your-email@example.com
password your-email-password
Replace the host, from, user, and password fields with your SMTP server details and credentials.

Make sure you have a :
❯ ~/.msmtprc # msmtp configuration file

For gmail, set up an app password and 2FA. Use that instead of the password of the email account.
