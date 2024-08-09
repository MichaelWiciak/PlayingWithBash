#!/bin/bash

# File to store tasks
TODO_FILE="$HOME/.todo_list"
DONE_FILE="$HOME/.done_list"

# Function to add a task
add_task() {
    echo "$*" >> "$TODO_FILE"
    echo "Task added: $*"
}

# Function to view tasks
view_tasks() {
    if [ ! -s "$TODO_FILE" ]; then
        echo "No tasks to show."
    else
        echo "Pending tasks:"
        cat -n "$TODO_FILE"
    fi
}

# Function to mark a task as done
mark_done() {
    if [ -s "$TODO_FILE" ]; then
        sed -n "${1}p" "$TODO_FILE" >> "$DONE_FILE"
        sed -i "${1}d" "$TODO_FILE"
        echo "Marked task #$1 as done."
    else
        echo "No tasks to mark as done."
    fi
}

# Function to delete a task
delete_task() {
    if [ -s "$TODO_FILE" ]; then
        sed -i "${1}d" "$TODO_FILE"
        echo "Deleted task #$1."
    else
        echo "No tasks to delete."
    fi
}

# Function to view completed tasks
view_completed_tasks() {
    if [ ! -s "$DONE_FILE" ]; then
        echo "No completed tasks to show."
    else
        echo "Completed tasks:"
        cat -n "$DONE_FILE"
    fi
}

# Function to display help
show_help() {
    echo "To-Do List Manager"
    echo "Usage: $0 [option] [arguments]"
    echo "Options:"
    echo "  add <task>           Add a new task"
    echo "  view                 View all tasks"
    echo "  done <task_number>   Mark a task as done"
    echo "  del <task_number>    Delete a task"
    echo "  view-done            View completed tasks"
    echo "  help                 Show this help message"
}

# Main logic
case $1 in
    add)
        shift
        add_task "$*"
        ;;
    view)
        view_tasks
        ;;
    done)
        mark_done "$2"
        ;;
    del)
        delete_task "$2"
        ;;
    view-done)
        view_completed_tasks
        ;;
    help|*)
        show_help
        ;;
esac
