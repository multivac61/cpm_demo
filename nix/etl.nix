{ lib
, stdenv
, fetchFromGitHub
, cmake
, meson
}:

stdenv.mkDerivation rec {
  pname = "etl";
  version = "20.38.5";

  src = fetchFromGitHub {
    owner = "ETLCPP";
    repo = "etl";
    rev = version;
    hash = "sha256-pevCBCACqSPx+mN0c91oF1HNBxggRcV7i7OaniJFaJs=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    meson
  ];

  meta = with lib; {
    description = "Embedded Template Library";
    homepage = "https://github.com/ETLCPP/etl.git";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
    mainProgram = "etl";
    platforms = platforms.all;
  };
}
