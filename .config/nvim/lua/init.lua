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
  use("neovim/nvim-lspconfig") -- Collection of configurations for built-in LSP client
  use("nvim-lua/plenary.nvim")
  use("nvim-lua/popup.nvim")
  use("nvim-telescope/telescope.nvim")
  use("nvim-treesitter/playground")
  use("saadparwaiz1/cmp_luasnip") -- Snippets source for nvim-cmp
  use("wbthomason/packer.nvim")
  use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
  use("natecraddock/telescope-zf-native.nvim")
  use("simrat39/rust-tools.nvim")
  -- use("olimorris/onedarkpro.nvim")
  -- use("norcalli/nvim-colorizer.lua")
end)

vim.api.nvim_set_keymap(
  "n",
  "<leader>cd",
  ":lua require'telescope'.extensions.zoxide.list{}<CR>",
  { noremap = true, silent = true }
)

require("telescope").setup({
  extensions = {
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

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

vim.diagnostic.config({
  underline = true,
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
  server = { on_attach = on_attach, capabilities = capabilities },
})

local servers = {
  tsserver = {},
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
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
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
  },
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
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

local parser_config = require'nvim-treesitter.parsers'.get_parser_configs()
parser_config.gotmpl = {
  install_info = {
    url = "https://github.com/ngalaiko/tree-sitter-go-template",
    files = {"src/parser.c"}
  },
  filetype = "gotmpl",
  used_by = {"gohtmltmpl", "gotexttmpl", "gotmpl", "yaml"}
}

-- TreeSitter
require("nvim-treesitter.configs").setup({
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
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
        ["<leader>dF"] = "@class.outer",
      },
    },

    select = {
      enable = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["iB"] = "@block.inner",
        ["aB"] = "@block.outer",
        ["iC"] = "@call.inner",
        ["aC"] = "@call.outer",
        ["ic"] = "@class.inner",
        ["ac"] = "@class.outer",
        ["a/"] = "@comment.outer",
        ["ib"] = "@conditional.inner",
        ["ab"] = "@conditional.outer",
        ["ir"] = "@frame.inner",
        ["ar"] = "@frame.outer",
        ["if"] = "@function.inner",
        ["af"] = "@function.outer",
        ["ag"] = "@function_block",
        ["il"] = "@loop.inner",
        ["al"] = "@loop.outer",
        ["ip"] = "@parameter.inner",
        ["ap"] = "@parameter.outer",
        ["it"] = "@statement.inner",
        ["at"] = "@statement.outer",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]c"] = "@class.outer",
        ["]r"] = "@parameter.outer",
        ["]t"] = "@statement.outer",
      },
      goto_next_end = {
        ["]ef"] = "@function.outer",
        ["]ec"] = "@class.outer",
        ["]et"] = "@statement.outer",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[c"] = "@class.outer",
        ["[t"] = "@statement.outer",
      },
      goto_previous_end = {
        ["[ef"] = "@function.outer",
        ["[ec"] = "@class.outer",
        ["[et"] = "@statement.outer",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>ir"] = "@parameter.inner",
        ["<leader>af"] = "@function.outer",
        ["<leader>if"] = "@function.inner",
      },
      swap_previous = {
        ["<leader>Ir"] = "@parameter.inner",
        ["<leader>Af"] = "@function.outer",
        ["<leader>If"] = "@function.inner",
      },
    },
  },
})
