#!/usr/bin/with-contenv bashio

# Define constants
EXEC="/root/.acme.sh/acme.sh"
API="--dns dns_easydns"
KEYFILE="/ssl/privkey.pem"
CERTFILE="/ssl/fullchain.pem"
CA_ACCOUNT_FILE="/config/ca/acme-v02.api.letsencrypt.org/directory/account.json"
REGEX_PATTERN='\["mailto:(.*)"\]'

# Get variables from Add-On config
export EASYDNS_Token=$(bashio::config 'easydns_token')
export EASYDNS_Key=$(bashio::config 'easydns_key')
EMAIL=$(bashio::config 'email_address')
DOMAIN=$(bashio::config 'fqdn')

# Check if CA account has been registered
#if [  ! -f ${CA_ACCOUNT_FILE} ]; then
#  ${EXEC} --register-account -m ${EMAIL}

# Check if email address has been changed since last registration
#elif [[ ${CA_ACCOUNT_FILE} =~ ${REGEX_PATTERN} ]]; then
#  if [ ${BASH_REMATCH[1]} != ${EMAIL} ]; then
#      ${EXEC} --update-account -m ${EMAIL}
#  fi
#fi

# Issue certificate
${EXEC} --issue ${API} -d ${DOMAIN}

# Copy certificate to be used by Home Assistant
${EXEC} --install-cert -d ${DOMAIN} --fullchain-file ${CERTFILE} --key-file ${KEYFILE}
