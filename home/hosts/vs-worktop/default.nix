{pkgs, ...}: {
  imports = [
    ../../modules/common
    ../../modules/gnome
    ../../modules/razerkb
  ];

  home.packages = with pkgs; [
      zoom-us # zoom client
  ];

  programs.fish.shellAliases = {
    aws-ssm-jump = "aws ssm start-session --target i-05e21e3029568146c --profile prod";
    aws-ssm-mw-prod1a = "aws --profile prod ssm start-session --target i-0d78cacc4d504f5e7";
    aws-ssm-mw-prod1b = "aws --profile prod ssm start-session --target i-06ed875e51781fc84";
    aws-ssm-mw-stage1a = "aws --profile prod ssm start-session --target i-08e12745863f8808d";
    aws-ssm-mw-stage1b = "aws --profile prod ssm start-session --target i-0afcde19138ed8b56";
    aws-ssm-mw-dev = "aws ssm start-session --target i-06a06589be878490b";
    aws-ssm-mw-qa = "aws ssm start-session --target i-0702419b41248b96e";
  };
}