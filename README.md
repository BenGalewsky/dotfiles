# dotfiles

Personal dotfiles, symlinked into `$HOME` via `install.sh`.

## Structure

Everything under `home/` mirrors its target path relative to `$HOME`:

```
dotfiles/
├── install.sh
└── home/
    ├── .zshrc
    ├── .gitconfig
    ├── .config/
    │   └── zsh/
    │       └── ceph-s3.zsh
    └── .ssh/
        └── config
```

To track a new dotfile, just add it under `home/` at the path it should
occupy relative to `$HOME` (e.g. `home/.tmux.conf` -> `~/.tmux.conf`), then
rerun `./install.sh`. No manifest to maintain.

## Usage

```sh
git clone <this-repo-url> ~/dev/dotfiles
cd ~/dev/dotfiles
chmod +x install.sh   # if the executable bit didn't survive cloning
./install.sh
```

This symlinks every file under `home/` into the matching path under `$HOME`.
If a real file already exists at the destination, it's moved to
`~/.dotfiles_backup/<timestamp>/...` before the symlink is created. Running
it again is safe — already-correct symlinks are left alone.

## Working with Ceph S3 endpoints

`home/.config/zsh/ceph-s3.zsh` (sourced from `.zshrc`) makes it easy to
switch between multiple Ceph object store targets, each with its own AWS
profile and `--endpoint-url`, and then just use `aws s3` / `s3` normally.

**Registering a target** — edit the `CEPH_S3_CONTEXTS` array in that file:

```sh
CEPH_S3_CONTEXTS=(
  isgs_wetlands   "isgs_wetlands https://ceph.example.org:8080"
  odsc            "odsc https://ceph.example.org:8080"
  remat           "remat https://ceph.example.org:8080 us-west-2"
)
```

Each entry maps a short name to `"profile endpoint-url [region]"`, where
`profile` must match a section in `~/.aws/credentials` or `~/.aws/config`.
`region` is optional and defaults to `$CEPH_S3_DEFAULT_REGION` (`us-east-1`)
when omitted — Ceph RGW mostly ignores the region, but some `aws s3`
subcommands (e.g. `s3 mb`) fail without one set.

**Commands:**

| Command | What it does |
| --- | --- |
| `s3ctx <name>` | Activates a context: sets `AWS_PROFILE`, `AWS_ENDPOINT_URL`, and `AWS_DEFAULT_REGION`/`AWS_REGION` for that Ceph target, and clears any stray static credential env vars. |
| `s3ctxs` | Lists all registered contexts, marking the active one with `*`. |
| `s3whoami` | Shows the currently active context (profile + endpoint). |
| `s3ctx-clear` | Clears the active context, falling back to normal AWS config/creds. |
| `s3` / `s3api` | Shorthand aliases for `aws s3` / `aws s3api`. |

**Typical workflow:**

```sh
s3ctx odsc                       # switch to the odsc Ceph target
s3 ls s3://some-bucket/
s3 cp file.txt s3://some-bucket/
s3whoami                         # confirm what's active
s3ctx-clear                      # back to normal AWS (e.g. real AWS accounts)
```

Tab-completion is set up for `s3ctx <TAB>` so you don't need to remember
exact context names. Since `AWS_ENDPOINT_URL` is honored by aws-cli >= 2.13
for every service call, all `aws` subcommands (not just `s3`) will target the
active Ceph endpoint until you run `s3ctx-clear` or switch contexts.

## Notes on machine-specific setup

A few things referenced by these dotfiles assume tools/paths that need to
exist independently on any machine this is installed on:

- **oh-my-zsh** (`~/.oh-my-zsh`) — install separately:
  https://github.com/ohmyzsh/ohmyzsh
- **miniconda** (`~/miniconda3`) — conda's init block only takes effect if
  installed at this path.
- **Rancher Desktop** (`~/.rd/bin`), **bun** (`~/.bun`), **pixi**
  (`~/.pixi/bin`) — each managed by their own installers; the PATH entries
  are inert if not installed.
- `~/dev/MDF/aws-token-refresh/profile-additions.source_me` is sourced only
  if present, since it comes from a separate project repo.
- `home/.config/zsh/ceph-s3.zsh` ships with placeholder
  `https://CHANGEME:PORT` endpoint URLs in `CEPH_S3_CONTEXTS` — fill in the
  real Ceph RGW endpoints for your profiles before using `s3ctx`.
- SSH keys referenced in `.ssh/config` and `.zshrc` (e.g. `~/.ssh/bengal.pem`,
  `~/.ssh/cloud.key`, `~/.ssh/gitlab2026`) are **not** part of this repo and
  must be provisioned separately — never commit private keys.
- `.gitconfig` still has a couple of hardcoded `/Users/bengal1/...` paths
  (`core.excludesfile`, `commit.template`) that assume the same username and
  that `~/.gitignore_global` / `~/.stCommitMsg` exist. Neither file was found
  on this machine when this repo was created, so they weren't included here.
  Worth revisiting if you rely on them.
