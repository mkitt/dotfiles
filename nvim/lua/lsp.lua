-- LSP Configuration (servers installed globally by make install / make update)
-- @see https://neovim.io/doc/user/news-0.12/

-- Merge default LSP and blink.cmp capabilities
local cmp = require('blink.cmp')
local capabilities = vim.tbl_deep_extend(
  'force',
  {},
  vim.lsp.protocol.make_client_capabilities(),
  cmp.get_lsp_capabilities()
)

-- Global configuration for all LSP servers
local codesettings = require('codesettings')
vim.lsp.config('*', {
  capabilities = capabilities,
  on_init = function(client)
    -- Load and merge local project files like `.vscode/settings.json` or `lspsettings.json`
    local merged = codesettings.with_local_settings(client.name, { settings = client.settings })
    client.settings = vim.tbl_deep_extend('force', client.settings or {}, merged.settings or {})
  end,
})

-- Server-specific configurations (nvim-lspconfig provides base defaults)

-- Vite+ keeps the oxlint/oxfmt config in vite.config.ts, so the lspconfig
-- defaults (which require .oxlintrc.json/.oxfmtrc.json and set
-- workspace_required = true) never attach. Anchor to the repo root instead.
local function vp_root(bufnr, on_dir)
  on_dir(vim.fs.root(bufnr, { 'pnpm-workspace.yaml', '.git' }))
end

vim.lsp.config('oxfmt', {
  cmd = { 'npx', 'oxfmt', '--lsp' },
  root_dir = vp_root,
  workspace_required = false,
})

vim.lsp.config('oxlint', {
  cmd = { 'npx', 'oxlint', '--lsp' },
  root_dir = vp_root,
  workspace_required = false,
  settings = {
    typeAware = true,
  },
})

vim.lsp.config('vtsls', {
  settings = {
    vtsls = { autoUseWorkspaceTsdk = true },
  },
})

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
          ['start'] = { line = 0, character = 0 },
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
    -- 2. Format (no-ops if oxfmt is not attached)
    vim.lsp.buf.format({ bufnr = buf, timeout_ms = 500, name = 'oxfmt' })
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
