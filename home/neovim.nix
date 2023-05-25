{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      vim-surround
      nvim-web-devicons
      cmp-nvim-lsp
      cmp-buffer
      cmp-vsnip
      vim-vsnip
      cmp-path
      cmp-treesitter
      cmp-cmdline
      plenary-nvim
      conjure
      vim-jack-in
      vim-dispatch
      vim-dispatch-neovim
      vim-cursorword
      minimap-vim
      gruvbox-material
      vim-visual-multi
      lazygit-nvim
      dressing-nvim
      {
        plugin = nvim-tree-lua; type = "lua";
        config = ''
          require("nvim-tree").setup {

            sync_root_with_cwd = true,
            respect_buf_cwd = true,
            update_focused_file = {
              enable = true,
              update_root = true
            },
            tab = {
              sync = {
                open = true,
                close = true,
              }
            }
          }
        '';
      }
      {
        plugin = nvim-treesitter.withAllGrammars; type = "lua";
        config = ''
          require('nvim-treesitter.configs').setup {
              highlight = {
                  enable = true,
                  additional_vim_regex_highlighting = false,
              },
          }
        '';
      }
      {
        plugin = lazy-lsp-nvim; type = "lua";
        config = ''
          local capabilities = require('cmp_nvim_lsp').default_capabilities()
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
            vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
          end
          require('lazy-lsp').setup {
            -- By default all available servers are set up. Exclude unwanted or misbehaving servers.
            excluded_servers = {
              "ccls", "zk", 
              "move_analyzer",
              "erg_language_server",
              "ruby_ls",
              "neocmake",
              "jedi_language_server",
              "pyright",
              "denols",
              "sqls",
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
        '';
      }
      {
        plugin = nvim-cmp; type = "lua";
        config = ''
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

          cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
              { name = 'path' }
            }, {
              { name = 'cmdline' }
            })
          })

          cmp.setup.cmdline('/', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
              { name = 'buffer' }
            }
          })
        '';
      }
      { 
        plugin = telescope-nvim; type = "lua";
        config = ''
          require('telescope').setup({
            defaults = {
              layout_strategy = 'horizontal',
              layout_config = {
                vertical = { mirror = false },
                horizontal = {
                  preview_cutoff = 0,
                }
              },
            },
          })
        '';
      }
      {
        plugin = telescope-file-browser-nvim; type = "lua";
        config = ''
          require("telescope").load_extension "file_browser"
        '';
      }
      {
        plugin = which-key-nvim; type = "lua";
        config = ''
          -- Wrap single character key labels in square brackets eg, f becomes [f]
          local key_labels = {}
          for i=33,126 do
            key_labels[string.char(i)] = '[' .. string.char(i) .. ']'
          end
          key_labels["["] = ' [ '
          key_labels["]"] = ' ] '

          require("which-key").setup {
            icons = {
              group = "",
            },
            key_labels = key_labels,
            window = {
              winblend = 5,
            },
          }

        local wk = require("which-key")

        wk.register({
          e = { name = "Explorer...", 
            o = { "<cmd>NvimTreeFocus<cr>", "Open/Focus" },
            q = { "<cmd>NvimTreeClose<cr>", "Close" },
          },
        }, { prefix = "<leader>" })


        wk.register({
          p = { name = "Projects...", 
            o = { "<cmd>lua require('telescope').load_extension('projects').projects{}<cr>", "Open" },
          }
        }, { prefix = "<leader>" })

        wk.register({
          d = { name = "Diagnostics...", 
            f = { "<cmd>Telescope diagnostics<cr>", "Find diagnostics" },
            ["]"] = { vim.diagnostic.goto_next, "Next" },
            ["["] = { vim.diagnostic.goto_prev, "Previous" },
            s = { "<cmd>Trouble document_diagnostics<cr>", "Show diagnostics" },
            S = { "<cmd>Trouble workspace_diagnostics<cr>", "Show all diagnostics" },
        }
        }, { prefix = "<leader>" })

        wk.register({
          h = { "<cmd>Telescope help_tags<cr>", "Help" },
        }, { prefix = "<leader>" })

        wk.register({
          f = { name = "Find...", 
            f = { "<cmd>Telescope find_files<cr>", "Find file" },
            b = { "<cmd>Telescope buffers<cr>", "Find buffer" },
            d = { "<cmd>Telescope diagnostics<cr>", "Find diagnostics" },
            s = { "<cmd>Telescope lsp_document_symbols<cr>", "Find symbol" },
            S = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Find symbol in workspace" },
            g = { "<cmd>Telescope live_grep<cr>", "Find in file" },
            h = { "<cmd>Telescope oldfiles<cr>", "Find recently opened file" },
          }
        }, { prefix = "<leader>" })

        wk.register({
          T = { name = "Trouble...", 
            p = { "<cmd>Trouble document_diagnostics<cr>", "Problems" },
            P = { "<cmd>Trouble workspace_diagnostics<cr>", "Problems in workspace" },
            u = { "<cmd>Trouble lsp_references<cr>", "Usages" },
            d = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
            t = { "<cmd>TroubleToggle<cr>", "Toggle" },
          }
        }, { prefix = "<leader>" })

        wk.register({
          r = { name = "Refactor...", 
            n = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
            f = { "<cmd>lua vim.lsp.buf.format { async = true }<cr>", "Format" },
          }
        }, { prefix = "<leader>" })

        wk.register({
          m = { name = "Minimap...", 
            o = { "<cmd>Minimap<cr>", "Open" },
            q = { "<cmd>MinimapClose<cr>", "Close" },
          }
        }, { prefix = "<leader>" })


        wk.register({
          b = { name = "Buffers...", 
            ["]"] = { "<cmd>BufferLineCycleNext<cr>", "Next" },
            ["["] = { "<cmd>BufferLineCyclePrev<cr>", "Previous" },
            f = { "<cmd>Telescope buffers<cr>", "Find" },
            p = { "<cmd>BufferLinePick<cr>", "Pick" },
            q = { "<cmd>BufferLinePickClose<cr>", "Close" },
          }
        }, { prefix = "<leader>" })

        wk.register({
          t = { name = "Tabs...", 
            ["]"] = { "<cmd>tabnext<cr>", "Next" },
            ["["] = { "<cmd>tabprevious<cr>", "Previous" },
            n = { "<cmd>tabnew<cr>", "New" },
            o = { "<cmd>tabnew | Telescope find_files<cr>", "Open in new tab" },
            q = { "<cmd>tabclose<cr>", "Close" },
          }
        }, { prefix = "<leader>" })

        wk.register({
          g = { name = "Git...",
            g = { "<cmd>LazyGit<cr>", "LazyGit" },
            H = { name = "History...",
              f = { "<cmd>LazyGitFilterCurrentFile<cr>", "File" },
              a = { "<cmd>LazyGitFilter<cr>", "All" },
            },
            a = { name = "Annotate/Blame...",
              l = { "<cmd>Gitsigns blame_line full=true<cr>", "Line" },
              t = { "<cmd>Gitsigns toggle_current_line_blame<cr>", "Toggle" },
            },
            h = { name = "Hunk...",
              ["]"] = { "<cmd>Gitsigns next_hunk<cr>", "Next" },
              ["["] = { "<cmd>Gitsigns prev_hunk<cr>", "Previous" },
              s = { "<cmd>Gitsigns stage_hunk<cr>", "Stage" },
              u = { "<cmd>Gitsigns undo_stage_hunk<cr>", "Undo stage" },
              r = { "<cmd>Gitsigns reset_hunk<cr>", "Reset" },
            },
            b = { name = "Buffer...",
              s = { "<cmd>Gitsigns stage_buffer<cr>", "Stage" },
            }
          }
        }, { prefix = "<leader>" })
        '';
      }
      {
        plugin = lualine-nvim; type = "lua";
        config = ''
          vim.opt.showmode = false

          require('lualine').setup {
            options = {
              theme = 'gruvbox-material',
              disabled_filetypes = {
                statusline = {'NvimTree', 'Outline'}
              },
            },
          }
        '';
      }
      {
        plugin = trouble-nvim; type = "lua";
        config = ''
          require("trouble").setup {
            auto_jump = {"lsp_definitions"}
          }
        '';
      }
      {
        plugin = project-nvim; type = "lua";
        config = ''
        require("project_nvim").setup {
          detection_methods = { "lsp" },
        }
        require('telescope').load_extension('projects')
        '';
      }
      {
        plugin = nvim-autopairs; type = "lua";
        config = ''
          require("nvim-autopairs").setup {}
        '';
      }
      { 
        plugin = bufferline-nvim; type = "lua";
        config = ''
          require("bufferline").setup {
            options = {
              indicator = {
                style = "none",
              },
              offsets = {
                {
                  filetype = "NvimTree",
                  text = "File Explorer",
                  text_align = "center",
                },
                {
                  filetype = "minimap",
                  text = "Minimap",
                  text_align = "center",
                },
              }
            },
            highlights = {
              buffer_selected = {
                italic = false,
              }
            },
          }
        '';
      }
      {
        plugin = fidget-nvim; type = "lua";
        config = ''
          require("fidget").setup {
            text = {
              spinner = "dots",
            }
          }
        '';
      }
      {
        plugin = telescope-fzf-native-nvim; type = "lua";
        config = ''
          require('telescope').load_extension('fzf')
        '';
      }
      { 
        plugin = leap-nvim; type = "lua";
        config = ''
          require('leap').add_default_mappings()
        '';
      }
      {
        plugin = symbols-outline-nvim; type = "lua";
        config = ''
          require("symbols-outline").setup()
        '';
      }
      {
        plugin = scope-nvim; type = "lua";
        config = "require('scope').setup()";
      }
      {
        plugin = gitsigns-nvim; type = "lua";
        config = ''
          require('gitsigns').setup{
            signcolumn = true,
            numhl      = true,
            linehl     = true,
            word_diff  = false,
          }
        '';
      }
    ];
    extraConfig = ''
      nnoremap <SPACE> <Nop>
      let mapleader = " "
      let maplocalleader = ","

      set ignorecase

      set ruler
      set number
      set relativenumber

      set textwidth=80

      set autoindent expandtab tabstop=2 shiftwidth=2

      set splitright
      set splitbelow

      set termguicolors

      colorscheme gruvbox-material
      set background=dark

      nnoremap <leader><space> :noh<cr>

      " use tab to match bracket pairs
      nnoremap <tab> %
      vnoremap <tab> %

      augroup WrapLineInMarkdownFile
        autocmd!
        autocmd FileType md setlocal wrap
      augroup END


      let g:VM_maps = {}
      let g:VM_maps["Add Cursor Down"]    = '<C-S-j>'   " new cursor down
      let g:VM_maps["Add Cursor Up"]      = '<C-S-k>'   " new cursor up
    '';
  };
}
