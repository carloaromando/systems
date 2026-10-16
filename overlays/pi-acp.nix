{ lib
, buildNpmPackage
, fetchFromGitHub
, makeWrapper
, runtimeNodejs
, pi-coding-agent
}:

# pinned to 0.0.31, the last release before pi 0.80 changed its rpc protocol.
# 0.0.33+ require pi >= 0.80.4, and nixpkgs only has pi 0.75.4 - with those the
# adapter answers `initialize` but never `session/new`, so agent-shell hangs on
# "Starting agent, please wait...". bump both together.
buildNpmPackage rec {
  pname = "pi-acp";
  version = "0.0.31";

  src = fetchFromGitHub {
    owner = "svkozak";
    repo = "pi-acp";
    rev = "v${version}";
    hash = "sha256-bM3V/3fxkY2Ib+OyfT82StIIRSLXGDuYUbt1CZKpTuo=";
  };

  npmDepsHash = "sha256-qN+b/tMbnJLkWjotl3XrA0nfZ3KT/mT6gM+n3Qiz8Wk=";

  nativeBuildInputs = [ makeWrapper ];

  # the adapter wants node >= 22 and spawns `pi` from PATH
  postInstall = ''
    rm $out/bin/pi-acp
    makeWrapper ${runtimeNodejs}/bin/node $out/bin/pi-acp \
      --add-flags $out/lib/node_modules/pi-acp/dist/index.js \
      --prefix PATH : ${lib.makeBinPath [ pi-coding-agent ]}
  '';

  meta = {
    description = "Agent Client Protocol adapter for the pi coding agent";
    homepage = "https://github.com/svkozak/pi-acp";
    license = lib.licenses.mit;
    mainProgram = "pi-acp";
  };
}
