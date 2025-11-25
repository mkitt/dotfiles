-- Native LSP configuration for Neovim 0.11+
-- @see https://gpanders.com/blog/whats-new-in-neovim-0-11/#lsp

local cmp = require('blink.cmp')

-- @see https://github.com/williamboman/mason.nvim
require('mason').setup()

-- Merge default LSP and blink.cmp capabilities
local capabilities = vim.tbl_deep_extend(
  'force',
  {},
  vim.lsp.protocol.make_client_capabilities(),
  cmp.get_lsp_capabilities()
)

-- Global configuration for all LSP servers
vim.lsp.config('*', {
  capabilities = capabilities,
})

-- Server-specific configurations
vim.lsp.config.graphql = {
  root_markers = { '.graphqlrc*', '.graphql.config.*', 'graphql.config.*', 'package.json' },
}

vim.lsp.config.vtsls = {
  settings = {
    vtsls = { autoUseWorkspaceTsdk = true, },
  },
}

-- @see https://github.com/folke/lazydev.nvim
require('lazydev').setup()

-- @see https://github.com/stevearc/conform.nvim
require('conform').setup({
  formatters_by_ft = {
    css = { 'prettier', stop_after_first = true },
    graphql = { 'prettier', stop_after_first = true },
    html = { 'prettier', stop_after_first = true },
    javascript = { 'prettier', stop_after_first = true },
    javascriptreact = { 'prettier', stop_after_first = true },
    json = { 'prettier', stop_after_first = true },
    lua = { 'stylua' },
    markdown = { 'prettier', stop_after_first = true },
    typescript = { 'prettier', stop_after_first = true },
    typescriptreact = { 'prettier', stop_after_first = true },
    yaml = { 'prettier', stop_after_first = true },
  },
  format_on_save = {
    lsp_fallback = true,
    timeout_ms = 500,
  },
})

-- Enable all LSP servers
-- Install these via :Mason if not already installed
vim.lsp.enable({
  'bashls',
  'cssls',
  'eslint',
  'graphql',
  'html',
  'jsonls',
  'lua_ls',
  'oxlint',
  'tailwindcss',
  'vtsls',
  'yamlls',
})

-- -------------------------------------
-- Auto Commands

-- Server-specific on_attach behavior
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('LspOnAttach', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    -- ESLint: auto-fix on save
    if client.name == 'eslint' then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('EslintAutoFix', { clear = false }),
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.code_action({
            context = { only = { 'source.fixAll.eslint' }, diagnostics = {} },
            apply = true,
          })
        end,
      })
    end

    -- Oxlint: auto-fix on save
    if client.name == 'oxlint' then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('OxlintAutoFix', { clear = false }),
        buffer = args.buf,
        callback = function()
          vim.cmd('OxcFixAll')
        end,
      })
    end
  end,
})

-- Document highlighting
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('LspHighlighting', { clear = true }),
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
