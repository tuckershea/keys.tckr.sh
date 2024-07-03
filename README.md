# keys.tckr.sh

A keyserver for my SSH keys.

## Is this the best way to do this?

No.

SWS publishes a 4MB image. Just copying our files on top of that
would be faster, simpler, smaller, and more cross-platform. This
repository is for my own experimentation.

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
