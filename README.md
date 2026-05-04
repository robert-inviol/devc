# devc

> Open VS Code dev containers from your terminal — with an arrow-key fuzzy picker.

VS Code's "Dev Containers: Reopen in Container" is the right idea. Clicking through it for the 10th time today is the wrong UX.

```text
$ devc
┌─────────────────────────────────────────────────────────────┐
│ 12 projects — ↑↓ pick · type to filter · Esc to cancel      │
├─────────────────────────────────────────────────────────────┤
│ > webapp             ~/src/webapp                           │
│   api-service        ~/src/api-service                      │
│   landing-page       ~/src/landing-page                     │
│   mobile-app         ~/src/mobile-app                       │
│   ...                                                       │
└─────────────────────────────────────────────────────────────┘
devc › web_                                                    12/12
```

`devc` finds every directory under `$HOME/src` that has a `.devcontainer/` and opens the chosen one in VS Code (or Cursor, or VS Code Insiders) — already attached to its dev container. No clicking, no copy-pasting `vscode-remote://` URIs.

## Install

One-liner (drops the script into `~/.local/bin`):

```bash
curl -fsSL https://raw.githubusercontent.com/robert-inviol/devc/main/install.sh | bash
```

Or just grab the script directly:

```bash
curl -fsSL https://raw.githubusercontent.com/robert-inviol/devc/main/devc \
  -o ~/.local/bin/devc && chmod +x ~/.local/bin/devc
```

Make sure `~/.local/bin` is on your `PATH`.

**Optional dependency:** [`fzf`](https://github.com/junegunn/fzf) for the arrow-key picker. Without it, `devc` falls back to a numbered prompt — works either way.

The installer also drops shell completions in the standard XDG locations (`~/.local/share/bash-completion/completions/devc`, `~/.config/fish/completions/devc.fish`). Zsh users get printed instructions — fpath setup is the user's call. Skip with `DEVC_NO_COMPLETIONS=1`.

## Usage

```bash
devc                       # picker over every project with a .devcontainer/
devc webapp                # exact match → opens immediately
devc app                   # multi-match → picker pre-filtered
devc -n webapp             # dry-run: print the URI, don't launch
devc --editor cursor       # use Cursor
devc --version
```

Type-to-filter inside the picker is fuzzy: `app`, `web`, `api` all narrow toward what you're after.

Tab completion completes both flags and project names live (it calls the discovery on every tab so no stale cache):

```bash
devc web<TAB>              # → webapp, web-admin, web-marketing, ...
devc --<TAB>               # → --editor, --dry-run, --help, --version
devc --editor <TAB>        # → code, code-insiders, cursor
```

## Configuration

Override the search roots with environment variables:

```bash
# multiple roots
export DEVC_ROOTS="$HOME/src:$HOME/work:$HOME/oss"

# or a single root (back-compat)
export DEVC_ROOT="$HOME/code"
```

Pin an editor:

```bash
export DEVC_EDITOR=cursor
```

When `--editor` and `DEVC_EDITOR` aren't set, `devc` auto-picks: `cursor` > `code-insiders` > `code`.

## How it works

VS Code already accepts a URI that says *"open this folder, attached to this dev container"*:

```text
vscode-remote://dev-container+<HEX_OF_HOST_PATH>/<IN_CONTAINER_PATH>
```

The friction is constructing the URI — you have to hex-encode the host path. `devc` does that, finds your `.devcontainer/`s, prefers a `*.code-workspace` at the project root if one exists, and `exec`s `code --folder-uri ...` for you.

That's it. No daemon, no config file, ~200 lines of `bash`.

## Why not `@devcontainers/cli`?

Microsoft's official [`@devcontainers/cli`](https://github.com/devcontainers/cli) is great when you need to **build, run, or exec** in a dev container without VS Code at all (CI, headless, scripting). It does *not* help you launch the editor.

`devc` is the small piece on top: pick a project, open the editor in its container. Use both.

## Compatibility

- **Editors:** VS Code, VS Code Insiders, Cursor (anything that ships a `code` / `code-insiders` / `cursor` CLI accepting `--folder-uri`).
- **Shells:** Bash 4+. Tested on Linux and macOS. Windows via WSL or Git Bash.
- **Picker:** `fzf` recommended; falls back to a numbered prompt without it.

## Contributing

PRs welcome. The script aims to stay small and dependency-light — `bash` + `find` + `awk` + (optional) `fzf` is the budget.

Useful before you push:

```bash
shellcheck devc install.sh
bash -n devc
```

CI runs ShellCheck on every push.

## License

MIT. See [LICENSE](LICENSE).
