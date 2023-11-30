{ lib
, stdenv
, cmake
, fetchFromGitHub
, pkg-config
, range-v3
, fmt
, microsoft-gsl
, pkgs
, ut ? pkgs.callPackage ./nix/ut.nix {}
, juce
, lld
, darwin
}:
let
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

  buildInputs = [
    range-v3
    fmt
    microsoft-gsl
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
