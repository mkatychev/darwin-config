local use = require("packer").use
require("packer").startup(function()
  use("L3MON4D3/LuaSnip") -- Snippets plugin
  use("gfanto/fzf-lsp.nvim") -- fzf for lsp
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/cmp-cmdline")
  use("hrsh7th/cmp-nvim-lsp") -- LSP source for nvim-cmp
  use("hrsh7th/cmp-path")
  use("hrsh7th/nvim-cmp") -- Autocompletion plugin
  use("jvgrootveld/telescope-zoxide")
  use("kyazdani42/nvim-tree.lua")
  use("natecraddock/telescope-zf-native.nvim")
  use("neovim/nvim-lspconfig") -- Collection of configurations for built-in LSP client
  use("nvim-lua/plenary.nvim")
  use("nvim-lua/popup.nvim")
  use("nvim-lualine/lualine.nvim")
  use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
  use("nvim-telescope/telescope-ui-select.nvim")
  use("nvim-telescope/telescope.nvim")
  use("nvim-treesitter/playground")
  use({
    "nvim-treesitter/nvim-treesitter",
    run = function()
      require("nvim-treesitter.install").update({ with_sync = true })
    end,
  })
  use("nvim-treesitter/nvim-treesitter-textobjects")
  use("saadparwaiz1/cmp_luasnip") -- Snippets source for nvim-cmp
  use("simrat39/rust-tools.nvim")
  use("wbthomason/packer.nvim")
  use("nanotee/sqls.nvim")
  use({
    "romgrk/barbar.nvim",
    requires = { "kyazdani42/nvim-web-devicons" },
  })
  -- use("olimorris/onedarkpro.nvim")
end)

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

-- Set barbar's options
require("bufferline").setup({
  -- Enable/disable animations
  animation = false,

  -- Enable/disable auto-hiding the tab bar when there is a single buffer
  auto_hide = false,

  -- Enable/disable current/total tabpages indicator (top right corner)
  tabpages = true,

  -- Enable/disable close button
  closable = true,

  -- Enables/disable clickable tabs
  --  - left-click: go to buffer
  --  - middle-click: delete buffer
  clickable = true,

  -- Excludes buffers from the tabline
  -- exclude_ft = {'javascript'},
  -- exclude_name = {'package.json'},

  -- Enable/disable icons
  -- if set to 'numbers', will show buffer index in the tabline
  -- if set to 'both', will show buffer index and icons in the tabline
  icons = "numbers",

  -- If set, the icon color will follow its corresponding buffer
  -- highlight group. By default, the Buffer*Icon group is linked to the
  -- Buffer* group (see Highlighting below). Otherwise, it will take its
  -- default value as defined by devicons.
  icon_custom_colors = false,

  -- Configure icons on the bufferline.
  icon_separator_active = "▎",
  icon_separator_inactive = "▎",
  icon_close_tab = "",
  icon_close_tab_modified = "●",
  icon_pinned = "車",

  -- If true, new buffers will be inserted at the start/end of the list.
  -- Default is to insert after current buffer.
  insert_at_end = false,
  insert_at_start = false,

  -- Sets the maximum padding width with which to surround each tab
  maximum_padding = 1,

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
})

require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "auto",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = { { "filename", path = 1 } },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {},
})

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

local nvim_tree_events = require("nvim-tree.events")
local bufferline_state = require("bufferline.state")

local function get_tree_size()
  return require("nvim-tree.view").View.width
end

nvim_tree_events.subscribe("TreeOpen", function()
  bufferline_state.set_offset(get_tree_size())
end)

nvim_tree_events.subscribe("Resize", function()
  bufferline_state.set_offset(get_tree_size())
end)

nvim_tree_events.subscribe("TreeClose", function()
  bufferline_state.set_offset(0)
end)

require("telescope").setup({
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({
        -- even more opts
      }),
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
})

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

-- require("colorizer").setup()
-- local onedarkpro = require("onedarkpro")
-- onedarkpro.setup({
--   -- Theme can be overwritten with 'onedark' or 'onelight' as a string!
--   theme = function()
--     if vim.o.background == "dark" then
--       return "onedark"
--     else
--       return "onelight"
--     end
--   end,
--   colors = {
--     onedark = {
--       blue = "#52b1ff",
--       fg = "#d3d6d9",
--     },
--   }, -- Override default colors. Can specify colors for "onelight" or "onedark" themes by passing in a table
--   hlgroups = {
--     LineNr = { fg = "#f2bf93", bg = "#230f38" },
--     CursorLineNr = { fg = "${black}", bg = "#d3d6d9" },
--     Normal = { bg = "#1d2025" },
--     Title = { fg = "#56b6c2" },
--     ErrorMsg = { fg = "#d73a49" },
--     TSConstBuiltin = { fg = "#56b6c2" },
--     TSOperator = { fg = "${purple}" },
--     TSFuncMacro = { fg = "${purple}" },
--     TSPunctDelimiter = { fg = "#d3d6d9" },
--     TSField = { fg = "#a4c8d5"},
--   }, -- Override default highlight groups
--   plugins = { -- Override which plugins highlight groups are loaded
--     native_lsp = true,
--     polygot = false,
--     treesitter = true,
--     -- Others omitted for brevity
--   },
--   styles = {
--     strings = "NONE", -- Style that is applied to strings
--     comments = "NONE", -- Style that is applied to comments
--     keywords = "NONE", -- Style that is applied to keywords
--     functions = "NONE", -- Style that is applied to functions
--     variables = "NONE", -- Style that is applied to variables
--   },
--   options = {
--     bold = true, -- Use the themes opinionated bold styles?
--     italic = true, -- Use the themes opinionated italic styles?
--     underline = true, -- Use the themes opinionated underline styles?
--     undercurl = true, -- Use the themes opinionated undercurl styles?
--     cursorline = true, -- Use cursorline highlighting?
--     transparency = false, -- Use a transparent background?
--     terminal_colors = false, -- Use the theme's colors for Neovim's :terminal?
--     window_unfocussed_color = false, -- When the window is out of focus, change the normal background?
--   },
-- })
-- onedarkpro.load()

local luasnip = require("luasnip")
local cmp = require("cmp")
local lspconfig = require("lspconfig")

function _G.grep_string()
  require("telescope.builtin").grep_string({
    path_display = "smart",
    word_match = "-w",
    sort_only_text = false,
    search = "",
  })
end

function _G.live_grep()
  require("telescope.builtin").live_grep({
    disable_coordiantes = true,
  })
end

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

vim.diagnostic.config({
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
})

-- after the language server attaches to the current buffer
-- fzf_lspp
require("fzf_lsp").setup()
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  print("LSP started.")

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  local opts = { noremap = true, silent = true }

  -- vim.api.nvim_command("au BufWritePre *.go,*.rs :lua vim.lsp.buf.formatting_sync()")
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap("n", "<space>d", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
  buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  buf_set_keymap("n", "<space>r", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  buf_set_keymap("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap("n", "<space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  buf_set_keymap("n", "<space>h", "<cmd>lua vim.lsp.buf.document_highlight()<CR>", opts)
  buf_set_keymap("n", "<space>H", "<cmd> lua require('rust-tools.inlay_hints').toggle_inlay_hints()<CR>", opts)
end

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require("rust-tools").setup({
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
          loadOutDirsFromCheck = true,
          buildScripts = { enable = true },
          procMacro = { enable = true, attributes = { enable = true } },
          hover = { linksInHover = true },
        },
      },
    },
  },
})

require("lspconfig").sqlls.setup({})
local servers = {
  tsserver = {},
  svelte = {},
  ccls = {},
  -- rust_analyzer = {
  --   settings = {
  --     ["rust-analyzer"] = {
  --       cargo = { loadOutDirsFromCheck = true },
  --       procMacro = { enable = true },
  --       hover = { linksInHover = true },
  --     },
  --   },
  -- },
  gopls = {
    settings = {
      gopls = {
        linksInHover = false,
      },
    },
  },
  pyright = {},
  sqls = {},
  yamlls = {
    settings = {
      yaml = {
        schemas = {
          ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
          ["https://json.schemastore.org/github-action.json"] = "/.github/actions/*",
        },
      },
    },
  },

  sumneko_lua = {
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
    if priority1 == priority2 then
      return nil
    end
    return priority2 < priority1
  end
end

local label_comparator = function(entry1, entry2)
  return entry1.completion_item.label < entry2.completion_item.label
end

-- luasnip setup
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<Up>"] = cmp.mapping.select_prev_item(),
    ["<Down>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
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
  }),
  sources = {
    { name = "buffer" },
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
  },
  sorting = {
    comparators = {
      lspkind_comparator({
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
      }),
      label_comparator,
    },
  },
})

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

local textobject_all = function(prefix, inner, outer)
  return {
    [prefix .. inner .. "B"] = "@block.inner",
    [prefix .. outer .. "B"] = "@block.outer",
    [prefix .. inner .. "C"] = "@call.inner",
    [prefix .. outer .. "C"] = "@call.outer",
    [prefix .. inner .. "c"] = "@class.inner",
    [prefix .. outer .. "c"] = "@class.outer",
    [prefix .. outer .. "/"] = "@comment.outer",
    [prefix .. inner .. "b"] = "@conditional.inner",
    [prefix .. outer .. "b"] = "@conditional.outer",
    [prefix .. inner .. "f"] = "@function.inner",
    [prefix .. outer .. "f"] = "@function.outer",
    [prefix .. "g"] = "@function_block",
    [prefix .. inner .. "l"] = "@loop.inner",
    [prefix .. outer .. "l"] = "@loop.outer",
    [prefix .. inner .. "p"] = "@parameter.inner",
    [prefix .. outer .. "p"] = "@parameter.outer",
    [prefix .. outer .. "t"] = "@statement.outer",
  }
end

-- TreeSitter
local textobject_outer = function(prefix)
  return {
    [prefix .. "B"] = "@block.outer",
    [prefix .. "C"] = "@call.outer",
    [prefix .. "c"] = "@class.outer",
    [prefix .. "/"] = "@comment.outer",
    [prefix .. "b"] = "@conditional.outer",
    [prefix .. "f"] = "@function.outer",
    [prefix .. "g"] = "@function_block",
    [prefix .. "l"] = "@loop.outer",
    [prefix .. "p"] = "@parameter.outer",
    [prefix .. "t"] = "@statement.outer",
    [prefix .. "a"] = "@match_arm",
  }
end

require("nvim-treesitter.configs").setup({
  indent = { enable = true },
  ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = { "swift", "phpdoc" },
  highlight = {
    enable = true, -- false will disable the whole extension
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = "o",
      toggle_hl_groups = "i",
      toggle_injected_languages = "t",
      toggle_anonymous_nodes = "a",
      toggle_language_display = "I",
      focus_language = "f",
      unfocus_language = "F",
      update = "R",
      goto_node = "<cr>",
      show_help = "?",
    },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gni",
      node_incremental = "gnn",
      scope_incremental = "gno",
      node_decremental = "gnd",
    },
  },
  textobjects = {
    lsp_interop = {
      enable = true,
      border = "none",
      peek_definition_code = {
        ["<space>k"] = "@function.outer",
        ["<space>c"] = "@class.outer",
        ["<space>C"] = "@call.outer",
        ["<space>t"] = "@statement.outer",
        ["<space>p"] = "@parameter.outer",
      },
    },

    select = {
      enable = true,
      -- You can use the capture groups defined in textobjects.scm
      keymaps = textobject_all("", "i", "a"),
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = textobject_all("]", "i", ""),
      goto_next_end = textobject_all("]e", "i", ""),
      goto_previous_start = textobject_all("[", "i", ""),
      goto_previous_end = textobject_all("[e", "i", ""),
    },
    swap = {
      enable = true,
      swap_next = textobject_all("}", "i", "a"),
      swap_previous = textobject_all("{", "i", "a"),
    },
  },
})

require("nvim-treesitter.highlight").set_custom_captures({
  -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
  ["function.macro"] = "Constant",
  -- ["operator"] = "WarningMsg",
})
