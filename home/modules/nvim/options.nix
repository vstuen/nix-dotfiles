{ ... }: {
  programs.nixvim = {
    opts = {
      # Enable line numbers
      number = true;
      relativenumber = true;

      # Tab defaults (might get overwritten by an LSP server)
      tabstop = 4;
      shiftwidth = 4;
      softtabstop = 4;
      expandtab = true;
      smarttab = true;
    };
  };
}
