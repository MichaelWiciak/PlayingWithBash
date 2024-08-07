#!/bin/bash

# cache :)
# Cache directory
CACHE_DIR="~/cache"
mkdir -p "$CACHE_DIR"

# Cache expiry time in seconds
CACHE_EXPIRY=60

# Function to get the current date and time
current_date_time() {
    echo "$(date '+%Y-%m-%d %H:%M:%S')"
}

# Function to get the system uptime
system_uptime() {
    echo "$(uptime | awk '{print $3, $4}' | sed 's/,//')"
}

# Function to get the system load averages
load_averages() {
    echo "$(uptime | awk -F'load averages: ' '{print $2}')"
}

# Function to get the CPU usage
cpu_usage() {
    echo "$(top -l 1 | grep "CPU usage" | awk '{print $3 " " $4 " " $5 " " $6 " " $7 " " $8}')"
}

# Function to get the memory usage
memory_usage() {
    local page_size=$(vm_stat | grep "page size of" | awk '{print $8}')
    local pages_free=$(vm_stat | grep "Pages free" | awk '{print $3}' | sed 's/\.//')
    local pages_active=$(vm_stat | grep "Pages active" | awk '{print $3}' | sed 's/\.//')
    local pages_inactive=$(vm_stat | grep "Pages inactive" | awk '{print $3}' | sed 's/\.//')
    local pages_speculative=$(vm_stat | grep "Pages speculative" | awk '{print $3}' | sed 's/\.//')
    local pages_wired=$(vm_stat | grep "Pages wired down" | awk '{print $4}' | sed 's/\.//')

    local free=$((pages_free * page_size / 1024 / 1024))
    local active=$((pages_active * page_size / 1024 / 1024))
    local inactive=$((pages_inactive * page_size / 1024 / 1024))
    local speculative=$((pages_speculative * page_size / 1024 / 1024))
    local wired=$((pages_wired * page_size / 1024 / 1024))

    echo "Free: ${free} MB"
    echo "Active: ${active} MB"
    echo "Inactive: ${inactive} MB"
    echo "Speculative: ${speculative} MB"
    echo "Wired: ${wired} MB"
}
# Function to get the disk usage
disk_usage() {
    echo "$(df -h / | tail -1 | awk '{print "Used: " $3 " / Total: " $2 " (" $5 ")"}')"
}

# Function to get the network usage
network_usage() {
    echo "Packets: $(netstat -I en0 | awk 'NR==2 {print "in: " $7 ", out: " $10}')"
}

# Function to get the battery status
battery_status() {
    echo "$(pmset -g batt | grep -o '[0-9]\+%')"
}

top_processes_cpu() {
    echo "Top Processes by CPU Usage:"
    ps -A -o %cpu,pid,comm | sort -nr | head -n 6
}

top_processes_mem() {
    echo "Top Processes by Memory Usage:"
    ps -A -o %mem,pid,comm | sort -nr | head -n 6
}

current_logged_in_users() {
    echo "Current Logged In Users:"
    who
}

open_files_count() {
    local cache_file="$CACHE_DIR/open_files_count"
    if [[ ! -f $cache_file || $(($(date +%s) - $(stat -f %m $cache_file))) -ge $CACHE_EXPIRY ]]; then
        print_color "34" "Number of Open Files:"
        lsof | wc -l > "$cache_file"
    fi
    echo "Open Files: $(cat $cache_file) (expires in $((CACHE_EXPIRY - ($(date +%s) - $(stat -f %m $cache_file)))) seconds)"

    
}

# Function to get terminal width
get_terminal_width() {
    tput cols
}

# Function to print a horizontal line
print_line() {
    local width=$(get_terminal_width)
    printf "%0.s-" $(seq 1 $width)
    echo
}

# Function to print colored text
print_color() {
    local color_code=$1
    shift
    echo -e "\033[${color_code}m$@\033[0m"
}

# Function to center text based on terminal width
center_text() {
    local text="$1"
    local width=$(get_terminal_width)
    local text_length=${#text}
    local padding=$(( (width - text_length) / 2 ))
    printf "%*s%s%*s\n" $padding "" "$text" $padding ""
}


# Display the system information
clear

display() {
    print_color "32" "$(print_line)"
    print_color "32" "$(center_text "System Monitor - macOS")"
    print_color "32" "$(print_line)"
    print_color "33" "Date & Time: $(current_date_time)"
    print_line
    print_color "33" "Uptime: $(system_uptime)"
    print_line
    print_color "33" "Load Averages: $(load_averages)"
    print_line
    print_color "33" "CPU Usage: $(cpu_usage)"
    print_line
    print_color "33" "Memory Usage: "
    print_color "35" "$(memory_usage)"
    print_line
    print_color "33" "Disk Usage: $(disk_usage)"
    print_line
    print_color "33" "Network Usage: $(network_usage)"
    print_line
    print_color "33" "Battery Status: $(battery_status)"
    print_line
    print_color "33" "Processes:"
    print_color "34" "$(top_processes_cpu)"
    print_color "36" "$(top_processes_mem)"
    print_line
    print_color "33" "System Information:"
    print_color "1;30" "$(current_logged_in_users)"
    print_color "1;31" "$(open_files_count)"
    print_color "32" "$(print_line)"
}

display 
# Run the display function every 5 seconds
while true; do
    sleep 5
    clear
    display
done
