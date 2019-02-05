#!/bin/bash

# Enable exit on error
set -e
# Enable exit on undefined variables
set -u

# Configuration
readonly server_auth=1
readonly ca_key_path='/etc/nginx/ca.key'
readonly ca_serial_path='/etc/nginx/ca.srl'
readonly ca_cert_path='/etc/nginx/ca.crt'
readonly ca_has_key_id=0

# Define variables
common_name=
alt_names=()

# Check arguments
if [ $# -eq 0 ]; then
	echo "Usage: ${0} common_name [subject_alt_name1] [subject_alt_name2] [...]"
	exit 0
fi

# Parse arguments
common_name="$1"
shift
if [ $# -ne 0 ]; then
	alt_names=("$@")
fi

# Implementation
echo 'Creating private key...'
openssl genrsa -out client.key 2048

echo 'Creating CSR...'
openssl req -new -key client.key -out client.csr -utf8 -subj "/C=HK/O=The Zeroth Special Team/CN=${common_name}"

echo 'Signing certificate...'
echo 'subjectKeyIdentifier=hash' > client_cert_ext.conf
if [ $ca_has_key_id -eq 1 ]; then
	echo 'authorityKeyIdentifier=keyid:always' >> client_cert_ext.conf
fi
echo -n 'keyUsage=critical,digitalSignature' >> client_cert_ext.conf
if [ $server_auth -eq 1 ]; then
	echo -n ',keyEncipherment' >> client_cert_ext.conf
fi
echo >> client_cert_ext.conf
echo -n 'extendedKeyUsage=critical,clientAuth' >> client_cert_ext.conf
if [ $server_auth -eq 1 ]; then
	echo -n ',serverAuth' >> client_cert_ext.conf
fi
echo >> client_cert_ext.conf
echo 'basicConstraints=critical,CA:FALSE' >> client_cert_ext.conf
if [ $server_auth -eq 1 ]; then
	echo 'subjectAltName=@alt_names' >> client_cert_ext.conf
	echo '[alt_names]' >> client_cert_ext.conf
	echo "DNS.1=${common_name}" >> client_cert_ext.conf
	if [ ${#alt_names[@]} -ne 0 ]; then
		i=2
		for alt_name in "${alt_names[@]}"; do
			echo "DNS.${i}=${alt_name}" >> client_cert_ext.conf
			i=$((i+1))
		done
	fi
fi
sudo openssl x509 \
	-req -sha256 \
	-days 3650 \
	-CA "$ca_cert_path" -CAkey "$ca_key_path" -CAserial "$ca_serial_path" \
	-extfile client_cert_ext.conf -in client.csr -out client.crt
rm client_cert_ext.conf
rm client.csr

echo 'Verifing certificate...'
openssl x509 -text -purpose -nameopt multiline -certopt no_pubkey,no_sigdump -noout -in client.crt
openssl verify -CAfile "$ca_cert_path" client.crt

echo 'Combining private key and certificate...'
openssl pkcs12 -export -out client.pfx -inkey client.key -in client.crt
rm -f client.key client.crt
