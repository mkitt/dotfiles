-- Editor group [:vert help highlight-groups]
-- Syntax group [:vert help group-name]
-- :highlight
-- Treesitter https://neovim.io/doc/user/treesitter.html
-- @see https://www.nordtheme.com/docs/colors-and-palettes
-- @see https://github.com/chriskempson/base16/blob/main/styling.md
-- -------------------------------------
local M = {}
M.apply = function(theme)
    local highlights = {
        -- GUI
        Normal = { bg = theme.base00, fg = theme.base04 },
        -- Normal = {  fg = theme.base04 },
        NonText = { fg = theme.base03 },
        SpecialKey = { fg = theme.base0B },
        Cursor = { bg = theme.base0F },
        CursorLine = { bg = theme.base01 },
        CursorColumn = { link = 'CursorLine' },
        ColorColumn = { link = 'CursorColumn' },
        LineNr = { link = 'NonText' },
        CursorLineNr = { fg = theme.base0F },
        WinSeparator = { bg = theme.base01, fg = theme.base01 },
        -- SignColumn = {  bg = theme.base00 },
        QuickFixLine = { link = 'CursorLine' },
        Directory = { fg = theme.base09 },
        Conceal = { fg = theme.base09 },
        Title = { fg = theme.base06, bold = true },
        -- Status & Tab Lines
        StatusLine = { bg = theme.base01, fg = theme.base0A },
        StatusLineNC = { bg = theme.base01, fg = theme.base03 },
        TabLine = { bg = theme.base01, fg = theme.base03 },
        TabLineSel = { link = "Title" },
        TabLineFill = { bg = theme.base01, fg = theme.base03 },
        -- Search & Selection
        Visual = { bg = theme.base02 },
        CurSearch = { bg = theme.base0A, fg = theme.base05 },
        Search = { bg = theme.base01 },
        IncSearch = { bg = theme.base01, fg = theme.base0C },
        MatchParen = { bg = theme.base03 },
        LspReferenceText = { link = 'Search' },
        -- Popup Menus & Floating Windows
        Pmenu = { bg = theme.base01 },
        PmenuSel = { bg = theme.base03 },
        PmenuThumb = { bg = theme.base02 },
        PmenuSbar = { bg = theme.base00 },
        WildMenu = { link = 'CurSearch' },
        NormalFloat = { link = 'Pmenu' },
        WinBar = { link = 'Pmenu' },
        WinBarNC = { link = 'Pmenu' },
        -- Syntax Highligting [:vert help group-name]
        Comment = { fg = theme.base03 },
        Constant = { fg = theme.base07 }, -- + Boolean
        Number = { fg = theme.base0F },
        Float = { link = 'Number' },
        String = { fg = theme.base0E },
        Character = { link = 'String' },
        Identifier = { fg = theme.base08 }, -- + Function
        Statement = { fg = theme.base09 },  -- + Conditional + Repeat + Label + Operator + Keyword + Exception
        PreProc = { fg = theme.base0A },    -- + Include + Define + Macro + PreCondit
        Type = { fg = theme.base07 },       -- + StorageClass + Structure + Typedef
        Special = { fg = theme.base0F },    -- + SpecialChar + SpecialComment
        Delimiter = { fg = theme.base09 },
        Tag = { fg = theme.base09 },
        Debug = { fg = theme.base0C },
        Underlined = { underline = true },
        Ignore = { fg = theme.base08 },
        Error = { fg = theme.base0B },
        Todo = { fg = theme.base0B, underline = true },
        -- Messages and diagnostics
        Added = { fg = theme.base0E },
        Changed = { fg = theme.base0D },
        Removed = { fg = theme.base0B },
        DiagnosticError = { fg = theme.base0B },
        DiagnosticWarn = { fg = theme.base0D },
        DiagnosticInfo = { fg = theme.base07 },
        DiagnosticHint = { fg = theme.base09 },
        DiagnosticOk = { fg = theme.base0E },
        DiagnosticDeprecated = { fg = theme.base0C },
        DiagnosticUnnecessary = { underline = true },
        DiagnosticUnderlineError = { fg = theme.base0B, underline = true },
        DiagnosticUnderlineWarn = { fg = theme.base0D, underline = true },
        DiagnosticUnderlineInfo = { fg = theme.base07, underline = true },
        DiagnosticUnderlineHint = { fg = theme.base09, underline = true },
        DiagnosticUnderlineOk = { fg = theme.base0E, underline = true },
        ErrorMsg = { link = "DiagnosticError" },
        ModeMsg = { link = "DiagnosticHint" },
        MoreMsg = { link = "DiagnosticHint" },
        WarningMsg = { link = "DiagnosticWarn" },
        Question = { fg = theme.base0C },
        -- Diffs
        DiffAdd = { bg = theme.base0E, fg = theme.base02 },
        DiffChange = { bg = theme.base0D, fg = theme.base02 },
        DiffDelete = { bg = theme.base0B, fg = theme.base02 },
        DiffText = { bg = theme.base09, fg = theme.base02 },
        -- Folds
        Folded = { fg = theme.base03 },
        FoldColumn = { link = 'Folded' },
        -- Spelling
        SpellBad = { underline = true },
        SpellCap = { underline = true },
        SpellLocal = { underline = true },
        SpellRare = { underline = true },
        -- Treesitter https://neovim.io/doc/user/treesitter.html
        ['@conceal'] = { link = 'Conceal' },
        ['@constructor'] = { link = 'Identifier' },
        ['@exception'] = { link = 'Special' },
        ['@punctuation.bracket'] = { fg = theme.base04 },
        ['@punctuation.special'] = { link = 'Debug' },
        ['@string.regex'] = { link = 'WarningMsg' },
        ['@tag.attribute'] = { link = 'Statement' },
        ['@text.literal'] = { fg = theme.base04 },
        ['@variable'] = { fg = theme.base04 },
        -- Plugins
        FzfLuaBorder = { fg = theme.base00, bg = theme.base00, },
        FzfLuaTitle = { link = "Title" },
        FzfLuaHeaderText = { link = "NonText" },
        FzfLuaTabTitle = { link = "NonText" },
        FzfLuaHeaderBind = { link = "NonText" },
        FzfLuaPathColNr = { link = "Debug" },
        FzfLuaPathLineNr = { link = "Debug" },
        FzfLuaBufNr = { link = "Debug" },
        FzfLuaBufFlagCur = { link = "Debug" },
        FzfLuaBufFlagAlt = { link = "Debug" },
        FzfLuaTabMarker = { link = "Debug" },
        FzfLuaLivePrompt = { link = "Debug" },
        FzfLuaLiveSym = { link = "Debug" },
        -- Tree Elements
        NeoTreeDimText = { link = "NonText" },
        NeoTreeDotfile = { link = "NonText" },
        NeoTreeFadeText1 = { link = "NonText" },
        NeoTreeFadeText2 = { link = "NonText" },
        NeoTreeFloatTitle = { link = "Title" },
        NeoTreeMessage = { link = "DiagnosticHint" },
        NeoTreeRootName = { link = "Title" },
        NeoTreeTitleBar = { link = "Title" },
        -- Tab Related
        NeoTreeTabActive = { link = "TablineSel" },
        NeoTreeTabInactive = { link = "Tabline" },
        NeoTreeTabSeparatorActive = { link = "TablineFill" },
        NeoTreeTabSeparatorInactive = { link = "TablineFill" },
        -- File Status
        NeoTreeAdded = { link = "Added" },
        NeoTreeDeleted = { link = "Removed" },
        NeoTreeModified = { link = "Changed" },
        NeoTreeFileStats = { link = "NonText" },
        NeoTreeFileStatsHeader = { link = "Title" },
        -- Git Status
        NeoTreeGitAdded = { link = "Added" },
        NeoTreeGitConflict = { link = "Error" },
        NeoTreeGitDeleted = { link = "Removed" },
        NeoTreeGitIgnored = { link = "NonText" },
        NeoTreeGitModified = { link = "Changed" },
        NeoTreeGitUntracked = { link = "Added" },
        -- Misc
        YankyPut = { link = "Search" },
        YankyYanked = { link = "MatchParen" },
    }
    -- Set highlights
    for group, opts in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, opts)
    end
end

return M
