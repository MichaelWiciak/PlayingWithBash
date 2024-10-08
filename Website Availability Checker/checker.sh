#!/bin/bash

# Define log file and log rotation script
LOGFILE="website_availability.log"
ROTATE_SCRIPT="./rotate_logs.sh"
EMAIL_SUBJECT="Website Down Alert"
EMAIL_TO="michaelwiciakwebsite@gmail.com"
SMTP_SERVER="smtp.gmail.com"  


# Call log rotation script
"$ROTATE_SCRIPT"

# Function to check website availability
check_website() {
  local url=$1
  local status_code
  local timestamp

  # Get current timestamp
  timestamp=$(date +"%Y-%m-%d %H:%M:%S")

  # Fetch the HTTP status code using curl with -L option to follow redirects
  status_code=$(curl -o /dev/null -s -w "%{http_code}\n" -L "$url")

  # Log the result
  echo "$timestamp - URL: $url - Status Code: $status_code" >> "$LOGFILE"

  # Check the status code and display appropriate message
  if [[ $status_code -eq 200 ]]; then
    echo "Website $url is available (Status Code: $status_code)"
  else
    echo "Website $url is not available (Status Code: $status_code)"
    # Send email notification
    echo -e "Subject:$EMAIL_SUBJECT\n\nWebsite $url is down. Status Code: $status_code\nTimestamp: $timestamp" | msmtp --debug "$EMAIL_TO"
    # if it worked you will see the following message
    if [ $? -eq 0 ]; then
      echo "Email notification sent successfully"
    else
      echo "Failed to send email notification"
    fi
  fi
}
   
# Check if a URL was provided
if [[ -z $1 ]]; then
  echo "Usage: $0 <url>"
  exit 1
fi

# Call the function with the provided URL
check_website "$1"
