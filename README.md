# keys.tckr.sh

> [!WARNING]
> This repository is for my own experimentation. It may not be
> entirely practical, but hey, it does produce tiny container images.
> I would not recommend building the OCI images for any platform
> other than your current platform. Instead, use the GHCR images.

A keyserver for my SSH keys.

## Usage

For development, run the app with `nix run .`.

Export OCI images with these commands, which will
build an image and link it to `./result`:

```sh
nix build .#ociImage-amd64
# or
nix build .#ociImage-arm64
```

You can then load the result with `docker load < result`.

## Features

- [x] Key server
- [x] Nix packaging
- [ ] Keys as nix expressions
- [ ] Key installation script
- [x] Docker image
- [ ] Automatic checking for expired keys
