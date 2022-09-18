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
