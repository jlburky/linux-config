return {
  "nvim-tree/nvim-tree.lua",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local nvimtree = require("nvim-tree")
    local devicons = require("nvim-web-devicons")

    -- Change some icons; enter :NvimWebDeviconsHiTest to view icons
    devicons.set_default_icon('', '#6d8086', 65)
    devicons.set_icon {
        ["dockerfile"] = {
          icon = "",
          color = "#458ee6",
          cterm_color = "68",
          name = "Dockerfile",
        },
        readme = {
          icon = "",
          color = "#ededed",
          cterm_color = "255",
          name = "Readme",
        },
        ["readme.md"] = {
          icon = "",
          color = "#ededed",
          cterm_color = "255",
          name = "Readme",
        },
        sh= {
          icon = "",
          color = "#a2518d",
          cterm_color = "132",
          name = "Sh"
        },
        vhd = {
          icon = "",
          color = "#428850",
          cterm_color = "65",
          name = "VHDL"
        },
        vhdl = {
          icon = "",
          color = "#428850",
          cterm_color = "65",
          name = "VHDL"
        }
    }

    -- recommended settings from nvim-tree documentation
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    nvimtree.setup({
      view = {
        width = 40,
        relativenumber = true,
      },
      -- change folder arrow icons
      renderer = {
        indent_markers = {
          enable = true,
        },
        icons = {
          glyphs = {
            folder = {
              arrow_closed = "", -- arrow when folder is closed
              arrow_open = "", -- arrow when folder is open
            },
          },
        },
      },
      -- disable window_picker for
      -- explorer to work well with
      -- window splits
      actions = {
        open_file = {
          window_picker = {
            enable = false,
          },
        },
      },
      filters = {
        custom = { ".DS_Store" },
      },
      git = {
        ignore = false,
      },
    })

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
    keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" }) -- toggle file explorer on current file
    keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
    keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer
  end
}
