# keys.tuckershea.com

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

You can then load them with `docker load < result`.

## Features

- [x] Key server
- [x] Nix packaging
- [ ] Keys as nix expressions
- [ ] Key installation script
- [x] Docker image
- [ ] Automatic checking for expired keys
