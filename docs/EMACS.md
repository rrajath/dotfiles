# Emacs — deferred work (broken binary + config sync)

*Recorded 2026-07-19 during consolidation. Both items deferred by choice; this captures the discovered state so the work needs no re-investigation.*

## 1. The binary is broken (pre-existing, discovered 2026-07-19)

- `emacs-plus@30` (30.2, tap `d12frosted/emacs-plus`) **is installed** — it just doesn't show in `brew leaves`. But launching fails:
  `dyld: Library not loaded: /opt/homebrew/opt/jpeg/lib/libjpeg.9.dylib`
  — the `jpeg` formula got removed at some point before the consolidation session (a long-running emacs process would mask this until relaunch).
- `/Applications/Emacs.app` is a 936-byte stub file, not a real app bundle.

**Fix options:**
1. *(Recommended per CONSOLIDATION §5.4)* `brew reinstall emacs-plus@30`, verify launch, then declare in nix: `homebrew.taps += "d12frosted/emacs-plus"`, `brews.nix += "d12frosted/emacs-plus/emacs-plus@30"`. Re-link Emacs.app properly.
2. Switch to nixpkgs `emacs30` in `packages.nix` — fully nix-managed, but loses emacs-plus patches; native-comp/paths need rework.

## 2. Config sync (deferred 3i)

Discovered state:
- Org sources (`PreInitConfig.org`, `PostInitConfig.org`) exist **only** in repo `.emacs.d/`; both tangle to absolute paths (`:tangle ~/.emacs.d/{pre,post}-init.el`).
- Tangled `.el` outputs are gitignored **by design** (`.emacs.d/.gitignore`) — CONSOLIDATION.md's "tracked post-init.el is rotting" was wrong; only tracked **`early-init.el` has drifted** (live is newer). `init.el` and `vulpea-capf.el` are identical; `custom.el` is ignored.
- Live-only in `~/.emacs.d`: `snippets/` (**track it** when syncing), `my-secrets.el` + `my-secrets.el.gpg` (**decision made: gitignore BOTH, never commit**).
- Repo `.emacs.d/` also contains stale *untracked* runtime dirs (elpa, straight, eln-cache, var, etc, org-persist, autosave, backup) from an older era — delete before adopting live state.

Plan (with emacs closed; keep a backup of `~/.emacs.d` until verified):
1. Delete the repo `.emacs.d/` stale untracked runtime dirs.
2. Copy from live: `early-init.el`, `custom.el`, `snippets/`, `my-secrets.el`, `my-secrets.el.gpg`.
3. Extend `.emacs.d/.gitignore`: `/backup/`, `/places`, `/org-persist/`, `my-secrets.el`, `my-secrets.el.gpg`, `.DS_Store`.
4. Move the remaining live runtime state (elpa, straight, eln-cache, var, etc, history, recentf, …) into repo `.emacs.d/`.
5. Remove the now-empty `~/.emacs.d`; declare the symlink in a new `modules/emacs.nix`:
   `home.file.".emacs.d".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.emacs.d";` then `drp`.
6. Change both org `#+PROPERTY :tangle` headers to relative paths (`pre-init.el` / `post-init.el`), re-tangle, verify emacs launches and packages load.
