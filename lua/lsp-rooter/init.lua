local rooter = require('lsp-rooter.rooter')
local config = require('lsp-rooter.config')

local M = {}

M.setup = config.setup
M.enable = rooter.enable
M.disable = rooter.disable

M.enable() -- Enable plugin at startup

return M
