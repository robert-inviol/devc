# fish completion for devc
# Install: copy or symlink into ~/.config/fish/completions/devc.fish

function __devc_projects
    command devc --list-names 2>/dev/null
end

complete -c devc -f
complete -c devc -s h -l help     -d "Show help"
complete -c devc      -l version  -d "Show version"
complete -c devc -s n -l dry-run  -d "Print URI without launching"
complete -c devc      -l editor   -d "Editor to use" -x -a "code code-insiders cursor"
complete -c devc -n "not __fish_contains_opt -s h help version" -a "(__devc_projects)"
