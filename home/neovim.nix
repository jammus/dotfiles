{ pkgs, ... }:
let obsidian-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "obisidan.nvim";
    version = "v2.7.0";
    src = pkgs.fetchFromGitHub {
      owner = "epwalsh";
      repo = "obsidian.nvim";
      rev = "v2.7.0";
      sha256 = "sha256-D+4OO6oingy2iOaMtMFryr0pY6Mi3YzpZN8T4K1gXZ0=";
    };
    meta.homepage = "https://github.com/epwalsh/obsidian.nvim";
    dependencies = [
      pkgs.vimPlugins.plenary-nvim
    ];
  };
  nvlime = pkgs.vimUtils.buildVimPlugin {
    pname = "nvlime";
    version = "v0.5.0rc";
    src = pkgs.fetchFromGitHub {
      owner = "monkoose";
      repo ="nvlime";
      rev = "83606f7e2d017ee7fcafe4ed4bf91ac776705633";
      sha256 = "sha256-UXx2b08C342brANMRVyX2yh3RFlF1zI0i9cXoC+6jFQ=";
    };
    dependencies = [
    ];
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
      copilot-vim
      nvlime
      # nfnl  -- just waiting for a PR to be merged
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
              "marksman",
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
              ltex = {
                settings = {
                  ltex =  {
                    language = "en-GB"
                  },
                },
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
            o = { "<cmd>ObsidianQuickSwitch<cr>", "Find Obsidian file" },
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
          r = { name = "Refactor...", 
            e = { name = "Extract...",
              f = { "<cmd>lua require('refactoring').refactor('Extract Function')<cr>", "Function" },
            },
          }
        }, { prefix = "<leader>", mode = "v" })

        wk.register({
          s = { name = "Spelling...",
            s = { "<cmd>Telescope spell_suggest<cr>", "Suggestions" },
          },
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

        wk.register({
          w = { name = "Window...",
            q = { "<cmd>close<cr>", "Close" },
          }
        }, { prefix = "<leader>" })

        wk.register({
          o = { name = "Obsidian...",
            n = { "<cmd>ObsidianNew<cr>", "New" },
            f = { "<cmd>ObsidianFollowLink<cr>", "Follow" },
            o = { "<cmd>ObsidianOpen<cr>", "Open" },
            b = { "<cmd>ObsidianBacklinks<cr>", "Backlinks" },
            s = { "<cmd>ObsidianSearch<cr>", "Search" },
            d = { name = "Daily...",
              t = { "<cmd>ObsidianToday<cr>", "Today" },
              w = { name = "Working day...",
                p = { "<cmd>ObsidianYesterday<cr>", "Previous" },
                n = { "<cmd>ObsidianTomorrow<cr>", "Next" },
              },
              p = { "<cmd>ObsidianToday -1<cr>", "Previous" },
              n = { "<cmd>ObsidianToday +1<cr>", "Next" },
            }
          }
        }, { prefix = "<leader>" })

        wk.register({
          o = { name = "Obsidian...",
            n = { "<cmd>ObsidianLinkNew<cr>", "New" },
            l = { "<cmd>ObsidianLink<cr>", "Link" },
            o = { "<cmd>ObsidianOpen<cr>", "Open" },
            b = { "<cmd>ObsidianBacklinks<cr>", "Backlinks" },
          }
        }, { prefix = "<leader>", mode = 'v' })
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
            linehl     = false,
            word_diff  = false,
          }
        '';
      }
      {
        plugin = refactoring-nvim; type = "lua";
        config = ''
          require('refactoring').setup({})
          require("telescope").load_extension("refactoring")
        '';
      }
      {
        plugin = obsidian-nvim; type = "lua";
        config = ''
          require('obsidian').setup {
    dir = "~/nb",  -- no need to call 'vim.fn.expand' here

    -- Optional, if you keep notes in a specific subdirectory of your vault.
    notes_subdir = "notes",

    -- Optional, set the log level for Obsidian. This is an integer corresponding to one of the log
    -- levels defined by "vim.log.levels.*" or nil, which is equivalent to DEBUG (1).
    log_level = vim.log.levels.DEBUG,

    daily_notes = {
      -- Optional, if you keep daily notes in a separate directory.
      folder = "notes/dailies",
      -- Optional, if you want to change the date format for daily notes.
      date_format = "%Y-%m-%d"
    },

    -- Optional, completion.
    completion = {
      -- If using nvim-cmp, otherwise set to false
      nvim_cmp = true,
      -- Trigger completion at 2 chars
      min_chars = 2,
      -- Where to put new notes created from completion. Valid options are
      --  * "current_dir" - put new notes in same directory as the current buffer.
      --  * "notes_subdir" - put new notes in the default notes subdirectory.
      new_notes_location = "notes_subdir"
    },

    -- Optional, customize how names/IDs for new notes are created.
    note_id_func = function(title)
      -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
      -- In this case a note with the title 'My new note' will given an ID that looks
      -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
      local suffix = ""
      if title ~= nil then
        -- If title is given, transform it into valid file name.
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        -- If title is nil, just add 4 random uppercase letters to the suffix.
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return tostring(os.time()) .. "-" .. suffix
    end,

    -- Optional, set to true if you don't want Obsidian to manage frontmatter.
    disable_frontmatter = false,

    -- Optional, for templates (see below).
    templates = {
      subdir = "templates",
      date_format = "%Y-%m-%d-%a",
      time_format = "%H:%M",
    },

    -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
    -- URL it will be ignored but you can customize this behavior here.
    follow_url_func = function(url)
      -- Open the URL in the default web browser.
      vim.fn.jobstart({"open", url})  -- Mac OS
      -- vim.fn.jobstart({"xdg-open", url})  -- linux
    end,

    -- Optional, set to true if you use the Obsidian Advanced URI plugin.
    -- https://github.com/Vinzent03/obsidian-advanced-uri
    use_advanced_uri = true,

    -- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
    open_app_foreground = false,

    -- Optional, by default commands like `:ObsidianSearch` will attempt to use
    -- telescope.nvim, fzf-lua, and fzf.nvim (in that order), and use the
    -- first one they find. By setting this option to your preferred
    -- finder you can attempt it first. Note that if the specified finder
    -- is not installed, or if it the command does not support it, the
    -- remaining finders will be attempted in the original order.
    finder = "telescope.nvim",

    ui = {
      enable = true,
      checkboxes = {
        -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
        ["x"] = { char = "", hl_group = "ObsidianDone" },
        ["-"] = { char = "󰡖", hl_group = "ObsidianTodo" },
        [">"] = { char = "", hl_group = "ObsidianRightArrow" },
        ["~"] = { char = "󱋭", hl_group = "ObsidianTilde" },
      },
      hl_groups = {
        -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
        ObsidianExtLinkIcon = { fg = "#d8a657" },
        ObsidianRefText = { underline = true, fg = "#d8a657" },
        ObsidianBullet = { bold = true, fg = "#7daea3" },
        ObsidianDone = { fg = "#a9b665" },
      },
    },
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
        autocmd FileType markdown setlocal nowrap
        autocmd FileType markdown setlocal conceallevel=1
      augroup END


      let g:VM_maps = {}
      let g:VM_maps["Add Cursor Down"]    = '<C-S-j>'   " new cursor down
      let g:VM_maps["Add Cursor Up"]      = '<C-S-k>'   " new cursor up
    '';
  };
}
