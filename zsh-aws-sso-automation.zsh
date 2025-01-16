# Account-based aliases
export AWS_PAGER="" # disables pager for aws cli commands

accounts() {
  # Returns list of known accounts from ~/.aws/config
  opts=$(grep "\[profile " ~/.aws/config | awk '{ print $2; }' | tr -d ']' | tr '\n' ' ')
  COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}

# Set the session's AWS ACCOUNT ID to be used with the other AWS aliases at the top of this script
# Add the account name to the prompt if possible
account() {
  if [[ $# == 1 ]]; then
    export ACCOUNT=$1
    export AWS_PROFILE=$1
    sso_check
  else
    sso_check
    echo "AWS Account: ${ACCOUNT}"
  fi
}

noaccount() {
  unset ACCOUNT
  unset AWS_PROFILE
  unset SSO_EXPIRES_AT
  echo "Unset AWS account"
}

complete -F accounts account

sso_login() {
  aws sso login
  # Get latest SSO cache file and extract expiration time
  latest_cache=$(ls -t ~/.aws/sso/cache/*.json | head -n 1)
  if [[ -f "$latest_cache" ]]; then
    export SSO_EXPIRES_AT=$(cat "$latest_cache" | jq -r '.expiresAt') # Format: 2024-11-16T03:27:06Z
  else
    unset SSO_EXPIRES_AT
  fi
}

sso_check() {
  # Get latest SSO cache file and check expiration time first
  latest_cache=$(ls -t ~/.aws/sso/cache/*.json | head -n 1)

  if [[ -f "$latest_cache" ]]; then
    cache_expires=$(cat "$latest_cache" | jq -r '.expiresAt')
    cache_expires_unix=$(date -u -j -f "%Y-%m-%dT%H:%M:%SZ" "$cache_expires" +%s)
    current_unix=$(date -u +%s)
    if [[ $current_unix < $cache_expires_unix ]]; then
      export SSO_EXPIRES_AT=$cache_expires
      echo "SSO session expires in $(date -u -r $((cache_expires_unix - current_unix)) +'%d days %H:%M:%S')"
      return
    fi
  fi
  
  # If we get here, either no cache file exists or session is expired
  sso_login
}
