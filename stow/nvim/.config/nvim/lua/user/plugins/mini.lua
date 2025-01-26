return {
    'echasnovski/mini.nvim', 
    version = false,
    config = function()
        local align = require('mini.align') 
        align.setup()
    end,
}
