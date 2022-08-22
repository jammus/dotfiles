{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs; [
      vimPlugins.vim-nix
      vimPlugins.vim-surround
      vimPlugins.nvim-tree-lua
      vimPlugins.nvim-web-devicons
    ];
    extraConfig = ''
      let mapleader = ","

      set ignorecase

      set ruler
      set number
      set relativenumber

      set textwidth=80

      nnoremap <leader><space> :noh<cr>

      " use tab to match bracket pairs
      nnoremap <tab> %
      vnoremap <tab> %

      augroup WrapLineInMarkdownFile
        autocmd!
        autocmd FileType md setlocal wrap
      augroup END

      lua require("nvim-tree").setup()
      nnoremap <leader>f :NvimTreeFocus<cr>
      nnoremap <leader>F :NvimTreeToggle<cr>
    '';
  };
}
