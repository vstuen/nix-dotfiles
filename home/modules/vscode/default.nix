{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        github.copilot
        github.copilot-chat
        jnoortheen.nix-ide
        k--kato.intellij-idea-keybindings
        marp-team.marp-vscode
        mkhl.direnv
        # ms-dotnettools.csharp
        ms-python.python
        ms-vscode-remote.remote-ssh
        tailscale.vscode-tailscale
        tamasfe.even-better-toml
      ];

      userSettings = {
        "explorer.confirmDelete" = false;
        "editor.fontFamily" = "'FiraCode Nerd Font Mono', 'monospace', monospace";
      };
    };
  };
}
