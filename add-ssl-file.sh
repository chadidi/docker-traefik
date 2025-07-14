#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <certFilePath> <keyFilePath>"
    exit 1
fi

CERT_FILE="$1"
KEY_FILE="$2"
SSL_FILE="./dynamic/ssl.yml"

# Check if the SSL file exists
if [ ! -f "$SSL_FILE" ]; then
    echo "Error: $SSL_FILE not found."
    exit 1
fi

# Add a newline before appending the new certificate entry with extra indentation
{
    echo "    - certFile: \"$CERT_FILE\""
    echo "      keyFile: \"$KEY_FILE\""
} >> "$SSL_FILE"

echo "Certificate added successfully to $SSL_FILE."