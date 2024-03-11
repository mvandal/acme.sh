#!/usr/bin/with-contenv bashio

# Define constants
API="--dns dns_easydns"
CA="--server letsencrypt"
#CA="--server zerossl"
KEYFILE="/ssl/privkey.pem"
CERTFILE="/ssl/fullchain.pem"

# Get variables from Add-On config
export EASYDNS_Token=$(bashio::config 'easydns_token')
export EASYDNS_Key=$(bashio::config 'easydns_key')
EMAIL=$(bashio::config 'email_address')
DOMAIN=$(bashio::config 'fqdn')
COMMAND=$(bashio::config 'command')

if [ ${COMMAND} == "issue" ]; then
  # Issue certificate
  /usr/local/bin/acme.sh --issue ${API} ${CA} -d ${DOMAIN}
  
  # Copy certificate to be used by Home Assistant
  /usr/local/bin/acme.sh --install-cert -d ${DOMAIN} \
    --fullchain-file ${CERTFILE} \
    --key-file ${KEYFILE}
elif [ ${COMMAND} == "register" ]; then
  # Register account with CA
  /usr/local/bin/acme.sh --register-account -m ${EMAIL} ${CA}
elif [ ${COMMAND} == "daemon" ]; then
  crond -f
else
  echo "Unsupported command: ${COMMAND}"
fi
