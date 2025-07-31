{ pkgs, ... }: {
  home.packages = with pkgs; [
      jetbrains.rider
      dotnet-sdk
  ];

  home.sessionVariables = {
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
  };
}