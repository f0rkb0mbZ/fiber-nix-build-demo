# fiber-nix-build-demo
A sample repo to demonstrate how to build go package using Nix. Push a version tag like v*.*.* to trigger a nix build of a simple Hello, World! api built with Fiber, a web framework of Golang.

## Note
This repository is a part of my presentation titled, **"Building declarative and reproducible systems with Nix"**.

Find my slides here: [Slides Link](https://www.canva.com/design/DAGUjjoKwo0/0GhLy06L7R2BHBJDAuXCJw/view?utm_content=DAGUjjoKwo0&utm_campaign=designshare&utm_medium=link&utm_source=editor)

## Nix Cheatsheet

### Install Nix
```bash
# Works for Linux / Mac OS / Windows+WSL2
sh ‹(curl-L https://nixos.org/nix/install)
```
For docker install and more details, visit: https://nixos.org/download/

### Nix as a Package Manager
```bash
# Install a package
nix-env -iA nixpkgs.hello
# Install multiple packages
nix-env -iA nixpkgs.htop nixpkgs.sl ..
# List installed packages
nix-env -q
# Search for packages
nix-env -qaP '<search_term>'
# Update a package
nix-env -u 'python3'
# Update all packages
nix-env -u '*'
# Uninstall a package
nix-env -e htop
# Uninstall multple packages
nix-env -e htop python3
# Switch to / create new profile
nix-env --switch-profile <profile_name>
```
Check detailed documentation of nix-env here: https://nix.dev/manual/nix/2.17/command-ref/nix-env

### Declarative shells with Nix

`shell.nix`
```nix
{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  buildInputs = [
    pkgs.git
    pkgs.htop
    pkgs.sl
  ];
}
```
```bash
# Launch a temporary shell with dependencies
nix-shell -p git gcc
# Launch a shell with shell.nix in same folder
nix-shell
# Launch a shell with other nix files
nix-shell other_shell.nix
```
Check detailed documentation of nix-shell here:
https://nix.dev/manual/nix/2.17/command-ref/nix-shell

### Build packages with Nix

`hello.nix`
```nix
{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation {
  pname = "hello";
  version = "2.10";

  src = pkgs.fetchurl {
    url = "http://ftp.gnu.org/gnu/hello/hello-2.10.tar.gz";
    sha256 = "MeBmE3qWJnbon2nRt10C3pWn732RS4y5VvQepy4PUWs=";
  };

  buildInputs = [ pkgs.gcc ];

  meta = {
    description = "A program that produces a familiar, friendly greeting";
    license = pkgs.lib.licenses.gpl3;
  };
}
```
```bash
# Build the package
nix-build ./hello.nix
# Browse the package
cd./result/bin
# Run the program
•/hello
Hello, world!
```

### Version pinning with Nix
```bash
# Local file system version of nixpkgs
{ pkgs ? import <nixpkgs> {} }:
# Version pinning with tarball from tag of nixpkgs repo
pkgs? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/refs/tags/24.05.tar.gz") {} }:
# Version pinning with tarball from a commit hash of nixpkgs repo
{ pkgs? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/63dacb46bf939521bdc93981b4cbb7ecb58427a0.tar.gz") {} }:
```
Nix release channels:
https://status.nixos.org

Nixpkgs repository:
https://github.com/NixOS/nixpkgs

### Nix in GitHub Actions
```yml
name: CI

on:
  push:
    tags:
      - "v*.*.*"

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Nix
        uses: cachix/install-nix-action@v27

      - name: Build with Nix
        run: nix-build
```

### NixOS - the declarative OS
`/etc/nixos/configuration.nix`
```nix
{ config, pkgs, ... }:

{
  # Set the hostname
  networking.hostName = "my-nixos";

  # Enable the OpenSSH service
  services.openssh.enable = true;

  # Define users
  users.users.myuser = {
    isNormalUser = true;
    home = "/home/myuser";
    extraGroups = [ "wheel" ];  # Allow sudo access
  };

  # Install packages
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
  ];
}
```
