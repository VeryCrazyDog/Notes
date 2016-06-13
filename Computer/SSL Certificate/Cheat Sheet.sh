# Check private key length
openssl rsa -in server.key -text -noout

# Generate a private key using RSA 2048 bits and a SHA256 signed CSR
openssl req -new -newkey rsa:2048 -nodes -sha256 -out server.csr -keyout server.key -subj "/C=HK/ST=state/L=city/O=organization/OU=department/CN=commonname"

# Generate a private key using RSA 2048 bits
openssl genrsa -out server.key 2048

# Generate a new SHA256 signed CSR given a private key
openssl req -new -key server.key -sha256 -out server.csr -subj "/C=HK/ST=state/L=city/O=organization/OU=department/CN=commonname"

# Generate a self-signed certificate with 10 years life and SHA256 signed given a private key and a CSR
openssl x509 -req -sha256 -days 3650 -in server.csr -signkey server.key -out server.crt

# Generating a new SHA256 signed CSR from existing certificate and private key
openssl x509 -x509toreq -in server.crt -signkey server.key -sha256 -out server.csr

# Convert from PEM format to PKCS12 format
openssl pkcs12 -export -out server.pfx -inkey server.key -in server.crt -name "friendlyname"
openssl pkcs12 -export -out server.pfx -inkey private.key -in cert.crt -certfile ca_cert.crt -name "friendlyname"
