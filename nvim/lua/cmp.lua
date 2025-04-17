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
    },
    cmdline = {
        enabled = false
    },
    keymap = {
        preset = 'enter',
        ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback', },
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback', },
    },
    signature = { enabled = true, },
    sources = {
        default = { 'lsp', 'copilot', 'path', 'snippets', 'buffer' },
        providers = {
            lazydev = {
                module = 'lazydev.integrations.blink',
                name = '',
                score_offset = 100,
            },
            copilot = {
                async = true,
                module = 'blink-copilot',
                name = '',
            },
            lsp = { name = '' },
            path = { name = '' },
            snippets = { name = '' },
            buffer = { name = '' },
        },
    },
})
