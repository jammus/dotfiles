{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.4.1";
  assets = {
    x86_64-linux = {
      asset = "lightpanda-x86_64-linux";
      hash = "sha256-HUCAHnLAvGGyy9PzVivPxG3nt54FaPM/aGtk8uWHYQo=";
    };
  };
  info = assets.${stdenv.hostPlatform.system}
    or (throw "lightpanda: unsupported system ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "lightpanda";
  inherit version;

  src = fetchurl {
    url = "https://github.com/lightpanda-io/browser/releases/download/${version}/${info.asset}";
    hash = info.hash;
  };

  dontUnpack = true;
  nativeBuildInputs = [ autoPatchelfHook ];

  installPhase = ''
    install -Dm755 "$src" "$out/bin/lightpanda"
  '';

  meta = {
    description = "Headless browser designed for AI and automation";
    homepage = "https://github.com/lightpanda-io/browser";
    license = lib.licenses.agpl3Only;
    mainProgram = "lightpanda";
    platforms = [ "x86_64-linux" ];
  };
}
