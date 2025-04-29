{ pkgs, ... }:
{

  home.packages = (
    with pkgs;
    [
      babelfish # translate bash to fish
    ]
  );

  programs.fish = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      lA = "ls -lA";
      mkdir = "mkdir -p";
      clipp = "xclip -selection c -o $argv";
      clipc = "xclip -selection c $argv";
      myip = "curl -sSL ifconfig.me";

      # programs
      vim = "nvim";
    };

    shellAbbrs = {
      s = "sudo";
      rmf = "rm -rf";
      k = "kubectl";
      ts = "tailscale";
      tf = "terraform";
      lg = "lazygit";
      b = "bat";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gP = "git pull";
      gf = "git fetch";
      gl = "git log";
      glo = "git log --oneline";
    };

    plugins = [
      {
        name = "fzf";
        src = pkgs.fishPlugins.fzf.src;
      }
      {
        name = "z";
        src = pkgs.fishPlugins.z.src;
      }
      {
        name = "aws-completions";
        src = ./aws-completions;
      }
    ];
  };
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      # format = "$all$directory";
    };
  };

  programs.ghostty.enableFishIntegration = true;
}
