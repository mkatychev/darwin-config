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

require("nvim-treesitter.configs").setup {
    matchup = { enable = true },
    indent = { enable = true },
    -- ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    ignore_install = { "swift", "phpdoc" },
    highlight = {
        enable = true, -- false will disable the whole extension
        -- disable = { "markdown_inline" },
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
}

vim.treesitter.language.register("bash", "zsh")
