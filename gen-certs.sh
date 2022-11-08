DIR="ssl"

# Optional: Ensure the target directory exists and is empty.
rm -rf "${DIR}"
mkdir -p "${DIR}"

# Create the openssl configuration file. This is used for both generating
# the certificate as well as for specifying the extensions. It aims in favor
# of automation, so the DN is encoding and not prompted.
cat > "${DIR}/openssl.cnf" << EOF
[req]
default_bits = 2048
encrypt_key  = no # Change to encrypt the private key using des3 or similar
default_md   = sha256
prompt       = no
utf8         = yes
distinguished_name = req_distinguished_name
req_extensions = v3_req

[req_distinguished_name]
C  = US
ST = California
L  = The Cloud
O  = Demo
CN = My Certificate

[v3_req]
basicConstraints     = CA:FALSE
subjectKeyIdentifier = hash
keyUsage             = digitalSignature, keyEncipherment
extendedKeyUsage     = clientAuth, serverAuth
subjectAltName       = @alt_names

[alt_names]
DNS.1 = mongo1
DNS.2 = mongo2
DNS.3 = mongo3
DNS.2 = localhost
IP.1 = 127.0.0.1
EOF

echo "Generating CA key and certificate..."

# Create the certificate authority (CA). This will be a self-signed CA, and this
# command generates both the private key and the certificate. You may want to
# adjust the number of bits (4096 is a bit more secure, but not supported in all
# places at the time of this publication).
#
# To put a password on the key, remove the -nodes option.
#
# Be sure to update the subject to match your organization.
openssl genrsa -des3 -out "${DIR}/ca.key" 2048

openssl req \
	-x509 \
  	-subj "/C=US/ST=California/L=The Cloud/O=My Company CA" \
	-addext basicConstraints=CA:TRUE \
	-addext subjectAltName=DNS:"127.0.0.1" \
	-new \
	-nodes \
	-key "${DIR}/ca.key" \
	-sha256 \
	-days 1024 \
	-out "${DIR}/ca.pem"

openssl genrsa -out "${DIR}/server.key" 2048

openssl req \
  -new -key "${DIR}/server.key" \
  -out "${DIR}/server.csr" \
  -config "${DIR}/openssl.cnf"

openssl x509 -req \
	-in "${DIR}/server.csr" \
	-CA "${DIR}/ca.pem" \
	-CAkey "${DIR}/ca.key" \
	-CAcreateserial \
	-out "${DIR}/server.crt" \
	-days 500 \
	-sha256 \
	-extensions v3_req \
	-extfile "${DIR}/openssl.cnf"

cat "${DIR}/server.key" "${DIR}/server.crt" > "${DIR}/server.pem"

# (Optional) Verify the certificate.
openssl x509 -in "${DIR}/server.crt" -noout -text

