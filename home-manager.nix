{ pkgs, ...}:
{
  imports = [
    <home-manager/nixos>
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.users.jammus = { pkgs, ... }: {
    imports = [
      ./home/i3.nix
    ];
  };
}
