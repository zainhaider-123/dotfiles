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
  local chezmoi_source_path
  local data_dir
  local data_file

  chezmoi_source_path="$(command chezmoi source-path 2>/dev/null || echo "$HOME/.local/share/chezmoi")"
  data_dir="$chezmoi_source_path/.chezmoidata"
  data_file="$data_dir/secrets.yaml"

  mkdir -p "$data_dir"

  if ! command -v bw >/dev/null 2>&1; then
    print -u2 "bw is not installed"
    return 1
  fi
  if ! command -v jq >/dev/null 2>&1; then
    print -u2 "jq is not installed"
    return 1
  fi

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
  context7_api_key="$(command bw get item "Context7 API Key" | jq -r '.login.password')" || return 1

  if [[ -z "$context7_api_key" ]]; then
    print -u2 "Context7 API key not found"
    return 1
  fi

  print "→ Fetching OpenCode API key..."
  local opencode_api_key
  opencode_api_key="$(jq -r '.["opencode-go"].key // empty' "$HOME/.local/share/opencode/auth.json")" || return 1

  if [[ -z "$opencode_api_key" ]]; then
    print -u2 "OpenCode API key not found"
    return 1
  fi

  {
    print "secrets:"
    print "  context7_api_key: $(jq -n --arg v "$context7_api_key" '$v')"
    print "  opencode_api_key: $(jq -n --arg v "$opencode_api_key" '$v')"
  } >"$data_file"

  chmod 600 "$data_file"
  print "Wrote $data_file"
}
