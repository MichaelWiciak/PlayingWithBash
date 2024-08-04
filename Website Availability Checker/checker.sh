#!/bin/bash

# Define log file
LOGFILE="website_availability.log"

# Function to check website availability
check_website() {
  local url=$1
  local status_code
  local timestamp

  # Get current timestamp
  timestamp=$(date +"%Y-%m-%d %H:%M:%S")

  # Fetch the HTTP status code using curl
  status_code=$(curl -o /dev/null -s -w "%{http_code}\n" "$url")

  # Log the result
  echo "$timestamp - URL: $url - Status Code: $status_code" >> "$LOGFILE"

  # Check the status code and display appropriate message
  if [[ $status_code -eq 200 ]]; then
    echo "Website $url is available (Status Code: $status_code)"
  else
    echo "Website $url is not available (Status Code: $status_code)"
  fi
}

# Check if a URL was provided
if [[ -z $1 ]]; then
  echo "Usage: $0 <url>"
  exit 1
fi

# Call the function with the provided URL
check_website "$1"