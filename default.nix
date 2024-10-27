{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/refs/tags/24.05.tar.gz") { } }:

pkgs.buildGoModule {
  pname = "fiber-nix";
  version = "0.0.1";

  src = ./.;

  vendorHash = null;

  meta = with pkgs.lib; {
    description = "Hello World Fiber API in Go";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
