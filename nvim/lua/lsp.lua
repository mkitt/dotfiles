-- Native LSP configuration for Neovim 0.11+
-- @see https://gpanders.com/blog/whats-new-in-neovim-0-11/#lsp

local cmp = require('blink.cmp')
local conform = require('conform')

-- -------------------------------------
-- LSP Configuration
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
  on_init = function(client)
    -- Load and merge local project files like `.vscode/settings.json` or `lspsettings.json`
    local codesettings = require('codesettings')
    local merged = codesettings.with_local_settings(client.name, { settings = client.settings })
    client.settings = vim.tbl_deep_extend('force', client.settings or {}, merged.settings or {})
  end,

})

-- Server-specific configurations
vim.lsp.config.graphql = {
  root_markers = { '.graphqlrc*', '.graphql.config.*', 'graphql.config.*', 'package.json' },
}

vim.lsp.config.vtsls = {
  settings = {
    vtsls = { autoUseWorkspaceTsdk = true },
  },
}

-- Enable all LSP servers
-- Install these via :Mason if not already installed
-- NOTE: These are LSP server names (not Mason package names)
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
-- Plugin Setup

-- @see https://github.com/folke/lazydev.nvim
require('lazydev').setup()

-- @see https://github.com/stevearc/conform.nvim
conform.setup({
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
})

-- -------------------------------------
-- Auto Commands

-- Format on save: oxlint fix -> eslint fix -> prettier/stylua
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('FormatOnSave', { clear = true }),
  callback = function(args)
    -- 1. Oxlint auto-fix
    local oxlint = vim.lsp.get_clients({ bufnr = args.buf, name = 'oxlint' })[1]
    if oxlint then
      oxlint:request_sync('workspace/executeCommand', {
        command = 'oxc.fixAll',
        arguments = { { uri = vim.uri_from_bufnr(args.buf) } },
      }, 1000, args.buf)
    end

    -- 2. ESLint auto-fix
    local eslint = vim.lsp.get_clients({ bufnr = args.buf, name = 'eslint' })[1]
    if eslint then
      local params = {
        textDocument = { uri = vim.uri_from_bufnr(args.buf) },
        range = {
          start = { line = 0, character = 0 },
          ['end'] = { line = vim.api.nvim_buf_line_count(args.buf), character = 0 },
        },
        context = { only = { 'source.fixAll.eslint' }, diagnostics = {} },
      }
      local result = eslint:request_sync('textDocument/codeAction', params, 1000, args.buf)
      if result and result.result and result.result[1] then
        vim.lsp.util.apply_workspace_edit(result.result[1].edit, eslint.offset_encoding)
      end
    end

    -- 3. Conform (prettier/stylua)
    conform.format({ bufnr = args.buf, lsp_fallback = true, timeout_ms = 500 })
  end,
})

-- Document highlighting
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('LspHighlighting', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    -- Disable LSP semantic highlights
    client.server_capabilities.semanticTokensProvider = nil

    -- Highlight the word under the cursor
    if client.server_capabilities.documentHighlightProvider then
      local group = vim.api.nvim_create_augroup('LspDocumentHighlight_' .. args.buf, { clear = true })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        group = group,
        buffer = args.buf,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd('CursorMoved', {
        group = group,
        buffer = args.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})
