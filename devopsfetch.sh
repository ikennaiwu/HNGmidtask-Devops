#!/bin/bash

# Function to display active ports and services
function show_ports() {
    if [ -n "$1" ]; then
        netstat -tuln | grep ":$1" | awk '{print $1, $4, $7}' | column -t
    else
        netstat -tuln | awk 'NR>2 {print $1, $4, $7}' | column -t
    fi
}

# Function to display Docker images and containers
function show_docker() {
    if [ -n "$1" ]; then
        docker inspect "$1"
    else
        echo "Docker Images:"
        docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.CreatedSince}}"
        echo "Docker Containers:"
        docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
    fi
}

# Function to display Nginx domains and ports
function show_nginx() {
    if [ -n "$1" ]; then
        echo "Displaying details for domain: $1"
        grep -E -A 6 "\b$1\b" /etc/nginx/nginx.conf | awk 'NR>2 {print $2, $3, $4}'
    else
        echo "Displaying Nginx Configured Domains"
        echo -e "CONFIG PATH\t\tDOMAIN\t\t\t\tURL"
        grep -E "\bserver_name\b" /etc/nginx/nginx.conf |
        grep -E "\bserver_name\b|\bproxy_pass\b" /etc/nginx/sites-enabled/* | awk '
        {
            if ($2 ~ /server_name/) {
                file = $1;
                sub(/:.*$/, "", file);
                domain = $3;
                sub(/;$/, "", domain);
            } else if ($2 ~ /proxy_pass/) {
                url = $3;
                sub(/;$/, "", url);
                print file, domain, url;
            }
        }' | sort | uniq | column -t
    fi
}

# Function to list users and their last login times
function show_users() {
    if [ -n "$1" ]; then
        lastlog | grep "$1"
    else
        lastlog
    fi
}

# Function to display activities within a specified time range
function show_time_range() {
    start_time="$1"
    end_time="$2"
    sudo journalctl --since "$start_time" --until "$end_time"
}

# Function to display help message
function show_help() {
    echo "Usage: $0 [OPTION]... [ARGUMENT]..."
    echo "Options:"
    echo "  -p, --port [PORT_NUMBER]      Display all active ports or specific port"
    echo "  -d, --docker [CONTAINER_NAME] Display Docker images/containers or specific container"
    echo "  -n, --nginx [DOMAIN]          Display Nginx domains or specific domain"
    echo "  -u, --users [USERNAME]        Display users or specific user"
    echo "  -t, --time START END          Display activities within time range"
    echo "  -h, --help                    Show this help message and exit"
}

# Main function to parse arguments and call respective functions
while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--port)
            show_ports "$2"
            shift 2
            ;;
        -d|--docker)
            show_docker "$2"
            shift 2
            ;;
        -n|--nginx)
            show_nginx "$2"
            shift 2
            ;;
        -u|--users)
            show_users "$2"
            shift 2
            ;;
        -t|--time)
            show_time_range "$2" "$3"
            shift 3
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

if [ $# -eq 0 ]; then
    show_help
fi
