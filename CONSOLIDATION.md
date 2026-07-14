# Dotfiles Consolidation Analysis

*Generated 2026-07-18 from a full audit of this repo, the live machine state (`$HOME` symlinks, binary provenance, Homebrew, active nix-darwin generation), and git history. No files were changed; this document is the only addition.*

---

## TL;DR

This repo contains **four generations** of config management stacked on top of each other. Only one of them — `nix-config/` — is actually live. Nothing in your `$HOME` points at the top-level app directories anymore: every active config is either a home-manager symlink into the nix store, a Homebrew install, or an unmanaged plain file.

The ten highest-impact actions, in rough order:

1. **Commit the pending `nix/` deletion** — the old flake's removal is sitting unstaged in your worktree.
2. **Delete `nix-config/shared/packages.nix`** — it's a byte-for-byte orphaned duplicate of `modules/packages.nix` (and you're actively editing *both*, per git status).
3. **Wire or delete the three dead modules**: `karabiner.nix`, `default.nix` (karabiner + amethyst), `zen-browser.nix` — none are imported by the flake, so karabiner/amethyst are silently hand-deployed today.
4. **Re-enable Homebrew management in nix-darwin** — 17 casks and ~20 formulas currently live entirely outside your declared config.
5. **Fix the hardcoded `rrajath` paths** in `nushell.nix` and the JAVA_HOME conflict — the `work` profile (username `rajath.ramakrishna`) is broken by them.
6. **Delete the superseded top-level dirs** (`alacritty/`, `wezterm/`, `fish/`, `zsh/`, `vim/`, `helix/`, `starship/`, `ghostty/`, `aerospace/`, `doom_yasnippets.org`) — git history keeps them; the live configs all moved to nix modules.
7. **Move the pure archives** (Alfred, iTerm2, JetBrains, VSCode, sublime, …) into a single `archive/` dir, or delete them.
8. **Capture the drift**: atuin's live `config.toml` and karabiner's live `karabiner.json` are unmanaged plain files.
9. **Fix the emacs tangle drift** — the repo's tracked `post-init.el` is a Dec 2024 snapshot; the org file tangles straight into `~/.emacs.d`, bypassing the repo.
10. **Rewrite `README.org`** — it still describes the 2022 literate-programming workflow and never mentions nix.

---

## 1. What is actually live on this machine

Audited against the running system (nix-darwin generation 518, activated 2026-07-18).

| App / config | Live location | Managed by | Verdict |
|---|---|---|---|
| nushell | `~/Library/Application Support/nushell/` | home-manager (`modules/nushell.nix`) | ✅ nix. **Trap:** `~/.config/nushell/config.nu` is a 40-byte stub that does nothing — on macOS nushell reads from `Library/Application Support`. |
| git | `~/.config/git/config` | home-manager (`modules/git.nix`) | ✅ nix (XDG path; no `~/.gitconfig`, which is correct) |
| starship | `~/.config/starship.toml` | home-manager | ✅ nix |
| ghostty (config) | `~/.config/ghostty/config` | home-manager | ✅ nix — but the **app** is a Homebrew cask |
| helix, jj, jjui, herdr, zed, atuin (shell hooks), carapace, direnv, zoxide | various | home-manager | ✅ nix |
| claude-code | `~/.claude/*` | home-manager, sourced from `claude-code/` | ✅ nix (good single-source pattern — see §5.3) |
| atuin **config.toml** | `~/.config/atuin/config.toml` | nobody | ⚠️ plain file (Dec 2024), drifted — `atuin.nix` declares no `settings` |
| karabiner | `~/.config/karabiner/karabiner.json` | nobody | ⚠️ plain file (21 KB), hand-managed; `karabiner.nix` exists but is never imported |
| emacs | `~/.emacs.d/` (real directory, **not** a symlink to the repo) | nobody | ⚠️ partially synced with repo by hand — see §4.9 |
| zsh | `~/.zshrc`, `~/.zshenv` | nobody | 💤 inert legacy (login shell is nushell) |
| tmux | binary from brew, **no config anywhere** | nobody | ⚠️ decide: config it in nix or drop it |
| zellij | binary **missing**; only `.backup` files in `~/.config/zellij/` | nobody | 💤 decommissioned |
| wezterm | cask installed (`wezterm@nightly`), no config | nobody | ⚠️ decide |
| ssh | `~/.ssh/config` | nobody | plain file (probably fine to leave) |
| `~/.local/bin` | argo, claude, herdr, forge, hermes, jj-fzf, emacs-lsp-booster, uv, ruff, pyright, pnpm shims… | nobody | ⚠️ manual binary pile, invisible to nix |

**Homebrew** (all outside nix, since `homebrew.enable = false` at `nix-config/shared/darwin.nix:35`):

- **Casks (17):** amethyst, bettertouchtool, bitwarden, docker, docker-desktop, dropbox, font-hack-nerd-font, ghostty, itsycal, jordanbaird-ice, kap, kitty, lathe, thaw, tigervnc, tigervnc-viewer, vnc-viewer, wezterm@nightly
- **Formula leaves (~20):** bash, bitwarden-cli, cmake, coreutils, enchant, eza, ffmpeg, fontforge, gcc, git-filter-repo, gnu-sed, libgccjit, llama.cpp, mas, n, opencode, openjdk@21, prettier, pygobject3, tmux — plus emacs-plus@30 (source of the live emacs binary)

**Key takeaway:** no symlink anywhere in `$HOME` points into `~/dotfiles` — the top-level app dirs are 100% dormant. There is also no stow, no install script; the only apply mechanism is `darwin-rebuild switch --flake .#personal|work`.

---

## 2. The four generations in this repo

| Gen | Era | Mechanism | Status |
|---|---|---|---|
| 1. Literate org configs | ~2022–2024 | `README.org` per app dir, tangled by hand to `~/.config/<app>` | Dormant, except **emacs**, which still works this way |
| 2. Raw top-level config dirs | ~2022–2025 | plain files (`ghostty.toml`, `karabiner.json`, `amethyst.yml`, …), symlinked by the old flake or copied by hand | Dormant except **karabiner** and **amethyst** (hand-deployed) |
| 3. Old `nix/` flake | ~2024–2025 | dustinlyons/nixos-config template (apps scripts, hosts/darwin + hosts/nixos, overlays) | **Deleted in worktree, deletion uncommitted.** Still in HEAD. |
| 4. `nix-config/` | 2025–now | nix-darwin + home-manager flake, `personal`/`work` profiles | **Live.** This is the consolidation target. |

Plus one independent track: **`.emacs.d/`** — a literate config (`PreInitConfig.org`/`PostInitConfig.org` → `pre/post-init.el`) that nix doesn't touch, tracked cleanly (11 files; elpa/eln-cache properly gitignored).

---

## 3. Full inventory, categorized

### A. Consolidated in nix-config and live — keep as-is

`nushell`, `jujutsu`, `jjui`, `herdr`, `helix`, `starship`, `ghostty` (config), `git`, `zed-editor`, `atuin` (hooks), `carapace`, `direnv`, `zoxide`, `claude-code`, `macos-settings`. All imported via `shared/home.nix` (git via each profile's `home.nix`).

### B. Nix module exists but is DEAD — wire it or delete it

| File | Problem | Recommendation |
|---|---|---|
| `modules/karabiner.nix` | Never imported; links `.config/karabiner` → `../../karabiner` | Wire it — but via `mkOutOfStoreSymlink` (§5.3), because Karabiner-Elements rewrites its own json |
| `modules/default.nix` | Never imported; duplicates the karabiner link + deploys `amethyst.yml` | Delete; fold amethyst into its own wired module |
| `modules/zen-browser.nix` | Never imported despite the `zen-browser` flake input existing | Wire it or drop both the module *and* the flake input (dead inputs still get fetched/locked) |
| `shared/packages.nix` | Identical twin of `modules/packages.nix`; nothing references it | Delete (keep `modules/packages.nix`, which both profiles `callPackage`) |
| `shared/casks.nix`, `shared/brews.nix`, profile `homebrew` blocks | Inert while `homebrew.enable = false` | See §5.2 |

### C. Live on the machine but unmanaged — bring under nix

- All 17 casks + ~20 brew formulas (§5.2)
- atuin `config.toml` → port into `programs.atuin.settings`
- karabiner `karabiner.json` (current live copy vs repo copy last committed 2026-06-05 — diff before adopting)
- tmux: either add `programs.tmux` or uninstall the formula
- `~/.local/bin` pile: at minimum document it; move what's packageable (uv, ruff, pyright…) into `packages.nix`
- emacs (§5.4)

### D. Superseded legacy — delete (git history preserves them)

`alacritty/`, `wezterm/`, `fish/`, `zsh/`, `vim/`, `helix/`, `starship/`, `ghostty/`, `aerospace/`, `doom_yasnippets.org`, and the `~/.zshrc`/`~/.zshenv` files on disk. Each is either superseded by a live nix module (helix, starship, ghostty) or by an app you left (alacritty/wezterm → ghostty, fish/zsh → nushell, vim → helix, aerospace → amethyst). `kitty/` is a borderline case — the cask is still installed; decide (see §7).

### E. Archives, not configs — move to `archive/` or delete

`Alfred/`, `iTerm2/`, `JetBrains/`, `VSCode/`, `sublime/` (all 2022 exports), `BetterTouchTool/` (2026 export — keep, it's your only BTT backup), `Firefox/` (uBlock backup), `BrowserExtensions/`, `brew/`, `MacSetup/`, `Apps/`. These are app-settings exports and installed-software notes, not tangle sources. One `archive/` dir makes the repo root stop lying about what's active.

### F. Emacs — special track (see §5.4)

---

## 4. Duplicates and conflicts, itemized

1. **`shared/packages.nix` ≡ `modules/packages.nix`** — identical content, only the latter is used, *both* have uncommitted edits right now. This is the most urgent dedupe because it will silently eat a future edit.
2. **Ghostty, twice, divergent**: top-level `ghostty/ghostty.toml` (5 lines, `catppuccin-mocha`, opacity 0.7) vs `modules/ghostty.nix` (opacity 1.0, quick-terminal keybind, titlebar tabs, ssh shell-integration). The module is live and newer → delete the dir.
3. **Helix & starship**: top-level literate `README.org`s tangle to `~/.config/…`, but home-manager owns those paths now. Any tangle would be overwritten or shadowed → delete the dirs.
4. **Karabiner, twice, both dead**: `karabiner.nix` and `default.nix` both link the same dir; neither is imported.
5. **prettier and typescript-language-server** are installed by **both** `modules/packages.nix` (nix) **and** Homebrew. Two copies, PATH-order-dependent behavior. Remove the brew ones once nix wins.
6. **coreutils** exists three ways: brew-installed (live), declared in `shared/brews.nix` (inert), and available as a nixpkg. Pick nix.
7. **JAVA_HOME, three-way conflict**: `shared/home.nix` sets it to `/etc/profiles/per-user/rrajath/bin` (a bin dir — not a valid JAVA_HOME at all), `nushell.nix` sets `/opt/homebrew/Cellar/openjdk@21/21.0.10/` (hardcoded version, breaks on every brew upgrade), and `personal/darwin.nix` declares `openjdk@17` (inert). Meanwhile brew actually has openjdk@21, and `packages.nix` also ships `jre8`. Pick one JDK, install via nix, derive JAVA_HOME from the package (§5.1).
8. **jjui and direnv double-install**: both have `programs.*.enable` modules *and* appear in `packages.nix`. Harmless but redundant — remove from `packages.nix`.
9. **Emacs tangle drift**: repo `init.el` matches live; repo `post-init.el` is Dec 2024 while live is Jul 2026 — `PostInitConfig.org` tangles into `~/.emacs.d/` directly, so the repo's tracked `.el` snapshots rot.
10. **`README.org` describes generation 1** ("tangle the org files with Emacs") — no mention of nix; links to zsh/fish configs you no longer use.
11. **Old `nix/` deletion uncommitted** — dozens of `D` entries polluting every git status.
12. **`.DS_Store` is tracked** (repo root and `nix-config/`). Add to `.gitignore`, `git rm --cached`.
13. **`jujutsu.nix` hardcodes the personal email** — on the `work` profile, jj commits would use `r.rajath@protonmail.com`. Git handles this per-profile; jj doesn't. (Also `work/home.nix` has `work@company.com`, which looks like a placeholder.)
14. **`nushell.nix` hardcodes `rrajath`** in PATH entries (`/etc/profiles/per-user/rrajath/bin`, `/Users/rrajath/...`) — broken on the work profile (`rajath.ramakrishna`).
15. **`~/.config/nushell/` decoy** — see §1; worth deleting the stub or leaving a comment in it pointing at the real location.
16. **VNC three ways** (tigervnc, tigervnc-viewer, vnc-viewer) and **docker + docker-desktop** both casked — probably only one of each is wanted.

---

## 5. Recommendations

### 5.1 Structural fixes inside nix-config (small, high value)

- **One `packages.nix`.** Delete `shared/packages.nix`; keep `modules/packages.nix`. Better: stop `callPackage`-ing it from each profile and add `home.packages` in `shared/home.nix` directly, so profiles only add *deltas*.
- **Move `git.nix` into `shared/home.nix` imports.** Both profiles import it identically; the only per-profile part is the email, which already lives in each profile's `home.nix`. Same for jj: add a `signature`/email override point per profile instead of hardcoding in `jujutsu.nix`.
- **Parameterize the user.** You already pass `user` via `specialArgs`. Replace every hardcoded `rrajath` path with `config.home.homeDirectory` or `/etc/profiles/per-user/${user}/bin`. Files affected: `nushell.nix`, `shared/home.nix`, `jujutsu.nix`.
- **Fix JAVA_HOME properly:**
  ```nix
  home.packages = [ pkgs.jdk21 ];
  home.sessionVariables.JAVA_HOME = "${pkgs.jdk21.home}";
  ```
  then drop `jre8`, the brew `openjdk@21`, and the inert `openjdk@17` declaration.
- **Trim `nushell.nix`'s PATH list** — half the entries (`~/Library/Python/3.9/bin`, `/Users/rrajath/.local`, `/Users/rrajath/bin/venv/bin`) look stale; each hardcodes the user.
- **Add a convenience wrapper** so applying config is one command again (the old flake's `apps/` did this). A tiny `justfile` or nushell alias: `darwin-rebuild switch --flake ~/dotfiles/nix-config#personal`. You already have `alias drp` in nushell — extend that pattern for both profiles.

### 5.2 Homebrew: the biggest consolidation gap

`homebrew.enable = false` (macOS 26 update issue, per the comment) means the *entire* GUI-app layer is undeclared. Recommendation, in order of preference:

1. **Try re-enabling with activation updates off.** The usual macOS 26 hang is nix-darwin running `brew update`/`upgrade` during activation. Setting:
   ```nix
   homebrew = {
     enable = true;
     onActivation = { autoUpdate = false; upgrade = false; cleanup = "none"; };
     casks = [ ... ];
   };
   ```
   makes activation only install/uninstall from your lists, never update — which usually sidesteps the issue. Update brew manually when you choose.
2. **Port the live inventory into the declarations**: the 17 casks into `shared/casks.nix` (or per-profile), keeping in brew only what must stay brew: casks (GUI apps + fonts), `emacs-plus@30`, `mas`.
3. **Move CLI formulas to nix** where a nixpkg exists: coreutils, gnu-sed, eza, cmake, ffmpeg, git-filter-repo, prettier, typescript-language-server, llama.cpp, bash. That empties most of `brew leaves`.
4. **Later, once the lists are complete and trusted**, set `onActivation.cleanup = "zap"` for true declarativeness — *not before*, since it uninstalls anything unlisted.
5. Optional: **nix-homebrew** (declarative taps, pinned brew itself). Nice-to-have, not required for consolidation.

### 5.3 Pick ONE pattern for file-based configs

You currently have three patterns; standardize on two:

- **Inline nix** (what `ghostty.nix`, `helix.nix`, `nushell.nix` do): best for configs you rarely touch. Rebuild to apply. **Default choice.**
- **`mkOutOfStoreSymlink` to a repo path**: best for configs that churn or that the *app itself rewrites*. The symlink points at the working tree, so edits apply instantly and app-made changes land as git diffs:
  ```nix
  xdg.configFile."karabiner".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/karabiner";
  ```
  Use for: **karabiner** (Karabiner-Elements rewrites its json — a read-only store symlink would fight it), **amethyst**, and optionally **claude-code** (currently store-copied via `home.file.source`, meaning edits to `claude-code/` need a rebuild to take effect — switch if that annoys you).
- **Retire** the "store-copy from a top-level dir" pattern (`default.nix`'s approach) — it's the worst of both: repo-located *and* rebuild-required.

Convention to adopt: an app's config lives **either** inline in its module **or** in a top-level source dir referenced by `mkOutOfStoreSymlink` — never both, and any top-level dir that isn't referenced from `nix-config/` gets deleted or archived. After cleanup, the only top-level config dirs left should be: `claude-code/`, `karabiner/`, `amethyst/` (if kept), `.emacs.d/`, `archive/`.

### 5.4 Emacs

Keep emacs **out** of home-manager's file management — the config churns daily and store symlinks would make iteration miserable. But fix the sync problem, because today `~/.emacs.d` is a hand-synced copy of the repo (init.el identical, post-init.el 19 months apart):

**Recommended:** make `~/.emacs.d` a symlink to `~/dotfiles/.emacs.d` (one `ln -s`, or via `mkOutOfStoreSymlink`), and set the org files' `:tangle` targets to relative repo paths. Then: org file is the single source, tangled output lands in the repo, emacs loads it directly, package state (elpa/eln-cache) stays gitignored in place. The repo's tracked `.el` files stop rotting because they *are* the live ones.

Alternative (if you don't want runtime files inside the repo dir): stop tracking the tangled `.el` files entirely and keep tangling to `~/.emacs.d`. Cost: a fresh machine needs emacs + a manual tangle before first launch, and your `.el` history disappears. The symlink option is better.

The emacs **binary** can stay `emacs-plus@30` via brew — it's the pragmatic choice on macOS; just declare it once Homebrew management is re-enabled (`brew = [ "d12frosted/emacs-plus/emacs-plus@30" ]` with the tap).

### 5.5 Target end-state layout

```
dotfiles/
├── README.org            # rewritten: nix-first, points at nix-config/
├── CONSOLIDATION.md      # this file (delete when done)
├── .emacs.d/             # literate emacs config; ~/.emacs.d symlinks here
├── claude-code/          # source dir, referenced by claude-code.nix
├── karabiner/            # source dir, referenced by karabiner.nix (mkOutOfStoreSymlink)
├── amethyst/             # source dir (if amethyst stays)
├── archive/              # Alfred, iTerm2, JetBrains, VSCode, sublime, BTT export,
│                         # Firefox, BrowserExtensions, brew notes, MacSetup, Apps
└── nix-config/
    ├── flake.nix
    ├── modules/          # one file per app; packages.nix lives here, once
    ├── shared/           # darwin.nix, home.nix, casks.nix, brews.nix
    ├── personal/         # deltas only: email, personal casks
    └── work/             # deltas only: email, work casks
```

### 5.6 README

Rewrite `README.org` to describe reality: nix-darwin + home-manager, the two profiles, the one-command apply, the mkOutOfStoreSymlink convention, and the emacs special case. The literate-programming intro can shrink to a note on `.emacs.d`.

---

## 6. Phased migration plan

Each phase is independently shippable and low-risk before the next.

**Phase 0 — hygiene (10 min, zero risk)**
Commit the `nix/` deletion. Gitignore + `git rm --cached` the `.DS_Store`s. Commit the in-flight claude-code/emacs work sitting in the index.

**Phase 1 — nix-config internal fixes (~1 hr)**
Delete `shared/packages.nix`. Move `git.nix` into shared imports. De-hardcode `rrajath` and fix JAVA_HOME (§5.1). Remove jjui/direnv from `packages.nix`. Fix jj's per-profile email. Rebuild both profiles to verify (`work` may not have built at all recently given the hardcoded paths).

**Phase 2 — wire the dead modules (~30 min)**
`karabiner.nix` via `mkOutOfStoreSymlink` (first diff live `karabiner.json` against the repo copy and adopt the live one). New `amethyst.nix` the same way, or drop amethyst if unused. Delete `modules/default.nix`. Wire `zen-browser.nix` or remove it plus its flake input.

**Phase 3 — Homebrew under nix (~1–2 hr, most impactful)**
Re-enable with `autoUpdate/upgrade = false` (§5.2). Declare the 17 casks. Migrate CLI formulas to `packages.nix`; `brew uninstall` the migrated ones. Add the emacs-plus tap + formula. Leave `cleanup = "none"` until stable.

**Phase 4 — capture drift (~30 min)**
Port atuin `config.toml` into `programs.atuin.settings`. Decide tmux (config or uninstall). Delete the zellij backups and `~/.config/nushell` stub. Triage `~/.local/bin` into `packages.nix` where possible.

**Phase 5 — emacs sync (~30 min)**
Symlink `~/.emacs.d` → repo, fix `:tangle` targets, re-tangle, commit the now-live `.el` files (§5.4).

**Phase 6 — repo cleanup (~30 min)**
Delete category D dirs. Create `archive/` and move category E in. Rewrite `README.org`. Delete this file.

---

## 7. Open questions (answer before Phases 2–4)

1. **Amethyst vs. aerospace** — amethyst is casked and its config is recent (2025-06); aerospace was never live under the current flake. Confirm amethyst is the keeper.
2. **kitty and wezterm** — both casked, neither has a live config; ghostty is your configured terminal. Keep as backups (then declare the casks) or uninstall?
3. **tmux** — brew-installed, zero config. Wanted, or a leftover?
4. **zellij** — binary already gone; OK to delete `zellij/` remnants and backups?
5. **docker vs docker-desktop, and the three VNC casks** — which ones are real?
6. **`work@company.com`** in `work/home.nix` — placeholder to fix, or intentional scrub?
7. **BetterTouchTool/Firefox/BrowserExtensions exports** — keep refreshing these by hand in `archive/`, or stop tracking exports altogether?
