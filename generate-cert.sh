#!/bin/bash

# Check if mkcert is installed
if ! command -v mkcert &> /dev/null; then
    echo "mkcert is not installed. Installing mkcert..."
    brew install mkcert
fi

# Check if nss is installed (required for Firefox compatibility)
if ! brew list nss &> /dev/null; then
    echo "nss is not installed. Installing nss..."
    brew install nss
fi

# Create a local CA if it doesn't exist
if ! mkcert -check &> /dev/null; then
    echo "Creating local CA..."
    mkcert -install
fi

# Check if domain name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

# Set the domain
DOMAIN=$1

# Create the certs directory if it doesn't exist
CERTS_DIR="./certs"
mkdir -p "$CERTS_DIR"

# Set the certificate and key file paths
CERT_FILE="$CERTS_DIR/$DOMAIN.pem"
KEY_FILE="$CERTS_DIR/$DOMAIN-key.pem"

# Generate SSL certificate for the domain and all subdomains
echo "Generating SSL certificate for $DOMAIN and all subdomains..."

# Remove existing certificates if they exist
rm -f "$CERT_FILE" "$KEY_FILE"

# Create the certificate and key
mkcert -cert-file "$CERT_FILE" -key-file "$KEY_FILE" "$DOMAIN" "*.$DOMAIN"

echo "SSL certificate and key have been successfully created and stored in the $CERTS_DIR directory."

./add-ssl.sh "$CERT_FILE" "$KEY_FILE"

echo "Done."