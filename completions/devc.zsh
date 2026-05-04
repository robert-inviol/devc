#compdef devc
# zsh completion for devc
# Install by either:
#   - placing this file in a directory on your $fpath as `_devc`, or
#   - source it from ~/.zshrc

_devc() {
  local -a flags names

  flags=(
    '-h[show help]'
    '--help[show help]'
    '--version[show version]'
    '-n[dry-run — print URI without launching]'
    '--dry-run[dry-run — print URI without launching]'
    '--editor[editor to use]:editor:(code code-insiders cursor)'
  )

  if [[ "${words[CURRENT]}" == -* ]]; then
    _arguments $flags
    return
  fi

  names=( ${(f)"$(command devc --list-names 2>/dev/null)"} )
  _describe -t projects 'project' names
}

_devc "$@"
