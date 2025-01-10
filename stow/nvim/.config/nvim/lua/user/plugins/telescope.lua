return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local builtin = require('telescope.builtin')

    telescope.setup({
      defaults = {
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-d>"] = actions.delete_buffer, -- delete selection
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
        vimgrep_arguments = {
          "rg",
          "--color=never",    -- until color codes are interpreted...
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
          "--unrestricted",
          "--ignore-file",
          ".gitignore"
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          -- needed to exclude some files & dirs from general search
          -- when not included or specified in .gitignore
          find_command = {
            "rg",
            "--files",
            "--hidden",
            "--glob=!**/.git/*",
            "--glob=!**/build/*",
            "--glob=!**/dist/*",
          },
        },
      },
    })

    telescope.load_extension("fzf")

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    --keymap.set("n", "<leader>ff", "<cmd>Telescope find_files {follow = true}<cr>", { desc = "Fuzzy find files in cwd" })
    keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
    keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = 'Telescope recent files' })
    keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
    keymap.set('n', '<leader>fc', builtin.grep_string, { desc = 'Telescope string under cursor' })
    keymap.set('n', '<leader>b', builtin.buffers, { desc = 'Telescope buffers' })
    keymap.set('n', '<leader>h', builtin.help_tags, { desc = 'Telescope help tags' })
    keymap.set('n', '<leader>k', builtin.keymaps, { desc = 'Telescope key maps' })
  end,
}
