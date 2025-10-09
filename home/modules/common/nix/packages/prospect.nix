{ appimageTools, fetchurl }:
let
  pname = "prospect-mail";
  version = "0.5.4";

  src = fetchurl {
    url = "https://github.com/julian-alarcon/${pname}/releases/download/v${version}/${pname}-${version}.AppImage";
    hash = "sha256-gG9y2FDhLcJLeROWgbpMse5tRoT0niAMiaQE5yQPhGg=";
  };
  
  # Extract appImage to get icons and desktop file
  appimageContents = appimageTools.extract {
    inherit pname version src;
    postExtract = ''
      substituteInPlace $out/${pname}.desktop --replace 'Exec=AppRun' 'Exec=${pname}'
    '';
  };
in
appimageTools.wrapType2 {
  inherit pname version src;
  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/${pname}.png \
      $out/share/icons/hicolor/512x512/apps/${pname}.png
  '';
}
