{ pkgs ? import <nixpkgs> { } }:
let
  pname = "testcontainers-desktop";
  version = "1.18.0";
  system = "x86_64-linux";
  src = pkgs.fetchurl {
    url = "https://github.com/vstuen/testcontainers-desktop-releases/releases/download/v${version}/${pname}-${version}-${system}.deb";
    hash = "sha256-p5/Jg1hnTk8ZG+JGG6pe8+dPOmTugigL9Tws+8o83iI=";
  };

  rpath = pkgs.lib.makeLibraryPath [ pkgs.xorg.libX11 ];
in
pkgs.stdenv.mkDerivation {
  inherit pname version system src;

  buildInputs = [ pkgs.xorg.libX11 ];
  nativeBuildInputs = with pkgs; [ dpkg autoPatchelfHook ];

  unpackPhase = ''
    dpkg -x $src .
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/applications
    cp ./opt/testcontainers-desktop/bin/testcontainers-desktop $out/bin/testcontainers-desktop
    cp -r ./usr/share $out/
  '';

  postFixup = ''
    substituteInPlace $out/share/applications/*.desktop --replace-fail /opt/testcontainers-desktop/bin $out/bin
  '';

  meta = with pkgs.lib; {
    description = "Testcontainers Desktop Client";
    homepage = "https://testcontainers.com/desktop/#linux";
    license = licenses.unfree;
    platforms = [ "${system}" ];
  };
}
