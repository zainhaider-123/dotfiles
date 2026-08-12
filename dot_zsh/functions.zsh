mkcd() {
  mkdir -p "$1" && cd "$1"
}

mkcode() {
  mkdir -p "$1" && code "$1"
}

cdd() {
  cd ~/developer${1:+/$1}
}

if command -v opencode >/dev/null 2>&1; then
  oc() {
    command opencode "$@"
  }
fi

bw-sync() {
  if ! command -v bw >/dev/null 2>&1; then
    print -u2 "bw is not installed"
    return 1
  fi
  if ! command -v jq >/dev/null 2>&1; then
    print -u2 "jq is not installed"
    return 1
  fi

  mkdir -p "$DATA_DIR"

  if ! command bw status 2>/dev/null | grep -q '"status":"unlocked"'; then
    print "Unlocking Bitwarden vault..."
    local bw_session_key
    bw_session_key="$(command bw unlock --raw)" || return 1
    [[ -n "$bw_session_key" ]] || return 1
    export BW_SESSION="$bw_session_key"
  fi

  print "→ Syncing Bitwarden vault..."
  command bw sync || return 1

  print "→ Fetching context7_api_key..."
  local context7_api_key
  context7_api_key="$(command bw get item "Context7 API Key" | jq -r '.notes')" || return 1

  {
    print "secrets:"
    print "  context7_api_key: $(jq -n --arg v "$context7_api_key" '$v')"
  } >"$DATA_FILE"
  chmod 600 "$DATA_FILE"
  print "Wrote $DATA_FILE"
}