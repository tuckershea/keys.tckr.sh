# keys.tckr.sh

A keyserver for my SSH keys.

Visit `https://keys.tckr.sh` for general information and index.

This is a hobby project, aiming to be built reproducibly,
run inside and outside docker,
and to be as small and fast as possible.

## Usage

For development, run the app with `nix run .`. This is the suggested
platform for all development.

### Building Images

> [!NOTE]
> Building images may not work on
> Darwin due to Rust linking issues. Instead, develop the app
> natively, and images will be provided automatically upon PRing.

Export OCI images with these commands, which will
build an image and link it to `./result`. 

```sh
nix build .#ociImage-amd64
# or
nix build .#ociImage-arm64
```

You can then load the image with `docker load < result`.

## Features

- [x] Key server
- [ ] Provide keys as nix expressions
- [x] Native app
- [x] Docker image
- [x] Automatically populate tuckershea.cachix.org
- [x] Automatically publish docker image
- [x] Docker image
- [ ] Automatic PR change review
- [ ] Automatic checking for expired keys
