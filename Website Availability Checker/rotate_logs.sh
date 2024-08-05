#!/bin/bash

# Define log file and rotated logs directory
LOGFILE="website_availability.log"
ARCHIVE_DIR="log_archive"

# Create archive directory if it doesn't exist
mkdir -p "$ARCHIVE_DIR"

# Maximum log file size in bytes (e.g., 10MB)
MAX_SIZE=$((10 * 1024 * 1024))

# Check if the log file size exceeds the maximum size
if [[ -f "$LOGFILE" && $(stat -f%z "$LOGFILE") -ge $MAX_SIZE ]]; then
  # Rotate the log file
  TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
  mv "$LOGFILE" "$ARCHIVE_DIR/website_availability_$TIMESTAMP.log"
  touch "$LOGFILE" # Create a new empty log file
fi