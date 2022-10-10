{ pkgs, ... }:

let
  nvim-lazy-lsp = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "lazy-lsp.nvim";
    version = "2022.10.09";
    src = pkgs.fetchFromGitHub {
      owner = "dundalek";
      repo = "lazy-lsp.nvim";
      rev = "d1731da0751317eae2c2b6b591e5c7f0216fc654";
      sha256 = "0jd9lywj5q09ccrpmvf0566dx8wf7qbnkny86pwx4mw556zgzbmy";
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
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-vsnip
      cmp-path
      cmp-treesitter
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
      local opts = { noremap=true, silent=true }
      vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
      vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

      -- Use an on_attach function to only map the following keys
      -- after the language server attaches to the current buffer
      local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
      end
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
          "erg_language_server",
          "ruby_ls",
          "neocmake",
        },
        -- Default config passed to all servers to specify on_attach callback and other options.
        default_config = {
          flags = {
            debounce_text_changes = 150,
          },
          on_attach = on_attach,
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
