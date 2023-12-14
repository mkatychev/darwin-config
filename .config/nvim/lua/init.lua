local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "tyru/open-browser-github.vim", dependencies = "tyru/open-browser.vim" },
  { "tyru/open-browser.vim" },
  { "mattn/webapi-vim" },
  { "itchyny/vim-gitbranch" },
  { "dcharbon/vim-flatbuffers" },
  { "ARM9/arm-syntax-vim" },
  { "mtdl9/vim-log-highlighting" },
  { "tpope/vim-repeat" },
  { "tpope/vim-fugitive" },
  { "godlygeek/tabular" },
  { "sunaku/tmux-navigate" },
  { "majutsushi/tagbar", build = "brew install --HEAD universal-ctags/universal-ctags/universal-ctags" },
  { "L3MON4D3/LuaSnip" }, -- Snippets plugin
  { "gfanto/fzf-lsp.nvim" }, -- fzf for lsp
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-cmdline" },
  { "hrsh7th/cmp-nvim-lsp" }, -- LSP source for nvim-cmp
  { "hrsh7th/cmp-path" },
  { "hrsh7th/nvim-cmp" }, -- Autocompletion plugin
  { "jvgrootveld/telescope-zoxide" },
  { "natecraddock/telescope-zf-native.nvim" },
  { "neovim/nvim-lspconfig" }, -- Collection of configurations for built-in LSP client
  { "nvim-lua/plenary.nvim" },
  { "nvim-lua/popup.nvim" },
  { "nvim-lualine/lualine.nvim" },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  { "nvim-telescope/telescope-ui-select.nvim" },
  { "nvim-telescope/telescope.nvim" },
  { "nvim-treesitter/playground" },
  {
    "nvim-treesitter/nvim-treesitter",
    build = function() require("nvim-treesitter.install").update { with_sync = true } end,
  },
  { "ngalaiko/tree-sitter-go-template" },
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  { "IndianBoy42/tree-sitter-just" },
  { 'junegunn/fzf.vim' },
  { 'junegunn/fzf' },
  { "saadparwaiz1/cmp_luasnip" }, -- Snippets source for nvim-cmp
  { "MunifTanjim/rust-tools.nvim" },
  { "romgrk/barbar.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "navarasu/onedark.nvim" },
  { "akinsho/git-conflict.nvim", version = "*" },
  { "rcarriga/nvim-notify" },
  { "saecki/crates.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "numToStr/Comment.nvim" },
  -- use { "kylechui/nvim-surround", tag = "*" }
  { "echasnovski/mini.surround" },
  { "HiPhish/nvim-ts-rainbow2" },
  { "ggandor/leap.nvim" },
  { "nickel-lang/vim-nickel" },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "andymass/vim-matchup",
    init = function()
      -- may set any options here
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    config = function()
      require("neorg").setup {
        load = {
          ["core.defaults"] = {}, -- Loads default behaviour
          ["core.journal"] = {
            config = {
              strategy = "flat",
              workspace = "notes",
            },
          }, -- Loads default behaviour
          ["core.concealer"] = {}, -- Adds pretty icons to your documents
          ["core.dirman"] = { -- Manages Neorg workspaces
            config = {
              default_workspace = "notes",
              workspaces = {
                notes = "~/Documents/notes",
              },
            },
          },
        },
      }
    end,
    dependencies = "nvim-lua/plenary.nvim",
  },
}, {})

-- require('leap').add_default_mappings()
require("mini.surround").setup {
  -- Add custom surroundings to be used on top of builtin ones. For more
  -- information with examples, see `:h MiniSurround.config`.
  custom_surroundings = nil,

  -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
  highlight_duration = 500,

  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    add = "qa", -- Add surrounding in Normal and Visual modes
    delete = "qd", -- Delete surrounding
    find = "qf", -- Find surrounding (to the right)
    find_left = "qF", -- Find surrounding (to the left)
    highlight = "qh", -- Highlight surrounding
    replace = "qr", -- Replace surrounding
    update_n_lines = "qn", -- Update `n_lines`

    suffix_last = "l", -- Suffix to search with "prev" method
    suffix_next = "n", -- Suffix to search with "next" method
  },

  -- Number of lines within which surrounding is searched
  n_lines = 20,

  -- Whether to respect selection type:
  -- - Place surroundings on separate lines in linewise mode.
  -- - Place surroundings on each line in blockwise mode.
  respect_selection_type = false,

  -- How to search for surrounding (first inside current line, then inside
  -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
  -- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
  -- see `:h MiniSurround.config`.
  search_method = "cover",

  -- Whether to disable showing non-error feedback
  silent = false,
}
require("Comment").setup({
  toggler = {
        ---Line-comment toggle keymap
        line = '<M-/>',
        ---Block-comment toggle keymap
        block = '<M-?>',
    },
      opleader = {
        ---Line-comment keymap
        line = '<M-/>',
        ---Block-comment keymap
        block = '<M-?>',
    },

})
-- require("neorg").setup()
vim.opt.expandtab = true
vim.opt.hidden = true
vim.opt.mouse = "a"
vim.opt.laststatus = 1
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

vim.opt.relativenumber = true
vim.opt.number = true

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local command = vim.api.nvim_create_user_command

-- command('RgNew', h

-- RelNumInActiveNormalWindow
autocmd("InsertLeave", {
  callback = function() vim.opt.relativenumber = true end,
})
autocmd("InsertEnter", {
  callback = function() vim.opt.relativenumber = false end,
})
-- autocmd FileType myft let b:match_words = 'something:else'`
-- autocmd ("FileType", {
--   pattern = { 'nix' },
--   callback = function()
--     vim.b.match_words = 'let:in'
--   end
-- })

autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("PACKER", { clear = true }),
  pattern = "plugins.lua",
  command = "source <afile> | PackerCompile",
})
augroup("RelNumInActiveNormalWindow", { clear = true })
autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
  group = "RelNumInActiveNormalWindow",
  callback = function()
    if vim.bo.modifiable == true and vim.bo.readonly == false then vim.opt_local.relativenumber = true end
  end,
})

autocmd("WinLeave", {
  group = "RelNumInActiveNormalWindow",
  callback = function()
    if vim.bo.modifiable == true and vim.bo.readonly == false then vim.opt_local.relativenumber = false end
  end,
})
-- Remove whitespace on save
autocmd("BufWritePre", {
  pattern = "",
  command = ":%s/\\s\\+$//e",
})

-- Highlight on yank
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = "YankHighlight",
  callback = function() vim.highlight.on_yank { higroup = "IncSearch", timeout = "200" } end,
})

-- local autocmd = vim.api.nvim_create_autocmd   -- Create autocommand
-- autocmd BufNewFile,BufRead * if search('{{.\+}}', 'nw') | setlocal filetype=gotmpl | endif
-- autocmd('BufNewFile', {
--   pattern = {"*.yaml", "*.tpl"},
--   command = "if search('{{.\\+}}', 'nw') | setlocal filetype=gotmpl | endif"
-- callback = function()
--   if vim.fn.search('{{', 'nw') then
--     vim.opt_local.filetype="gotmpl"
--   end
-- end
-- })

-- co — choose ours
-- ct — choose theirs
-- cb — choose both
-- c0 — choose none
-- ]x — move to previous conflict
-- [x — move to next conflict
require("git-conflict").setup {
  default_mappings = true, -- disable buffer local mapping created by this plugin
  default_commands = true, -- disable commands created by this plugin
  disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
  highlights = { -- They must have background color, otherwise the default color will be used
    incoming = "DiffText",
    current = "DiffAdd",
  },
}

-- Set barbar's options
require("barbar").setup {
  -- Enable/disable animations
  animation = false,

  -- Enable/disable auto-hiding the tab bar when there is a single buffer
  auto_hide = false,

  -- Enable/disable current/total tabpages indicator (top right corner)
  tabpages = true,

  -- Excludes buffers from the tabline
  -- exclude_ft = {'javascript'},
  -- exclude_name = {'package.json'},

  icons = {
    -- Configure the base icons on the bufferline.
    buffer_index = true,
    buffer_number = false,
    button = false,
    -- Enables / disables diagnostic symbols
    diagnostics = {
      [vim.diagnostic.severity.ERROR] = { enabled = true },
      --   [vim.diagnostic.severity.WARN] = { enabled = false },
      --   [vim.diagnostic.severity.INFO] = { enabled = false },
      --   [vim.diagnostic.severity.HINT] = { enabled = true },
    },
    filetype = {
      -- Sets the icon's highlight group.
      -- If false, will use nvim-web-devicons colors
      custom_colors = true,

      -- Requires `nvim-web-devicons` if `true`
      enabled = false,
    },
    separator = { left = "▎", right = "" },

    -- Configure the icons on the bufferline when modified or pinned.
    -- Supports all the base icon options.
    modified = false,
    pinned = { button = "車", filename = true, separator = { right = "" } },

    -- Configure the icons on the bufferline based on the visibility of a buffer.
    -- Supports all the base icon options, plus `modified` and `pinned`.
    alternate = { filetype = { enabled = false } },
    current = { buffer_index = true },
    inactive = { button = "×" },
    visible = { modified = { buffer_number = false } },
  },

  -- If true, new buffers will be inserted at the start/end of the list.
  -- Default is to insert after current buffer.
  insert_at_end = false,
  insert_at_start = false,

  -- Sets the maximum padding width with which to surround each tab
  maximum_padding = 0,

  -- Sets the maximum buffer name length.
  maximum_length = 30,

  -- If set, the letters for each buffer in buffer-pick mode will be
  -- assigned based on their name. Otherwise or in case all letters are
  -- already assigned, the behavior is to assign letters in order of
  -- usability (see order below)
  semantic_letters = true,

  -- New buffer letters are assigned in this order. This order is
  -- optimal for the qwerty keyboard layout but might need adjustement
  -- for other layouts.
  letters = "asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP",

  -- Sets the name of unnamed buffers. By default format is "[Buffer X]"
  -- where X is the buffer number. But only a static string is accepted here.
  no_name_title = nil,
}

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
-- Move to previous/next
map("n", "<C-S-Tab>", "<Cmd>BufferPrevious<CR>", opts)
map("n", "<C-Tab>", "<Cmd>BufferNext<CR>", opts)

map("n", "<A-1>", "<Cmd>BufferGoto 1<CR>", opts)
map("n", "<A-2>", "<Cmd>BufferGoto 2<CR>", opts)
map("n", "<A-3>", "<Cmd>BufferGoto 3<CR>", opts)
map("n", "<A-4>", "<Cmd>BufferGoto 4<CR>", opts)
map("n", "<A-5>", "<Cmd>BufferGoto 5<CR>", opts)
map("n", "<A-6>", "<Cmd>BufferGoto 6<CR>", opts)
map("n", "<A-7>", "<Cmd>BufferGoto 7<CR>", opts)
map("n", "<A-8>", "<Cmd>BufferGoto 8<CR>", opts)
map("n", "<A-9>", "<Cmd>BufferGoto 9<CR>", opts)
map("n", "<A-0>", "<Cmd>BufferLast<CR>", opts)
map("n", "<A-p>", "<Cmd>BufferPin<CR>", opts)
map("n", "<A-S-p>", "<Cmd>BufferPick<CR>", opts)
-- Re-order to previous/next
map("n", "<A-<>", "<Cmd>BufferMovePrevious<CR>", opts)
map("n", "<A->>", "<Cmd>BufferMoveNext<CR>", opts)
-- Sort automatically by...
map("n", "<leader>1", "<Cmd>BufferOrderByBufferNumber<CR>", opts)
map("n", "<leader>q", "<Cmd>BufferOrderByDirectory<CR>", opts)
map("n", "<leader>a", "<Cmd>BufferOrderByLanguage<CR>", opts)
map("n", "<leader>z", "<Cmd>BufferOrderByWindowNumber<CR>", opts)

map("n", "<leader>cd", ":lua require'telescope'.extensions.zoxide.list{}<CR>", opts)

require("telescope").setup {
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
        -- even more opts
      },
    },
    ["zf-native"] = {
      -- options for sorting file-like items
      file = {
        -- override default telescope file sorter
        enable = true,
        -- highlight matching text in results
        highlight_results = true,
        -- enable zf filename match priority
        match_filename = true,
      },

      -- options for sorting all other items
      generic = {
        -- override default telescope generic item sorter
        enable = true,

        -- highlight matching text in results
        highlight_results = true,

        -- disable zf filename match priority
        match_filename = false,
      },
    },
  },
  defaults = {
    mappings = {
      i = {
        -- ["<C-v>"] = { ":set norenmuber nonumber<CR> <Esc>", type = "command" },
        ["<Esc>"] = require("telescope.actions").close,
        ["<C-a>"] = { "<Home>", type = "command" },
        ["<C-e>"] = { "<End>", type = "command" },
      },
    },
  },
  pickers = {
    find_files = {
      find_command = { "fd", "--type", "f", "--exclude", ".git", "--hidden", "--follow" },
    },
  },
}

-- | Token     | Match type                 | Description                          |
-- | --------- | -------------------------- | ------------------------------------ |
-- | `sbtrkt`  | fuzzy-match                | Items that match `sbtrkt`            |
-- | `'wild`   | exact-match (quoted)       | Items that include `wild`            |
-- | `^music`  | prefix-exact-match         | Items that start with `music`        |
-- | `.mp3$`   | suffix-exact-match         | Items that end with `.mp3`           |
-- | `!fire`   | inverse-exact-match        | Items that do not include `fire`     |
-- | `!^music` | inverse-prefix-exact-match | Items that do not start with `music` |
-- | `!.mp3$`  | inverse-suffix-exact-match | Items that do not end with `.mp3`    |
require("telescope").load_extension("ui-select")
require("telescope").load_extension("zf-native")

local luasnip = require("luasnip")
local cmp = require("cmp")
local lspconfig = require("lspconfig")

function _G.grep_string()
  require("telescope.builtin").grep_string {
    path_display = "smart",
    word_match = "-w",
    sort_only_text = false,
    search = "",
  }
end

function _G.live_grep()
  require("telescope.builtin").live_grep {
    disable_coordiantes = true,
  }
end

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

vim.diagnostic.config {
  underline = false,
  signs = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = false,
    source = "always",
  },
  virtual_text = {
    spacing = 4,
    source = "always",
    severity = {
      min = vim.diagnostic.severity.ERROR,
    },
  },
}

-- after the language server attaches to the current buffer
-- fzf_lspp
require("fzf_lsp").setup()

vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

local on_attach = function(client, bufnr)
  -- turn off lsp syntax highlighting
  client.server_capabilities.semanticTokensProvider = nil
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "<space>d", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, bufopts)

  vim.keymap.set("n", "gD", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n", "gr", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
  vim.keymap.set("n", "<space>r", vim.lsp.buf.references, bufopts)
  vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, bufopts)
  -- vim.keymap.set("n", "<space>f", function()
  --   vim.lsp.buf.format({ async = true })
  -- end, bufopts)
  vim.keymap.set("n", "<space>h", vim.lsp.buf.document_highlight, bufopts)
end

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require("rust-tools").setup {
  tools = {
    hover_with_actions = false,
    inlay_hints = {
      highlight = "Comment",
      max_len_align = false,
    },
    hover_actions = {
      border = nil,
    },
  },
  server = {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          buildScripts = { enable = true },
        },
        procMacro = { enable = true },
        check = {
          extraArgs = { "--target-dir", "/tmp/rust-analyzer-check" },
        },
        -- checkOnSave = {
        --   command = "check",
        --   extraArgs = { "--all" },
        -- },
      },
    },
  },
}

local servers = {
  rnix = {},
  tsserver = {},
  svelte = {},
  ccls = {},
  nickel_ls = {},
  -- rust_analyzer = {
  --   settings = {
  --     ["rust-analyzer"] = {
  --       cargo = { loadOutDirsFromCheck = true },
  --       procMacro = { enable = true },
  --       hover = { linksInHover = true },
  --     },
  --   },
  -- },
  -- gopls = {
  --   settings = {
  --     gopls = {
  --       linksInHover = false,
  --     },
  --   },
  -- },
  pyright = {},
  -- yamlls = {
  --   settings = {
  --     yaml = {
  --       schemas = {
  --         ["https://gist.githubusercontent.com/mkatychev/59065a932fa69be567380d724cecdd3f/raw/177e24f0cfdfcf102376dcf59fe0b867f1ebbf53/github-workflow.json"] = "/.github/workflows/*",
  --         ["https://json.schemastore.org/github-action.json"] = "/.github/actions/*",
  --       },
  --     },
  --   },
  -- },

  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        runtime = {
          version = "LuaJIT",
          path = runtime_path,
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = { enable = false },
      },
    },
  },
  bashls = {},
}

for server, cfg in pairs(servers) do
  local setup = {
    on_attach = on_attach,
    capabilities = capabilities,
  }
  for k, v in pairs(cfg) do
    setup[k] = v
  end
  lspconfig[server].setup(setup)
end

local lspkind_comparator = function(conf)
  local lsp_types = require("cmp.types").lsp
  return function(entry1, entry2)
    if entry1.source.name ~= "nvim_lsp" then
      if entry2.source.name == "nvim_lsp" then
        return false
      else
        return nil
      end
    end
    local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
    local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]

    local priority1 = conf.kind_priority[kind1] or 0
    local priority2 = conf.kind_priority[kind2] or 0
    if priority1 == priority2 then return nil end
    return priority2 < priority1
  end
end

local label_comparator = function(entry1, entry2) return entry1.completion_item.label < entry2.completion_item.label end

-- luasnip setup
cmp.setup {
  snippet = {
    expand = function(args) require("luasnip").lsp_expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert {
    ["<Up>"] = cmp.mapping.select_prev_item(),
    ["<Down>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ["<Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ["<S-Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = "buffer" },
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
    { name = "crates" },
  },
  sorting = {
    comparators = {
      lspkind_comparator {
        kind_priority = {
          Field = 11,
          Property = 11,
          Constant = 10,
          Enum = 10,
          EnumMember = 10,
          Event = 10,
          Function = 10,
          Method = 10,
          Operator = 10,
          Reference = 10,
          Struct = 10,
          Variable = 12,
          File = 8,
          Folder = 8,
          Class = 5,
          Color = 5,
          Module = 5,
          Keyword = 2,
          Constructor = 1,
          Interface = 1,
          Snippet = 0,
          Text = 1,
          TypeParameter = 1,
          Unit = 1,
          Value = 1,
        },
      },
      label_comparator,
    },
  },
}

-- cmp.setup.cmdline('/', {
-- sources = {
-- { name = 'buffer' }
-- }
-- })

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

require("treesitter")
require("tree-sitter-just").setup {}
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.gotmpl = {
  install_info = {
    url = "https://github.com/ngalaiko/tree-sitter-go-template",
    files = { "src/parser.c" },
  },
  filetype = "gotmpl",
  used_by = { "gohtmltmpl", "gotexttmpl", "gotmpl", "yaml" },
}

require("theme")

require("lualine").setup {
  options = {
    icons_enabled = true,
    theme = "onedark",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = false,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    },
  },
  sections = {
    lualine_a = {},
    lualine_b = {
      {
        "branch",
        max_length = vim.o.columns / 8,
        windows_color = {
          -- Same values as the general color option can be used here.
          active = "lualine_{section}_inactive", -- Color for active window.
          inactive = "lualine_{section}_inactive", -- Color for inactive window.
        },
      },
      { "filename", path = 1 },
    },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { "filename", path = 1 } },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {},
}

function dump(o)
  if type(o) == "table" then
    local s = "{ "
    for k, v in pairs(o) do
      if type(k) ~= "number" then k = '"' .. k .. '"' end
      s = s .. "[" .. k .. "] = " .. dump(v) .. ","
    end
    return s .. "} "
  else
    return tostring(o)
  end
end

local function preview_location_callback(_, method, result)
  print(dump(method))
  if result == nil or vim.tbl_isempty(result) then
    print(method, "No location found")
    return nil
  end
  vim.lsp.util.preview_location(method)
  if vim.tbl_islist(result) then
    print("islist")
    vim.lsp.util.preview_location(result[1])
  else
    print(dump(result))
    vim.lsp.util.preview_location(result)
  end
end

function peek_definition()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, "textDocument/typeDefinition", params, preview_location_callback)
end

vim.cmd([[nnoremap <silent> <<space>-D> <cmd>lua peek_definition()<CR>]])

function lsp_clients()
  local clients = vim.inspect(vim.lsp.get_active_clients())

  vim.api.nvim_command([[ new ]])
  vim.api.nvim_paste(clients, "", -1)
end

vim.api.nvim_create_user_command("OpenCargo", require("rust-tools").open_cargo_toml.open_cargo_toml, {})
local crates = require("crates")
crates.setup { disable_invalid_feature_diagnostic = true }
crates.toggle()
vim.keymap.set("n", "<leader>co", require("rust-tools").open_cargo_toml.open_cargo_toml, opts)
vim.keymap.set("n", "<leader>cf", crates.show_features_popup, opts)
vim.keymap.set("n", "<leader>cK", crates.show_crate_popup, opts)
vim.keymap.set("n", "<leader>cD", crates.show_dependencies_popup, opts)
vim.keymap.set("n", "<leader>ct", crates.toggle, opts)
vim.keymap.set("n", "<leader>cr", crates.reload, opts)
vim.keymap.set("n", "<leader>cv", crates.show_versions_popup, opts)
