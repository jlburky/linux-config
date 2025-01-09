require('user.core')
require("user.lazy")

--require('user.mappings')
--require('user.lsp_config')
--local utils = require('user.utils')
--
---- Custom functions
--function ShowRtp()
--    local rtpList = utils.split(vim.o.runtimepath, ',')
--    table.insert(rtpList, 1, "-- runtimepath --")
--    utils.floatwin(rtpList)
--end

-- Everything below requires more than just the vimfiles' nvim-bundle
--require('user.telescope.init')
--
---- nvim-tree setup
--require('user.nvim-tree.init')
--
---- Set Vim's notify function to use notify-nvim
--vim.notify = require('notify')
