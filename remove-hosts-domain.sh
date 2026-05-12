#!/bin/bash

# Define the target file
HOSTS_FILE="/etc/hosts"
IP_ADDR="127.0.0.1"

# Parse options and collect domains
VERIFY=0
DOMAINS=()

function showHelp(){
    echo "Usage: "
    echo "./remove-hosts-domain.sh [--verify|-V] [--help|-h] [domain1.test domain2.test]"
    echo "curl -sSL [url] | sudo bash -s -- [--verify|-V] [--help|-h] [domain1.test domain2.test]"
    echo ""
    echo "Options:"
    echo "  --verify|-V    Verify the hosts file"
    echo "  --help|-h      Show this help message"
    echo "  domain1.test   The domain to remove from the hosts file"
    echo "  domain2.test   The domain to remove from the hosts file"
    echo ""
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --verify|-V)
            VERIFY=1
            shift
            ;;
        --help|-h)
            showHelp
            exit 0
            ;;
        -*)
            echo "Unknown option: $1"
            exit 1
            ;;
        *)
            DOMAINS+=("$1")
            shift
            ;;
    esac
done

# If no domains were provided and --verify not passed, show usage
if [ ${#DOMAINS[@]} -eq 0 ] && [ $VERIFY -eq 0 ]; then
    showHelp
    exit 1
fi

if [ ${#DOMAINS[@]} -gt 0 ]; then
    echo "Processing hosts entries..."

    for domain in "${DOMAINS[@]}"; do
        ENTRY="$IP_ADDR $domain"

        # Check if the exact entry exists
        if grep -qF "$ENTRY" "$HOSTS_FILE"; then
            echo "Removing: $ENTRY"
            sudo sed -i.bak "/^$(echo "$ENTRY" | sed 's/[[\.*^$/]/\\&/g')$/d" "$HOSTS_FILE"
        else
            echo "Not found: $ENTRY"
        fi
    done
fi

# Only show the hosts file if --verify or -V was passed
if [ $VERIFY -eq 1 ]; then
    echo "--- Current Entries ---"
    sudo cat "$HOSTS_FILE"
fi
