{
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;

      nixvimInjections = true;

      settings = {
        highlight.enable = true;
        indent.enable = true;
      };
      folding = false;
    };

    treesitter-refactor = {
      enable = true;
      highlightDefinitions = {
        enable = true;
        # Set to false if you have an `updatetime` of ~100.
        clearOnCursorMove = false;
      };
    };
    # produces error:
    # error: collision between `/nix/store/9dd6ncx3krks4c917mywhg6d84v0lhvx-vimplugin-hmts.nvim-2024-09-26/queries/nix/injections.scm' and `/nix/store/1wjaipn8yd0y2pjphmcnprqb70rid73g-vimplugin-treesitter-grammar-nix/queries/nix/injections.scm'
    # hmts.enable = true;
  };
}