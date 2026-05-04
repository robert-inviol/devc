# bash completion for devc
# Source this file from ~/.bashrc, or symlink it into:
#   /etc/bash_completion.d/    (system-wide)
#   ~/.local/share/bash-completion/completions/devc   (per-user)

_devc_complete() {
  local cur prev
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  # Flag completions
  if [[ "$cur" == -* ]]; then
    local flags="-h --help --version -n --dry-run --editor"
    # shellcheck disable=SC2207
    COMPREPLY=( $(compgen -W "$flags" -- "$cur") )
    return
  fi

  # --editor takes one of these values
  if [[ "$prev" == "--editor" ]]; then
    # shellcheck disable=SC2207
    COMPREPLY=( $(compgen -W "code code-insiders cursor" -- "$cur") )
    return
  fi

  # Project-name completions (live; reflects current filesystem)
  local names
  names=$(command devc --list-names 2>/dev/null)
  # shellcheck disable=SC2207
  COMPREPLY=( $(compgen -W "$names" -- "$cur") )
}

complete -F _devc_complete devc
