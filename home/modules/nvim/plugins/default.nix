{ inputs, ... }: {
  imports = [
    ./gitsigns.nix
    ./lsp.nix
    ./neo-tree.nix
    ./nix.nix
    ./nvim-colorizer.nix
    ./telescope.nix
    ./treesitter.nix
  ];
  programs.nixvim = {
    colorschemes.catppuccin.enable = true;

    # The performance option is not supported for 24.05
    performance.combinePlugins.standalonePlugins = [
      "nvim-treesitter"
    ];

    plugins = {
      lualine.enable = true;
      nvim-autopairs.enable = true;
      tmux-navigator.enable = true;
      web-devicons.enable = true;
      which-key.enable = true;
    };
  };
}
