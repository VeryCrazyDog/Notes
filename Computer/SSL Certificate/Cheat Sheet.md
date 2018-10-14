Check private key length
```sh
openssl rsa -in server.key -text -noout
```

Check certificate
```sh
openssl x509 -in server.crt -text -noout
```

Generate a private key using RSA 2048 bits
```sh
openssl genrsa -out server.key 2048
```

Generate a private key using RSA 2048 bits and a SHA256 signed CSR
```sh
openssl req -new -newkey rsa:2048 -nodes -sha256 -keyout server.key -out server.csr -subj "/C=HK/ST=state/L=city/O=organization/OU=department/CN=commonname"
```

Generate a new SHA256 signed CSR given a private key
```sh
openssl req -new -key server.key -sha256 -out server.csr -subj "/C=HK/ST=state/L=city/O=organization/OU=department/CN=commonname"
```

Generate a new SHA256 signed CSR given a private key and an existing certificate
```sh
openssl x509 -x509toreq -in server.crt -signkey server.key -sha256 -out server.csr
```

Generate a self-signed SHA256 certificate with 10 years life given a private key and a CSR
```sh
openssl x509 -req -sha256 -days 3650 -in server.csr -signkey server.key -out server.crt
```

Generate a private key using RSA 2048 bits and a self-signed SHA256 certificate with 10 years life
```sh
openssl req -newkey rsa:2048 -nodes -sha256 -keyout server.key -x509 -days 3650 -out server.crt -subj "/C=HK/ST=state/L=city/O=organization/OU=department/CN=commonname"
```

Combine PEM private key and PEM certificate into a PKCS12 bundle
```sh
openssl pkcs12 -export -out server.pfx -inkey server.key -in server.crt -name "friendlyname"
openssl pkcs12 -export -out server.pfx -inkey private.key -in cert.crt -certfile ca_cert.crt -name "friendlyname"
```

List out all certificates in a Java keystore
```sh
/usr/java/jdk1.6.0_45/bin/keytool -list -v -keystore /usr/java/jdk1.6.0_45/jre/lib/security/cacerts
```

Import a certificate `verisignclass3g5ca.cer` as trusted CA with alias `verisignclass3g5ca` to Java keystore
```sh
/usr/java/jdk1.6.0_45/bin/keytool -import -trustcacerts -alias verisignclass3g5ca -file /root/ca-cert-import/verisignclass3g5ca.cer -keystore /usr/java/jdk1.6.0_45/jre/lib/security/cacerts
```
