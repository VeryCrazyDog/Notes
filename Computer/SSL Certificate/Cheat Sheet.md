## Notes
Please notice that:
- `.cert`, `.cer`, `.crt` are actually `.pem` (or rarely `.der`) formatted file with a different extension. Windows Explorer does not recognize `.pem` as a certificate file. See https://serverfault.com/questions/9708/what-is-a-pem-file-and-how-does-it-differ-from-other-openssl-generated-key-file.

## Reference
- https://roll.urown.net/ca/ca_root_setup.html

## Cheat sheet

Check private key length
```sh
openssl rsa -text -noout -in server.key
```

Check a Certificate Signing Request (CSR)
```sh
openssl req -text -nameopt multiline -reqopt no_pubkey,no_sigdump -noout -verify -in server.csr
```

Check certificate information and purpose
```sh
openssl x509 -text -purpose -nameopt multiline -certopt no_pubkey,no_sigdump -noout -in server.crt
```

Verify certificate using root certificate
```sh
openssl verify -CAfile ca.crt server.crt
```

Generate a private key using RSA 2048 bits
```sh
openssl genrsa -out server.key 2048
```

Generate a private key using RSA 2048 bits and a CSR
```sh
openssl req -new -newkey rsa:2048 -nodes -keyout server.key -out server.csr -utf8 -subj "/C=HK/ST=state/L=city/O=organization/OU=department/CN=commonname"
```

Generate a CSR given a private key
```sh
openssl req -new -key server.key -out server.csr -utf8 -subj "/C=HK/ST=state/L=city/O=organization/OU=department/CN=commonname"
```

Generate a CSR with subject alternative name using configuration file given a private key
```sh
cat <<EOF > server_cert.conf
[req]
default_bits=2048
utf8=yes
prompt=no
default_md=sha256
req_extensions=req_ext
distinguished_name=dn
[dn]
C=HK
ST=state
L=city
O=organization
OU=department
CN=commonname
[req_ext]
subjectAltName=@alt_names
[alt_names]
DNS.1=commonname
DNS.2=commonname2
EOF
openssl req -new -key server.key -out server.csr -config server_cert.conf
rm server_cert.conf
```

Generate a CSR based on an existing certificate and a given private key
```sh
openssl x509 -x509toreq -in server.crt -signkey server.key -out server.csr
```

Sign a CSR using a given private key and generate a SHA256 certificate with 10 years life
```sh
# Produce a V1 certificate
openssl x509 -req -sha256 -days 3650 -in server.csr -signkey server.key -out server.crt

# Produce a V3 certificate which is same output as OpenSSL self-sign certificate using command `openssl req`
cat << EOF > openssl_default_ext.conf
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid:always
basicConstraints=critical,CA:TRUE
EOF
openssl x509 -req -sha256 -days 3650 -in server.csr -signkey server.key -out server.crt -extfile openssl_default_ext.conf
rm openssl_default_ext.conf

# Produce a V3 CA certificate which does not allow any intermediate CA
cat <<EOF > ca_cert_ext.conf
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid:always
keyUsage=critical,digitalSignature,keyCertSign,cRLSign
extendedKeyUsage=serverAuth,clientAuth
basicConstraints=critical,CA:TRUE,pathlen:0
EOF
openssl x509 -req -sha256 -days 3650 -in ca.csr -signkey ca.key -out ca.crt -extfile ca_cert_ext.conf
rm ca_cert_ext.conf

# Produce a V3 server authentication certificate
# To enhance security, consider using `extendedKeyUsage=critical,serverAuth`
cat <<EOF > server_cert_ext.conf
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid:always
keyUsage=critical,digitalSignature,keyEncipherment
extendedKeyUsage=serverAuth
basicConstraints=critical,CA:FALSE
EOF
# Include this if copy extensions is not enabled in OpenSSL, see https://stackoverflow.com/questions/21488845/how-can-i-generate-a-self-signed-certificate-with-subjectaltname-using-openssl
cat <<EOF >> server_cert_ext.conf
subjectAltName=@alt_names
[alt_names]
DNS.1=commonname
DNS.2=commonname2
EOF
openssl x509 -req -sha256 -days 3650 -in server.csr -signkey server.key -out server.crt -extfile server_cert_ext.conf
rm server_cert_ext.conf

# Produce a V3 client authentication certificate
# To enhance security, consider using `extendedKeyUsage=critical,clientAuth`
cat <<EOF > client_cert_ext.conf
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid:always
keyUsage=critical,digitalSignature
extendedKeyUsage=clientAuth
basicConstraints=critical,CA:FALSE
EOF
openssl x509 -req -sha256 -days 3650 -in client.csr -signkey client.key -out client.crt -extfile client_cert_ext.conf
rm client_cert_ext.conf
```

Generate a private key using RSA 2048 bits and a self-signed SHA256 V3 certificate with 10 years life
```sh
openssl req -newkey rsa:2048 -nodes -sha256 -keyout server.key -x509 -days 3650 -out server.crt -utf8 -subj "/C=HK/ST=state/L=city/O=organization/OU=department/CN=commonname"
```

Create a new CA serial
```sh
openssl rand -hex 16 > ca.srl
```

Sign a CSR using CA key, CA cert and CA serial, and generate a SHA256 V3 server certificate with 10 years life
```sh
# `authorityKeyIdentifier=keyid:always` should be removed if CA certificate does not contain `subjectKeyIdentifier`
cat <<EOF > server_cert_ext.conf
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid:always
keyUsage=critical,digitalSignature,keyEncipherment
extendedKeyUsage=serverAuth
basicConstraints=critical,CA:FALSE
EOF
openssl x509 -req -sha256 -days 3650 -CA ca.crt -CAkey ca.key -CAserial ca.srl -in server.csr -out server.crt -extfile server_cert_ext.conf
rm server_cert_ext.conf
```

Combine private key and certificate into a PKCS12 encrypted bundle
```sh
# Combine private key and certificate
openssl pkcs12 -export -out server.pfx -inkey server.key -in server.crt

# Combine private key and certificate, and give a friendly name for display during import
openssl pkcs12 -export -out server.pfx -inkey server.key -in server.crt -name "friendlyname"

# Combine private key and certificate, give a friendly name, and include additional certificates such as intermediate certificates or root certificate
openssl pkcs12 -export -out server.pfx -inkey private.key -in cert.crt -certfile inter_certs.crt -name "friendlyname"
```

List out all certificates in a Java keystore
```sh
/usr/java/jdk1.6.0_45/bin/keytool -list -v -keystore /usr/java/jdk1.6.0_45/jre/lib/security/cacerts
```

Import a certificate `verisignclass3g5ca.cer` as trusted CA with alias `verisignclass3g5ca` to Java keystore
```sh
/usr/java/jdk1.6.0_45/bin/keytool -import -trustcacerts -alias verisignclass3g5ca -file /root/ca-cert-import/verisignclass3g5ca.cer -keystore /usr/java/jdk1.6.0_45/jre/lib/security/cacerts
```
