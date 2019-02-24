#!/bin/bash

# Enable exit on error
set -e
# Enable exit on undefined variables
set -u

# Configuration
readonly server_auth=1
readonly client_auth=1
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
openssl genrsa -out cert.key 2048

echo 'Creating CSR...'
openssl req -new -key cert.key -out cert.csr -utf8 -subj "/C=HK/O=The Zeroth Special Team/CN=${common_name}"

echo 'Signing certificate...'
echo 'subjectKeyIdentifier=hash' > cert_ext.conf
if [ $ca_has_key_id -eq 1 ]; then
	echo 'authorityKeyIdentifier=keyid:always' >> cert_ext.conf
fi
echo -n 'keyUsage=critical,digitalSignature' >> cert_ext.conf
if [ $server_auth -eq 1 ]; then
	echo -n ',keyEncipherment' >> cert_ext.conf
fi
echo >> cert_ext.conf
echo -n 'extendedKeyUsage=critical' >> cert_ext.conf
if [ $server_auth -eq 1 ]; then
	echo -n ',serverAuth' >> cert_ext.conf
fi
if [ $client_auth -eq 1 ]; then
	echo -n ',clientAuth' >> cert_ext.conf
fi
echo >> cert_ext.conf
echo 'basicConstraints=critical,CA:FALSE' >> cert_ext.conf
echo 'subjectAltName=@alt_names' >> cert_ext.conf
echo '[alt_names]' >> cert_ext.conf
echo "DNS.1=${common_name}" >> cert_ext.conf
if [ ${#alt_names[@]} -ne 0 ]; then
	i=2
	for alt_name in "${alt_names[@]}"; do
		echo "DNS.${i}=${alt_name}" >> cert_ext.conf
		i=$((i+1))
	done
fi
sudo openssl x509 \
	-req -sha256 \
	-days 3650 \
	-CA "$ca_cert_path" -CAkey "$ca_key_path" -CAserial "$ca_serial_path" \
	-extfile cert_ext.conf -in cert.csr -out cert.crt
rm cert_ext.conf
rm cert.csr

echo 'Verifing certificate...'
openssl x509 -text -purpose -nameopt multiline -certopt no_pubkey,no_sigdump -noout -in cert.crt
openssl verify -CAfile "$ca_cert_path" cert.crt

echo 'Combining private key and certificate...'
openssl pkcs12 -export -out cert.pfx -inkey cert.key -in cert.crt
rm -f cert.key cert.crt
