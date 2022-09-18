local util = require('lsp-rooter.util')
local M = {}

-- Set the nvim-tree root directory if nvim-tree is loaded
local function change_nvim_tree_root(dir)
    if vim.fn.exists('g:loaded_tree') and vim.g.loaded_tree then
        -- TODO we'll probably want to put this into a pcall(), g.loaded_tree is
        -- by no means guaranteed to be nvim-tree specific.
        require('nvim-tree.lib').change_dir(dir)
    end
end

local function set_project_dir(client)
    if M.enabled == false then
        return -- Plugin not enabled
    end

    if not client or not client.config then
        -- There's no LSP client, can't ask it for the current root directory.
        return
    end

    local project_root = client.config.root_dir

    -- TODO is this correct, that sounds like a global and we'll want to support
    -- multiple different filetypes and LSP clients being active inside a single
    -- nvim instance.
    if M.project_dir ~= project_root then
        M.project_dir = project_root

        vim.api.nvim_set_current_dir(project_root)
        change_nvim_tree_root(project_root)
    end
end

local function on_attach(client, _)
    if not util.is_client_ignored(client) then
        set_project_dir(client)
    end
end

M.enabled = false
M.loaded = false
M.project_dir = nil

M.enable = function()
    M.enabled = true

    if M.loaded == false then
        util.append_on_attach(on_attach)

        M.loaded = true
    end
end

M.disable = function()
    M.enabled = false
end

return M
