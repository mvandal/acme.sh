#!/usr/bin/with-contenv bashio

# Define constants
EXEC="/root/.acme.sh/acme.sh"
API="--dns dns_easydns"
CA="letsencrypt"
ENV_FILE="/config/email.env"
KEYFILE="/ssl/privkey.pem"
CERTFILE="/ssl/fullchain.pem"

# Get variables from Add-On config
export EASYDNS_Token=$(bashio::config 'easydns_token')
export EASYDNS_Key=$(bashio::config 'easydns_key')
EMAIL=$(bashio::config 'email_address')
DOMAIN=$(bashio::config 'fqdn')

# Register account with CA
if [ -f ${ENV_FILE} ]; then
  source ${ENV_FILE}
  if [ ${EMAIL} != ${REGISTERED_EMAIL} ]; then
    echo "Email address changed. Updating account with CA..."
    ${EXEC} --update-account --email ${EMAIL}
    echo "export REGISTERED_EMAIL=${EMAIL}">${ENV_FILE}
  fi
else
  echo "Registering account with CA..."
  ${EXEC} --server ${CA} --set-default-ca --register-account --email ${EMAIL}
  echo "export REGISTERED_EMAIL=${EMAIL}">${ENV_FILE}
fi

# Issue certificate
echo "Requesting certificate for ${DOMAIN}"
${EXEC} --issue ${API} -d ${DOMAIN}

# Copy certificate to be used by Home Assistant
${EXEC} --install-cert -d ${DOMAIN} --fullchain-file ${CERTFILE} --key-file ${KEYFILE}
