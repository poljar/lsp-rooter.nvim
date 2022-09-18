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

    -- Use the given client or try to find one for the current buffer.
    client = client or util.get_lsp_client_for_current_buffer()

    if client == nil then
        -- There's no LSP client, can't ask it for the current root directory.
        return
    end

    -- TODO can this be null? The docs for vim.lsp.client tell us that an LSP
    -- client might not be fully initialized. Apparently it can be, using the
    -- autocmd now results in config being null.
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

function _G.__lsp_root_dir()
    set_project_dir()
end

local function create_autocommand()
    vim.cmd('autocmd BufEnter * call v:lua.__lsp_root_dir()')

    -- This seems to now run too early `client.config` being null when we call
    -- set_project_dir
    -- local group = vim.api.nvim_create_augroup('LspRooter', {})
    -- vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    --     group = group,
    --     callback = set_project_dir,
    -- })
end

M.enabled = false
M.loaded = false
M.project_dir = nil

M.enable = function()
    M.enabled = true

    if M.loaded == false then
        -- TODO is the autocommand even useful? I only want to change the root
        -- dir if this is a real project, i.e. something that will have an LSP
        -- running, on_attach is already buffer local.
        create_autocommand()
        util.append_on_attach(on_attach)

        M.loaded = true
    end
end

M.disable = function()
    M.enabled = false
end

return M
