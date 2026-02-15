-- Native LSP configuration for Neovim 0.11+
-- @see https://gpanders.com/blog/whats-new-in-neovim-0-11/#lsp

local cmp = require('blink.cmp')

-- -------------------------------------
-- LSP Configuration
-- LSP servers installed globally via: make lsp (in dotfiles)

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
vim.lsp.config('graphql', {
  root_markers = { '.graphqlrc*', '.graphql.config.*', 'graphql.config.*', 'package.json' },
})

vim.lsp.config('oxlint', {
  cmd = { 'npx', 'oxlint', '--lsp' },
})

vim.lsp.config('oxfmt', {
  cmd = { 'npx', 'oxfmt', '--lsp' },
  root_markers = { '.oxfmtrc.json', 'package.json', '.git' },
})

vim.lsp.config('vtsls', {
  settings = {
    vtsls = { autoUseWorkspaceTsdk = true },
  },
})

-- @see https://github.com/folke/lazydev.nvim
require('lazydev').setup()

-- Enable all LSP servers
vim.lsp.enable({
  'bashls',
  'cssls',
  'graphql',
  'html',
  'jsonls',
  'lua_ls',
  'oxfmt',
  'oxlint',
  'tailwindcss',
  'vtsls',
  'yamlls',
})

-- -------------------------------------
-- Auto Commands

-- Format on save: fixAll (oxlint) → format (oxfmt)
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('FormatOnSave', { clear = true }),
  callback = function(args)
    local buf = args.buf

    -- 1. Fix all lint issues
    local oxlint = vim.lsp.get_clients({ bufnr = buf, name = 'oxlint' })[1]
    if oxlint then
      local params = {
        textDocument = { uri = vim.uri_from_bufnr(buf) },
        context = { only = { 'source.fixAll.oxc' }, diagnostics = {} },
        range = {
          start = { line = 0, character = 0 },
          ['end'] = { line = vim.api.nvim_buf_line_count(buf), character = 0 },
        },
      }
      local result = oxlint:request_sync('textDocument/codeAction', params, 1000, buf)
      if result and result.result and result.result[1] then
        local action = result.result[1]
        if action.edit then
          vim.lsp.util.apply_workspace_edit(action.edit, oxlint.offset_encoding)
        elseif action.command then
          oxlint:request_sync('workspace/executeCommand', action.command, 1000, buf)
        end
      end
    end

    -- 2. Format
    local oxfmt = vim.lsp.get_clients({ bufnr = buf, name = 'oxfmt' })[1]
    if oxfmt then
      vim.lsp.buf.format({ bufnr = buf, timeout_ms = 500, name = 'oxfmt' })
    end
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
