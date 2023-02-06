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
      (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
      nvim-web-devicons
      lazy-lsp-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-vsnip
      cmp-path
      cmp-treesitter
      telescope-nvim
      plenary-nvim
      conjure
      vim-jack-in
      vim-dispatch-neovim
      gruvbox
    ];
    extraConfig = ''
      let mapleader = ","
      let maplocalleader = "_"

      set ignorecase

      set ruler
      set number
      set relativenumber

      set textwidth=80

      set autoindent expandtab tabstop=4 shiftwidth=4

      set splitright
      set splitbelow

      set termguicolors

      colorscheme gruvbox
      set background=dark

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

      -- Set up nvim-cmp.
      local cmp = require'cmp'

      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
          end,
        },
        window = {
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'vsnip' },
        }, {
          { name = 'buffer' },
        })
      })
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

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
            capabilities = capabilities,
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
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', 'ff', builtin.find_files, {})
      vim.keymap.set('n', 'fg', builtin.live_grep, {})
      vim.keymap.set('n', 'fb', builtin.buffers, {})
      vim.keymap.set('n', 'fh', builtin.help_tags, {})
      EOF
    '';
  };
}
