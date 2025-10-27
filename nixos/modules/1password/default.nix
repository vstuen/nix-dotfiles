{
  pkgs-unstable,
  username,
  ...
}:

{
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    package = pkgs-unstable._1password-gui;
    polkitPolicyOwners = [ username ];
  };

  environment.etc."1password/custom_allowed_browsers" = {
    text = ''
      .zen-beta-wrapped
      .zen-wrapped
      zen
      zen-beta
    '';
    mode = "0755";
  };
}
