require("onedark").setup({
  -- Main options --
  style = "warm", -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
  transparent = false, -- Show/hide background
  term_colors = true, -- Change terminal color as per the selected theme style
  ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
  cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

  -- toggle theme style ---
  toggle_style_key = "<leader><up>", -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
  toggle_style_list = { "light", "warm" }, -- List of styles to toggle between

  -- Change code style ---
  -- Options are italic, bold, underline, none
  -- You can configure multiple style with comma seperated, For e.g., keywords = 'italic,bold'
  code_style = {
    comments = "italic",
    keywords = "none",
    functions = "none",
    strings = "none",
    variables = "none",
  },

  -- Lualine options --
  lualine = {
    transparent = true, -- lualine center bar transparency
  },

  -- Plugins Config --
  diagnostics = {
    darker = true, -- darker colors for diagnostic
    undercurl = true, -- use undercurl instead of underline for diagnostics
    background = true, -- use background color for virtual text
  },
})

vim.api.nvim_set_hl(0, "@function.macro", { link = "@constant" })
-- vim.api.nvim_set_hl(0, "WarningMsg", {link = "@operator"})


local c = require("onedark.colors")
local c_util = require("onedark.util")
local p = require("onedark.palette")
p.light.black = "#a626a4"

-- https://github.com/nvim-treesitter/nvim-treesitter/blob/master/CONTRIBUTING.md#highlights
vim.cmd([[set cursorline]])
vim.cmd([[set cursorlineopt=number]])

config = function()
  local onedark = require("onedark")
  local default_style = "dark"

  local function get_theme_overrides(style)
    local palette = require("onedark.palette")[style]
    if type(palette) == "nil" then
      vim.notify(string.format("couldn't get palette for style %q", style), vim.log.levels.ERROR)
      return
    end
    return {
      highlights = {
        -- ....
      },
    }
  end

  local augroup_id = vim.api.nvim_create_augroup("OnedarkStyle", {})

  vim.api.nvim_clear_autocmds({ group = augroup_id })
  vim.api.nvim_create_autocmd("ColorSchemePre", {
    group = augroup_id,
    desc = "Apply theme overrides before colorscheme change",
    callback = function()
      if vim.g.onedark_config and vim.g.onedark_config.loaded then
        local overrides = get_theme_overrides(vim.g.onedark_config.style)
        onedark.set_options("highlights", overrides.highlights)
        -- onedark.set_options("colors", overrides.colors)
        -- etc
      end
    end,
  })

  onedark.setup({
    toggle_style_list = { "dark", "light" },
    highlights = get_theme_overrides(default_style).highlights,
  })
  onedark.load()
end

require('nvim-treesitter.configs').setup {
  rainbow = {
    enable = false,
    -- Which query to use for finding delimiters
    query = 'rainbow-parens',
    -- Highlight the entire buffer all at once
    strategy = require('ts-rainbow').strategy['local'],
  }
}

require("onedark").setup({
  highlights = {
    ["@keyword"] = { fg = c.red },
    ["@field"] = { fg = c.red },
    ["@namespace"] = { fg = c.blue },
    ["@function"] = { fg = c.blue },
    ["@variable.builtin"] = { fg = c.blue },
    -- ["@variable"] = { fg = c.red },
    ["@operator"] = { fg = c.purple },
    ["@punctuation.closure"] = { fg = c.purple },
    ["@punctuation.special"] = { fg = c.light_grey },
    ["@constant.builtin"] = { fg = c.blue },
    ["@constructor"] = { fg = c.blue },
    ["@constructor.builtin"] = { fg = c.cyan },
    ["@constant"] = { fg = c.cyan },
  }, -- Override highlight groups
})


require("onedark").load()
