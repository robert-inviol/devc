# Changelog

## 0.2.0 — 2026-05-05

- Shell completions for bash, zsh, and fish, with live project-name completion via a new hidden `--list-names` flag
- `install.sh` auto-drops bash + fish completions in XDG locations; prints zsh setup instructions; skip with `DEVC_NO_COMPLETIONS=1`

## 0.1.0 — 2026-05-05

Initial public release.

- `devc` — list/open VS Code dev containers by short name
- fzf-powered arrow-key picker with live type-to-filter; numbered fallback when fzf isn't present
- `--editor` flag with auto-detection (`cursor` > `code-insiders` > `code`)
- `DEVC_ROOTS` (colon-separated) and `DEVC_ROOT` (single) for search paths
- `--dry-run` / `-n` to print the `vscode-remote://` URI without launching
- prefers a `*.code-workspace` at the project root when present
