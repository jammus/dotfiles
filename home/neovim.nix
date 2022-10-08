{ pkgs, ... }:

let
  nvim-lazy-lsp = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "lazy-lsp.nvim";
    version = "2020.10.01";
    src = pkgs.fetchFromGitHub {
      owner = "dundalek";
      repo = "lazy-lsp.nvim";
      rev = "251b913596b66d9f87232f817a1c7d1a9c009a20";
      sha256 = "0sn7yk4xkychbwzrq3xihzm3m2vh5mll448ivk17zwq0qakzimv0";
    };
    meta.homepage = "https://github.com/dundalek/lazy-lsp.nvim";
  };
in
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
      nvim-lspconfig
      nvim-lazy-lsp
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
      require('lazy-lsp').setup {
        -- By default all available servers are set up. Exclude unwanted or misbehaving servers.
        excluded_servers = {
          "ccls", "zk", 
          "move_analyzer",
        },
        -- Default config passed to all servers to specify on_attach callback and other options.
        default_config = {
          flags = {
            debounce_text_changes = 150,
          },
          -- on_attach = on_attach,
          -- capabilities = capabilities,
        },
        -- Override config for specific servers that will passed down to lspconfig setup.
        configs = {
          sumneko_lua = {
            cmd = {"lua-language-server"},
            -- on_attach = on_lua_attach,
            -- capabilities = capabilities,
          },
        },
      }
      EOF
    '';
  };
}
