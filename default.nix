{ lib
, stdenv
, fetchurl
, cmake
, fetchFromGitHub
, pkg-config
, range-v3
, fmt
, pkgs
, ut ? pkgs.callPackage ./nix/ut.nix {}
, juce
, lld
, darwin
}:
let
  cpm = fetchurl {
    url = "https://github.com/cpm-cmake/CPM.cmake/releases/download/v0.38.6/CPM.cmake";
    hash = "sha256-EcP6XxuhTxXTHC+2PbyGKO4TPYHI12TKrZqNueC6ywc=";
  };
  myJuce = juce.overrideAttrs rec {
    version = "7.0.8";
    src = fetchFromGitHub {
      owner = "juce-framework";
      repo = "JUCE";
      rev = version;
      hash = "sha256-YjFw3s0D6e6Nj7ZsL6v5dWZ1GYt/q2IYOovxw9rCu6M=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cpm-demo";
  version = "unstable-2023-10-27";

  NIX_CFLAGS_LINK = lib.optionalString stdenv.isDarwin "-fuse-ld=lld";

  src = ./.;

  patchPhase = ''
    mkdir -p build/cmake
    cp -R --no-preserve=mode,ownership ${cpm} build/cmake/CPM_0.38.6.cmake
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv main $out/bin/main
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preCheck
    $out/bin/main
    runHook postCheck
  '';

  cmakeFlags = [
    "-DCPM_USE_LOCAL_PACKAGES=ON"
    "-DCPM_LOCAL_PACKAGES_ONLY=ON"
  ];

  buildInputs = [
    range-v3
    fmt
    ut
    myJuce
  ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Cocoa ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ] ++ lib.optionals stdenv.isDarwin [ lld ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/multivac61/cpm_demo";
    maintainers = with maintainers; [ matthewcroughan ];
    mainProgram = "main";
    platforms = platforms.all;
  };
}
