-- Auto required from plugins.lua
-- @see https://github.com/yioneko/nvim-vtsls

local cmp = require('blink.cmp')
local lspconfig = require('lspconfig')

-- @see https://github.com/williamboman/mason.nvim
require('mason').setup()

-- @see https://github.com/williamboman/mason-lspconfig.nvim
require('mason-lspconfig').setup({
    automatic_installation = true,
    ensure_installed = { 'bashls', 'biome', 'cssls', 'eslint', 'graphql', 'html', 'markdown_oxide', 'jsonls', 'lua_ls', 'tailwindcss', 'vtsls', 'yamlls', },
})

-- Merge default LSP and nvim-cmp capabilities for language servers
local capabilities = vim.tbl_deep_extend(
    'force',
    {},
    vim.lsp.protocol.make_client_capabilities(),
    cmp.get_lsp_capabilities()
)

-- Configure individual language servers
require('mason-lspconfig').handlers = {
    function(server_name)
        lspconfig[server_name].setup({
            capabilities = capabilities,
        })
    end,
}

lspconfig.biome.setup({
    capabilities = capabilities,
    on_attach = function(_, bufnr)
        vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.code_action({
                    ---@diagnostic disable-next-line: missing-fields
                    context = {
                        ---@diagnostic disable-next-line: assign-type-mismatch
                        only = { 'source.fixAll.biome', 'source.organizeImports.biome', 'source.action.useSortedAttributes.biome', 'source.action.useSortedKeys.biome', 'source.action.useSortedProperties.biome', 'quickfix.biome.nursery.useSortedClasses' },
                    },
                    apply = true,
                })
            end,
        })
    end,
})

lspconfig.eslint.setup({
    capabilities = capabilities,
    on_attach = function(_, bufnr)
        vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = bufnr,
            command = 'EslintFixAll',
        })
    end,
})

lspconfig.graphql.setup({
    capabilities = capabilities,
    root_dir = lspconfig.util.root_pattern('.graphqlrc*', '.graphql.config.*', 'graphql.config.*', 'package.json'),
})

lspconfig.vtsls.setup({
    capabilities = capabilities,
    init_options = {
        vtsls = { autoUseWorkspaceTsdk = true, },
    },
})

-- @see https://github.com/folke/lazydev.nvim
require('lazydev').setup()

-- @see https://github.com/stevearc/conform.nvim
require('conform').setup({
    formatters_by_ft = {
        css = { 'prettierd', 'prettier', stop_after_first = true },
        graphql = { 'prettierd', 'prettier', stop_after_first = true },
        html = { 'prettierd', 'prettier', stop_after_first = true },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        json = { 'prettierd', 'prettier', stop_after_first = true },
        lua = { 'stylua' },
        markdown = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        yaml = { 'prettierd', 'prettier', stop_after_first = true },
    },
    format_on_save = {
        lsp_fallback = true,
        timeout_ms = 500,
    },
})

-- -------------------------------------
-- Auto Commands
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('theLspAttach', { clear = true }),
    callback = function(e)
        local id = vim.tbl_get(e, 'data', 'client_id')
        local client = id and vim.lsp.get_client_by_id(id)
        if client ~= nil then
            -- Disable LSP semantic highlights
            client.server_capabilities.semanticTokensProvider = nil
            -- Highlight the word under the cursor
            if client.server_capabilities.documentHighlightProvider then
                vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                    buffer = e.buf,
                    callback = vim.lsp.buf.document_highlight,
                })
                vim.api.nvim_create_autocmd("CursorMoved", {
                    buffer = e.buf,
                    callback = vim.lsp.buf.clear_references,
                })
            end
        end
    end
})
