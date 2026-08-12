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

bw-ensure-session() {
  command -v bw >/dev/null 2>&1 || return 0

  if [[ -n "$BW_SESSION" ]] && command bw status --session "$BW_SESSION" 2>/dev/null | grep -q '"status":"unlocked"'; then
    return 0
  fi

  local session
  session="$(command bw unlock --raw)" || return 1
  [[ -n "$session" ]] || return 1
  export BW_SESSION="$session"
}

bw-unlock() {
  if ! command -v bw >/dev/null 2>&1; then
    print -u2 "bw is not installed"
    return 1
  fi

  local session
  session="$(command bw unlock --raw)" || return 1
  [[ -n "$session" ]] || return 1
  export BW_SESSION="$session"
}

chezmoi() {
  case "$1" in
    apply|diff|update|execute-template|init)
      bw-ensure-session || return 1
      ;;
  esac
  command chezmoi "$@"
}