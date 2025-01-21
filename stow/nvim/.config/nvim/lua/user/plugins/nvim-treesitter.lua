return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" }, -- Lazy load plugin on existing or new file
  build = ":TSUpdate",  -- ensure all language parsers are updated

  config = function()
    -- import nvim-treesitter plugin
    local treesitter = require("nvim-treesitter.configs")

    -- configure treesitter
    treesitter.setup({ -- enable syntax highlighting
      highlight = { enable = true, },
      -- enable indentation
      indent = { enable = true },
      -- ensure these language parsers are installed
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "cmake",
        "devicetree",
        "dockerfile",
        "doxygen",
        "groovy",
        "json",
        "kconfig",
        "lua",
        "make",
        "markdown",
        "matlab",
        "python",
        "query",
        "tcl",
        "verilog",
        "vhdl",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
  end,
}
