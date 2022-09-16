{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      vim-surround
      nvim-tree-lua
      nvim-web-devicons
      (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
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

      lua << EOF
      require('nvim-treesitter.configs').setup {
          highlight = {
              enable = true,
              additional_vim_regex_highlighting = false,
          },
      }
      EOF
    '';
  };
}
