# Installation
```
nixos-rebuild switch --flake '.#' --use-remote-sudo  # linux
darwin-rebuild switch --flake '.#' # mac
```

# Updates
```
nix flake update nixpkgs home-manager darwin
nix flake update emacs-overlay emacs-overlay-doomsday nix-doom-emacs-unstraightened
```
