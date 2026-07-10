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