local M = {}

M.Set = {}

function M.Set.new(t)
    local set = {}
    for _, l in ipairs(t) do set[l] = true end
    return set
end

function M.Set.contains(set, key)
    return set[key] ~= nil
end

-- Has the given LSP client been configured to be ignored
M.is_client_ignored = function(client)
    local ignore_lsp = require('lsp-rooter.config').options.ignore_lsp
    return M.Set.contains(ignore_lsp, client.name)
end

M.find_best_client = function(clients)
    for _, client in pairs(clients) do
        if not M.is_client_ignored(client) then
            local filetypes = client.config.filetypes
            local buffer_filetype = vim.api.nvim_buf_get_option(0, 'filetype')

            -- If the client is for the current buffers filetype, return it,
            -- otherwise skip it.
            if filetypes and vim.fn.index(filetypes, buffer_filetype) ~= -1 then
                return client
            end
        end
    end
end

-- Get the currently active LSP client for the current buffer.
M.get_lsp_client_for_current_buffer = function()
    -- Get all the active clients for the current buffer.
    local clients = vim.lsp.buf_get_clients()

    -- Find the best client for the current buffer
    return M.find_best_client(clients)
end


-- Override the current LSP start_client method to append our own on_attach
-- method.
M.append_on_attach = function(on_attach)
    local _start_client = vim.lsp.start_client

    vim.lsp.start_client = function(lsp_config)
        if lsp_config.on_attach == nil then
            lsp_config.on_attach = on_attach
        else
            local _on_attach = lsp_config.on_attach
            lsp_config.on_attach = function(client, buffer_number)
                on_attach(client, buffer_number)
                _on_attach(client, buffer_number)
            end
        end

        return _start_client(lsp_config)
    end
end

return M
