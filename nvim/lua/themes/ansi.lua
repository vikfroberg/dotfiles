-- ANSI Color Scheme for Neovim (Lua)
-- Supports both light and dark backgrounds
-- Converted from Vimscript

local M = {}

function M.setup()
  -- Clear existing highlights and set color scheme name
  vim.cmd('hi clear')
  if vim.fn.exists('syntax_on') == 1 then
    vim.cmd('syntax reset')
  end

  vim.g.colors_name = 'ansi'
  vim.opt.termguicolors = false

  -- Check if background is light or dark
  local is_light = vim.opt.background:get() == 'light'

  -- Helper function to get colors based on background
  local function c(dark_color, light_color)
    return is_light and (light_color or dark_color) or dark_color
  end

  -- Helper function to set highlights
  local function hi(group, opts)
    vim.api.nvim_set_hl(0, group, opts or {})
  end

  -- This color scheme relies on ANSI colors only. It automatically inherits
  -- the 16 colors of your terminal color scheme and adapts to light/dark backgrounds.
  --
  -- 0: Black        │   8: Bright Black (dark gray)
  -- 1: Red          │   9: Bright Red
  -- 2: Green        │  10: Bright Green
  -- 3: Yellow       │  11: Bright Yellow
  -- 4: Blue         │  12: Bright Blue
  -- 5: Magenta      │  13: Bright Magenta
  -- 6: Cyan         │  14: Bright Cyan
  -- 7: White (gray) │  15: Bright White

  -- Editor Elements
  hi('NonText', { ctermfg = c(0, 8) })
  hi('Ignore', {})
  hi('Underlined', { underline = true })
  hi('Bold', { bold = true })
  hi('Italic', { italic = true })
  hi('StatusLine', { ctermfg = c(15, 0), ctermbg = c(8, 7) })
  hi('StatusLineNC', { ctermfg = c(15, 0), ctermbg = c(0, 15) })
  hi('VertSplit', { ctermfg = c(8, 7) })
  hi('TabLine', { ctermfg = c(7, 0), ctermbg = c(0, 15) })
  hi('TabLineFill', { ctermfg = c(0, 15) })
  hi('TabLineSel', { ctermfg = c(0, 15), ctermbg = c(11, 3) })
  hi('Title', { ctermfg = c(4, 4), bold = true })
  hi('CursorLine', { ctermbg = c(0, 15) })
  hi('Cursor', { ctermbg = c(15, 0), ctermfg = c(0, 15) })
  hi('CursorColumn', { ctermbg = c(0, 15) })
  hi('LineNr', { ctermfg = c(8, 7) })
  hi('CursorLineNr', { ctermfg = c(6, 6) })
  hi('helpLeadBlank', {})
  hi('helpNormal', {})
  hi('Visual', { ctermbg = c(8, 7), ctermfg = c(15, 0), bold = true })
  hi('VisualNOS', { ctermbg = c(8, 7), ctermfg = c(15, 0), bold = true })
  hi('Pmenu', { ctermbg = c(0, 15), ctermfg = c(15, 0) })
  hi('PmenuSbar', { ctermbg = c(8, 7), ctermfg = c(7, 8) })
  hi('PmenuSel', { ctermbg = c(8, 7), ctermfg = c(15, 0), bold = true })
  hi('PmenuThumb', { ctermbg = c(7, 8) })
  hi('FoldColumn', { ctermfg = c(7, 8) })
  hi('Folded', { ctermfg = c(12, 4) })
  hi('WildMenu', { ctermbg = c(0, 15), ctermfg = c(15, 0) })
  hi('SpecialKey', { ctermfg = c(0, 8) })
  hi('IncSearch', { ctermbg = c(1, 9), ctermfg = c(0, 15) })
  hi('CurSearch', { ctermbg = c(3, 11), ctermfg = c(0, 15) })
  hi('Search', { ctermbg = c(11, 3), ctermfg = c(0, 15) })
  hi('Directory', { ctermfg = c(4, 4) })
  hi('MatchParen', { ctermbg = c(0, 15), ctermfg = c(3, 11), underline = true })
  hi('SpellBad', { undercurl = true })
  hi('SpellCap', { undercurl = true })
  hi('SpellLocal', { undercurl = true })
  hi('SpellRare', { undercurl = true })
  hi('ColorColumn', { ctermbg = c(8, 7) })
  hi('SignColumn', { ctermfg = c(7, 8) })
  hi('ModeMsg', { ctermbg = c(15, 0), ctermfg = c(0, 15), bold = true })
  hi('MoreMsg', { ctermfg = c(4, 4) })
  hi('Question', { ctermfg = c(4, 4) })
  hi('QuickFixLine', { ctermbg = c(0, 15), ctermfg = c(14, 6) })
  hi('Conceal', { ctermfg = c(8, 7) })
  hi('ToolbarLine', { ctermbg = c(0, 15), ctermfg = c(15, 0) })
  hi('ToolbarButton', { ctermbg = c(8, 7), ctermfg = c(15, 0) })
  hi('debugPC', { ctermfg = c(7, 8) })
  hi('debugBreakpoint', { ctermfg = c(8, 7) })
  hi('ErrorMsg', { ctermfg = c(1, 1), bold = true, italic = true })
  hi('WarningMsg', { ctermfg = c(11, 3) })
  hi('DiffAdd', { ctermbg = c(10, 2), ctermfg = c(0, 15) })
  hi('DiffChange', { ctermbg = c(12, 4), ctermfg = c(0, 15) })
  hi('DiffDelete', { ctermbg = c(9, 1), ctermfg = c(0, 15) })
  hi('DiffText', { ctermbg = c(14, 6), ctermfg = c(0, 15) })
  hi('diffAdded', { ctermfg = c(10, 2) })
  hi('diffRemoved', { ctermfg = c(9, 1) })
  hi('diffChanged', { ctermfg = c(12, 4) })
  hi('diffOldFile', { ctermfg = c(11, 3) })
  hi('diffNewFile', { ctermfg = c(13, 5) })
  hi('diffFile', { ctermfg = c(12, 4) })
  hi('diffLine', { ctermfg = c(7, 8) })
  hi('diffIndexLine', { ctermfg = c(14, 6) })
  hi('healthError', { ctermfg = c(1, 1) })
  hi('healthSuccess', { ctermfg = c(2, 2) })
  hi('healthWarning', { ctermfg = c(3, 3) })

  -- Syntax highlighting
  hi('Comment', { ctermfg = c(8, 7), italic = true })
  hi('Constant', { ctermfg = c(3, 3) })
  hi('Error', { ctermfg = c(1, 1) })
  hi('Identifier', { ctermfg = c(9, 1) })
  hi('Function', { ctermfg = c(4, 4) })
  hi('Special', { ctermfg = c(13, 5) })
  hi('Statement', { ctermfg = c(5, 5) })
  hi('String', { ctermfg = c(2, 2) })
  hi('Operator', { ctermfg = c(6, 6) })
  hi('Boolean', { ctermfg = c(3, 3) })
  hi('Label', { ctermfg = c(14, 6) })
  hi('Keyword', { ctermfg = c(5, 5) })
  hi('Exception', { ctermfg = c(5, 5) })
  hi('Conditional', { ctermfg = c(5, 5) })
  hi('PreProc', { ctermfg = c(13, 5) })
  hi('Include', { ctermfg = c(5, 5) })
  hi('Macro', { ctermfg = c(5, 5) })
  hi('StorageClass', { ctermfg = c(11, 3) })
  hi('Structure', { ctermfg = c(11, 3) })
  hi('Todo', { ctermfg = c(0, 15), ctermbg = c(9, 1), bold = true })
  hi('Type', { ctermfg = c(11, 3) })

  -- Neovim-specific
  hi('NormalFloat', { ctermbg = c(0, 15), ctermfg = c(15, 0) })
  hi('FloatBorder', { ctermbg = c(0, 15), ctermfg = c(7, 8) })
  hi('FloatShadow', { ctermbg = c(0, 15), ctermfg = c(15, 0) })

  -- Treesitter highlighting
  -- Allows for more precise syntax highlighting
  -- Only available for nvim >0.5
  -- See also :help treesitter-highlight-groups

  hi('@variable', { ctermfg = c(15, 0) })
  hi('@variable.builtin', { ctermfg = c(1, 1) })
  hi('@variable.parameter', { ctermfg = c(1, 1) })
  hi('@variable.member', { ctermfg = c(1, 1) })
  hi('@constant.builtin', { ctermfg = c(5, 5) })
  hi('@string.regexp', { ctermfg = c(1, 1) })
  hi('@string.escape', { ctermfg = c(6, 6) })
  hi('@string.special.url', { ctermfg = c(4, 4), underline = true })
  hi('@string.special.symbol', { ctermfg = c(13, 5) })
  hi('@type.builtin', { ctermfg = c(3, 3) })
  hi('@property', { ctermfg = c(1, 1) })
  hi('@function.builtin', { ctermfg = c(5, 5) })
  hi('@constructor', { ctermfg = c(11, 3) })
  hi('@keyword.coroutine', { ctermfg = c(1, 1) })
  hi('@keyword.function', { ctermfg = c(5, 5) })
  hi('@keyword.return', { ctermfg = c(5, 5) })
  hi('@keyword.export', { ctermfg = c(14, 6) })
  hi('@punctuation.bracket', { ctermfg = c(15, 0) })
  hi('@comment.error', { ctermbg = c(9, 1), ctermfg = c(0, 15) })
  hi('@comment.warning', { ctermbg = c(11, 3), ctermfg = c(0, 15) })
  hi('@comment.todo', { ctermbg = c(12, 4), ctermfg = c(0, 15) })
  hi('@comment.note', { ctermbg = c(14, 6), ctermfg = c(0, 15) })
  hi('@markup', { ctermfg = c(15, 0) })
  hi('@markup.strong', { ctermfg = c(15, 0), bold = true })
  hi('@markup.italic', { ctermfg = c(15, 0), italic = true })
  hi('@markup.strikethrough', { ctermfg = c(15, 0), strikethrough = true })
  hi('@markup.heading', { ctermfg = c(4, 4), bold = true })
  hi('@markup.quote', { ctermfg = c(6, 6) })
  hi('@markup.math', { ctermfg = c(4, 4) })
  hi('@markup.link.url', { ctermfg = c(5, 5), underline = true })
  hi('@markup.raw', { ctermfg = c(14, 6) })
  hi('@markup.list.checked', { ctermfg = c(2, 2) })
  hi('@markup.list.unchecked', { ctermfg = c(7, 8) })
  hi('@tag', { ctermfg = c(5, 5) })
  hi('@tag.builtin', { ctermfg = c(6, 6) })
  hi('@tag.attribute', { ctermfg = c(4, 4) })
  hi('@tag.delimiter', { ctermfg = c(15, 0) })

  -- Links (using vim.api.nvim_set_hl with link parameter)
  hi('@variable.parameter.builtin', { link = '@variable.parameter' })
  hi('@constant', { link = 'Constant' })
  hi('@constant.macro', { link = 'Macro' })
  hi('@module', { link = 'Structure' })
  hi('@module.builtin', { link = 'Special' })
  hi('@label', { link = 'Label' })
  hi('@string', { link = 'String' })
  hi('@string.special', { link = 'Special' })
  hi('@character', { link = 'Character' })
  hi('@character.special', { link = 'SpecialChar' })
  hi('@boolean', { link = 'Boolean' })
  hi('@number', { link = 'Number' })
  hi('@number.float', { link = 'Float' })
  hi('@type', { link = 'Type' })
  hi('@type.definition', { link = 'Type' })
  hi('@attribute', { link = 'Constant' })
  hi('@attribute.builtin', { link = 'Constant' })
  hi('@function', { link = 'Function' })
  hi('@function.call', { link = 'Function' })
  hi('@function.method', { link = 'Function' })
  hi('@function.method.call', { link = 'Function' })
  hi('@operator', { link = 'Operator' })
  hi('@keyword', { link = 'Keyword' })
  hi('@keyword.operator', { link = 'Operator' })
  hi('@keyword.import', { link = 'Include' })
  hi('@keyword.type', { link = 'Keyword' })
  hi('@keyword.modifier', { link = 'Keyword' })
  hi('@keyword.repeat', { link = 'Repeat' })
  hi('@keyword.debug', { link = 'Exception' })
  hi('@keyword.exception', { link = 'Exception' })
  hi('@keyword.conditional', { link = 'Conditional' })
  hi('@keyword.conditional.ternary', { link = 'Operator' })
  hi('@keyword.directive', { link = 'PreProc' })
  hi('@keyword.directive.define', { link = 'Define' })
  hi('@punctuation.delimiter', { link = 'Delimiter' })
  hi('@punctuation.special', { link = 'Special' })
  hi('@comment', { link = 'Comment' })
  hi('@comment.documentation', { link = 'Comment' })
  hi('@markup.underline', { underline = true })
  hi('@markup.link', { link = 'Tag' })
  hi('@markup.link.label', { link = 'Label' })
  hi('@markup.list', { link = 'Special' })
  hi('@diff.plus', { link = 'diffAdded' })
  hi('@diff.minus', { link = 'diffRemoved' })
  hi('@diff.delta', { link = 'diffChanged' })
end

M.setup()

-- Also support being called as a module
return M
