#!/bin/sh

GIT_CRYPT_KEY="$1"
GIT_CRYPT_FILE="/git-crypt.key"

# Decode git-crypt key to file
echo "${GIT_CRYPT_KEY}" | base64 -d > "${GIT_CRYPT_FILE}"

# Unlock the repo
git-crypt unlock "${GIT_CRYPT_FILE}"

# Remove the key file
rm "${GIT_CRYPT_FILE}" | true
