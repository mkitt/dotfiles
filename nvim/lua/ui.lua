-- @see https://github.com/nvim-tree/nvim-web-devicons
require('nvim-web-devicons').setup()

-- @see https://github.com/HakonHarnes/img-clip.nvim
-- brew install pngpaste
require('img-clip').setup({
    filetypes = {
        codecompanion = {
            prompt_for_file_name = false,
            template = "[Image]($FILE_PATH)",
            use_absolute_path = true,
        },
    },
})
