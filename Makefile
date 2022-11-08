.PHONY: start-rs-ssl
start-rs-ssl:
	chmod +rwx *.sh
	. run.sh

.PHONY: gen-certs
gen-certs:
	chmod +rwx *.sh
	. gen-certs.sh
