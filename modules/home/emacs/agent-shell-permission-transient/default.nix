{ lib, trivialBuild, fetchFromGitHub, agent-shell, transient }:

trivialBuild {
  pname = "agent-shell-permission-transient";
  version = "0.2.0-unstable-2026-09-07";

  src = fetchFromGitHub {
    owner = "Jamie-Cui";
    repo = "agent-shell-permission-transient";
    rev = "02db0bc1155186ea61ea041f3945909697fa17d7";
    hash = "sha256-oURKHwckT0nGDbQ/I81LtVNRji4TKtoWFJ2gMF/q0lM=";
  };

  packageRequires = [ agent-shell transient ];

  meta = {
    description = "Transient menu for agent-shell permission requests";
    homepage = "https://github.com/Jamie-Cui/agent-shell-permission-transient";
    license = lib.licenses.gpl3Plus;
  };
}
