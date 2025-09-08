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
      nvim-parinfer
      lspkind-nvim
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
            --vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
            --vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
            --vim.keymap.set('n', '<space>wl', function()
              --print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            --end, bufopts)
            vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
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
            preferred_servers = {
              python = { "basedpyright"}
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
          local lspkind = require('lspkind')
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
              ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            }),
            sources = cmp.config.sources({
              -- { name = "copilot", group_index = 2 },
              { name = 'nvim_lsp' },
              { name = 'vsnip' },
            }, {
              { name = 'buffer' },
            }),
            formatting = {
              format = lspkind.cmp_format({
                mode = "symbol_text",
                max_width = 50,
                -- symbol_map = { Copilot = " " }
              })
            },
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
          require("which-key").setup {
            icons = {
              group = "",
            },
            win = {
              wo = {
                winblend = 5,
              },
            },
          }

        local wk = require("which-key")

        wk.add({
          { "<leader>e", group = "Explorer..." }, 
          { "<leader>eo", "<cmd>NvimTreeFocus<cr>", desc = "Open/Focus" }, 
          { "<leader>eq", "<cmd>NvimTreeClose<cr>", desc = "Close" }, 
        })

        wk.add({
          { "<leader>c", group = "Code..." },
          { "<leader>ca", vim.lsp.buf.code_action, desc = "Action" },
          -- { "<leader>cc", "<cmd>CopilotChatOpen<cr>", desc = "Copilot chat" },
        })

        wk.add({
          {
            mode = { "v" },
            { "<leader>c", group = "Code..." },
            { "<leader>ca", vim.lsp.buf.code_action, desc = "Action" },
          },
        })

        wk.add({
          { "<leader>d", group = "Diagnostics..." },
          { "<leader>dS", "<cmd>Trouble diagnostics toggle<cr>", desc = "Show all diagnostics" },
          { "<leader>d[", vim.diagnostic.goto_prev, desc = "Previous" },
          { "<leader>d]", vim.diagnostic.goto_next, desc = "Next" },
          { "<leader>df", "<cmd>Telescope diagnostics<cr>", desc = "Find diagnostics" },
          { "<leader>ds", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Show diagnostics" },
        })

        wk.add({
          { "<leader>h", "<cmd>Telescope help_tags<cr>", desc = "Help" },
        })

        wk.add({
          { "<leader>f", group = "Find..." },
          { "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Find symbol in workspace" },
          { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffer" },
          { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Find diagnostics" },
          { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find file" },
          { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Find in file" },
          { "<leader>fh", "<cmd>Telescope oldfiles<cr>", desc = "Find recently opened file" },
          { "<leader>fo", "<cmd>ObsidianQuickSwitch<cr>", desc = "Find Obsidian file" },
          { "<leader>fr", "<cmd>Telescope lsp_references<cr>", desc = "Find references" },
          { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Find symbol" },
        })

        wk.add({
          { "<leader>T", group = "Trouble..." },
          { "<leader>TP", "<cmd>Trouble diagnostics toggle<cr>", desc = "Problems in workspace" },
          { "<leader>Td", "<cmd>Trouble lsp_definitions<cr>", desc = "Definitions" },
          { "<leader>Tp", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Problems" },
          { "<leader>Tu", "<cmd>Trouble lsp_references<cr>", desc = "Usages" },
        })

        wk.add({
          { "<leader>r", group = "Refactor..." },
          { "<leader>rf", "<cmd>lua vim.lsp.buf.format { async = true }<cr>", desc = "Format" },
          { "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
        })

        wk.add({
          {
            mode = { "v" },
            { "<leader>r", group = "Refactor..." },
            { "<leader>re", group = "Extract..." },
            { "<leader>ref", "<cmd>lua require('refactoring').refactor('Extract Function')<cr>", desc = "Function" },
          },
        })

        wk.add({
          { "<leader>s", group = "Spelling..." },
          { "<leader>ss", "<cmd>Telescope spell_suggest<cr>", desc = "Suggestions" },
        })

        wk.add({
          { "<leader>m", group = "Minimap..." },
          { "<leader>mo", "<cmd>Minimap<cr>", desc = "Open" },
          { "<leader>mq", "<cmd>MinimapClose<cr>", desc = "Close" },
        })


        wk.add({
          { "<leader>b", group = "Buffers..." },
          { "<leader>b[", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous" },
          { "<leader>b]", "<cmd>BufferLineCycleNext<cr>", desc = "Next" },
          { "<leader>bf", "<cmd>Telescope buffers<cr>", desc = "Find" },
          { "<leader>bp", "<cmd>BufferLinePick<cr>", desc = "Pick" },
          { "<leader>bq", "<cmd>BufferLinePickClose<cr>", desc = "Close" },
        })

        wk.add({
          { "<leader>t", group = "Tabs..." },
          { "<leader>t[", "<cmd>tabprevious<cr>", desc = "Previous" },
          { "<leader>t]", "<cmd>tabnext<cr>", desc = "Next" },
          { "<leader>tn", "<cmd>tabnew<cr>", desc = "New" },
          { "<leader>to", "<cmd>tabnew | Telescope find_files<cr>", desc = "Open in new tab" },
          { "<leader>tq", "<cmd>tabclose<cr>", desc = "Close" },
        })

        wk.add({
          { "<leader>g", group = "Git..." },
          { "<leader>gH", group = "History..." },
          { "<leader>gHa", "<cmd>LazyGitFilter<cr>", desc = "All" },
          { "<leader>gHf", "<cmd>LazyGitFilterCurrentFile<cr>", desc = "File" },
          { "<leader>ga", group = "Annotate/Blame..." },
          { "<leader>gal", "<cmd>Gitsigns blame_line full=true<cr>", desc = "Line" },
          { "<leader>gat", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle" },
          { "<leader>gb", group = "Buffer..." },
          { "<leader>gbs", "<cmd>Gitsigns stage_buffer<cr>", desc = "Stage" },
          { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
          { "<leader>gh", group = "Hunk..." },
          { "<leader>gh[", "<cmd>Gitsigns prev_hunk<cr>", desc = "Previous" },
          { "<leader>gh]", "<cmd>Gitsigns next_hunk<cr>", desc = "Next" },
          { "<leader>ghr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset" },
          { "<leader>ghs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage" },
          { "<leader>ghu", "<cmd>Gitsigns undo_stage_hunk<cr>", desc = "Undo stage" },
        })

        wk.add({
          { "<leader>w", group = "Window..." },
          { "<leader>wq", "<cmd>close<cr>", desc = "Close" },
          { "<leader>wr", "<cmd>lua require('smart-splits').start_resize_mode()<cr>", desc = "Resize" },
        })

        wk.add({
          { "<leader>o", group = "Obsidian..." },
          { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Backlinks" },
          { "<leader>od", group = "Daily..." },
          { "<leader>od[", "<cmd>ObsidianToday -1<cr>", desc = "Previous" },
          { "<leader>od]", "<cmd>ObsidianToday +1<cr>", desc = "Next" },
          { "<leader>odt", "<cmd>ObsidianToday<cr>", desc = "Today" },
          { "<leader>odw", group = "Working day..." },
          { "<leader>odw[", "<cmd>ObsidianYesterday<cr>", desc = "Previous" },
          { "<leader>odw]", "<cmd>ObsidianTomorrow<cr>", desc = "Next" },
          { "<leader>of", "<cmd>ObsidianFollowLink<cr>", desc = "Follow" },
          { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New" },
          { "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>", desc = "Open" },
          { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search" },
          { "<leader>ow", "<cmd>ObsidianWorkspace<cr>", desc = "Workspace" },
        })

        wk.add({
          {
            mode = { "v" },
            { "<leader>o", group = "Obsidian..." },
            { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Backlinks" },
            { "<leader>ol", "<cmd>ObsidianLink<cr>", desc = "Link" },
            { "<leader>on", "<cmd>ObsidianLinkNew<cr>", desc = "New" },
            { "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "Open" },
          },
        })
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
        plugin = smart-splits-nvim; type = "lua";
        config = ''
        require('smart-splits').setup({
          resize_mode = {
            -- key to exit persistent resize mode
            quit_key = '<ESC>',
            -- keys to use for moving in resize mode
            -- in order of left, down, up' right
            resize_keys = { 'h', 'j', 'k', 'l' },
            -- set to true to silence the notifications
            -- when entering/exiting persistent resize mode
            silent = true,
            -- must be functions, they will be executed when
            -- entering or exiting the resize mode
            hooks = {
              on_enter = nil,
              on_leave = nil,
            },
          }
        })
        '';
      }
      {
        plugin = obsidian-nvim; type = "lua";
        config = ''
          require('obsidian').setup {
            workspaces = {
              {
                name = "nb",
                path = "~/nb",
                overrides = {
                  daily_notes = {
                    folder = "notes/dailies/",
                  },
                  notes_subdir = "notes",
                },
              },
            },

    -- Optional, set the log level for Obsidian. This is an integer corresponding to one of the log
    -- levels defined by "vim.log.levels.*" or nil, which is equivalent to DEBUG (1).
    log_level = vim.log.levels.INFO,

    daily_notes = {
      -- Optional, if you keep daily notes in a separate directory.
      folder = "dailies/",
      -- Optional, if you want to change the date format for daily notes.
      date_format = "%Y-%m-%d",
      alias_format = "%B %-d, %Y"
    },

    new_notes_location = "notes_subdir",

    note_frontmatter_func = function(note)
      -- Add the title of the note as an alias.
      if note.title then
        note:add_alias(note.title)
      end

      local out = { id = note.id, aliases = note.aliases, tags = note.tags }

      -- `note.metadata` contains any manually added fields in the frontmatter.
      -- So here we just make sure those fields are kept in the frontmatter.
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end

      return out
    end,

    -- Optional, completion.
    completion = {
      -- If using nvim-cmp, otherwise set to false
      nvim_cmp = true,
      -- Trigger completion at 2 chars
      min_chars = 2,
      -- Where to put new notes created from completion. Valid options are
      --  * "current_dir" - put new notes in same directory as the current buffer.
      --  * "notes_subdir" - put new notes in the default notes subdirectory.
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
      return suffix
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
        ["-"] = { char = "󰡖", hl_group = "ObsidianTodoPartial" },
        [">"] = { char = "", hl_group = "ObsidianRightArrow" },
        ["o"] = { char = "󰜺", hl_group = "ObsidianTodoCancel" },
      },
      hl_groups = {
        -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
        ObsidianExtLinkIcon = { fg = "#d8a657" },
        ObsidianRefText = { underline = true, fg = "#d8a657" },
        ObsidianBullet = { bold = true, fg = "#7c6f64" },
        ObsidianDone = { fg = "#a9b665" },
        ObsidianTodoCancel = { fg = "#ea6962" },
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

      set exrc

      colorscheme gruvbox-material
      set background=dark

      nnoremap <leader><space> :noh<cr>

      " use tab to match bracket pairs
      nnoremap <tab> %
      vnoremap <tab> %

      augroup WrapLineInMarkdownFile
        autocmd!
        autocmd FileType markdown setlocal nowrap
        autocmd FileType markdown setlocal conceallevel=2
      augroup END


      let g:VM_maps = {}
      let g:VM_maps["Add Cursor Down"]    = '<C-S-j>'   " new cursor down
      let g:VM_maps["Add Cursor Up"]      = '<C-S-k>'   " new cursor up
    '';
  };
}
