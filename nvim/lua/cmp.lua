-- @see https://cmp.saghen.dev
require('blink.cmp').setup({
    completion = {
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
        },
        menu = {
            draw = {
                columns = { { 'kind_icon' }, { 'label', 'label_description', 'source_name', gap = 1 } },
                treesitter = { 'lsp' },
            },
            max_height = 20,
        },
        list = {
            selection = {
                preselect = false,
                auto_insert = false,
            },
        },
    },
    cmdline = {
        enabled = false
    },
    keymap = {
        preset = 'enter',
        ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback', },
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback', },
    },
    signature = {
        enabled = true,
    },
    sources = {
        default = { 'copilot', 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
            copilot = { name = '', module = 'blink-copilot', async = true },
            lsp = { name = '' },
            path = { name = '' },
            snippets = { name = '' },
            buffer = { name = '' },
        },
    },
})
