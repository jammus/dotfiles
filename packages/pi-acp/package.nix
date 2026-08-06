{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  pi,
}:

buildNpmPackage rec {
  pname = "pi-acp";
  version = "0.0.33";

  src = fetchFromGitHub {
    owner = "svkozak";
    repo = "pi-acp";
    tag = "v${version}";
    hash = "sha256-fENOOdooi4XbIDjcr02q8qzUCzdo2IW/Bca43SawZ44=";
  };

  npmDepsHash = "sha256-/fX79XucKojL/6gZbK5eizEfrXso8rlTgiHfJffmDuY=";
  makeCacheWritable = true;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/pi-acp \
      --set-default PI_ACP_PI_COMMAND ${lib.getExe pi}
  '';

  meta = {
    description = "ACP adapter for the pi coding agent";
    homepage = "https://github.com/svkozak/pi-acp";
    changelog = "https://github.com/svkozak/pi-acp/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "pi-acp";
    platforms = lib.platforms.all;
  };
}
