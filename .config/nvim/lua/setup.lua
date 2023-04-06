-------------------------------------------------------------------------------
-- Plugin Configuration
-------------------------------------------------------------------------------

local lspconfig = require('lspconfig')

local border = {'╭', '─', '╮', '│', '╯', '─', '╰', '│'}
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts = opts or {}
	opts.border = opts.border or border
	return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- Don't forget to add language servers to the autocompletion config!
-- :help lspconfig-all
require('lspconfig').pylsp.setup{}			-- pip install "python-lsp-server[all]"
require('lspconfig').clangd.setup{}
require('lspconfig').cmake.setup{}
require('lspconfig').svlangserver.setup{}	-- npm install -g @imc-trading/svlangserver
require('lspconfig').marksman.setup{}
-- require('lspconfig').rust_analyzer.setup{}
require('lspconfig').texlab.setup{}

-- lsp_signature
-- https://github.com/ray-x/lsp_signature.nvim#full-configuration-with-default-values
local on_attach_lsp_signature = function(client, bufnr)
require('lsp_signature').on_attach({
	bind = true, -- This is mandatory, otherwise border config won't get registered.
	floating_window = true,
	zindex = 99,     -- <100 so that it does not hide completion popup.
	fix_pos = false, -- Let signature window change its position when needed, see GH-53
	toggle_key = '<M-x>',  -- Press <Alt-x> to toggle signature on and off.
})
end

-- Customize LSP behavior
-- [[ A callback executed when LSP engine attaches to a buffer. ]]
local on_attach = function(client, bufnr)
-- Always use signcolumn for the current buffer
vim.wo.signcolumn = 'yes:1'

-- Activate LSP signature on attach.
on_attach_lsp_signature(client, bufnr)

-- Activate LSP status on attach (see a configuration below).
require('lsp-status').on_attach(client)

-- Keybindings
-- https://github.com/neovim/nvim-lspconfig#keybindings-and-completion
local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
local opts = { noremap=true, silent=true }

-- See `:help vim.lsp.*` for documentation on any of the below functions
buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)

if vim.fn.exists(':Telescope') then
	buf_set_keymap('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
	buf_set_keymap('n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts)
	buf_set_keymap('n', 'gi', '<cmd>Telescope lsp_implementations<CR>', opts)
else
	buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
end

buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
--buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
--buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
--buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
--buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
--buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
--buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
--buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
--buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
--buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
--buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

-- Add global keymappings for LSP actions
-- F3, F12: goto definition
-- map('', '<F12>', 'gd', {})
-- map('i', '<F12>', '<ESC>gd', {})
-- map('', '<F3>', '<F12>', {})
-- map('i', '<F3>', '<F12>', {})

-- Shift+F12: show usages/references
-- map('', '<F24>', 'gr', {})
-- map('i', '<F24>', '<ESC>gr', {})

-------------------------------------------------------------------------------
-- LSP Handlers (general)
-------------------------------------------------------------------------------
-- :help lsp-method
-- :help lsp-handler

local lsp_handlers_hover = vim.lsp.with(vim.lsp.handlers.hover, {
	border = 'none'
})
vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
	local bufnr, winnr = lsp_handlers_hover(err, result, ctx, config)
	if winnr ~= nil then
vim.api.nvim_win_set_option(winnr, "winblend", 20)  -- opacity for hover
	end
	return bufnr, winnr
end

-------------------------------------------------------------------------------
-- LSP diagnostics
-------------------------------------------------------------------------------
-- https://github.com/neovim/nvim-lspconfig/wiki/UI-customization

-- Customize how to show diagnostics:
-- @see https://github.com/neovim/neovim/pull/16057 for new APIs
vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	float = {
		source = 'always',
		focusable = false,   -- See neovim#16425
	},
	severity_sort = true,
	update_in_insert = false
})

_G.LspDiagnosticsShowPopup = function()
	return vim.diagnostic.open_float(0, {scope="cursor"})
end

-- Show diagnostics in a pop-up window on hover
_G.LspDiagnosticsPopupHandler = function()
	local current_cursor = vim.api.nvim_win_get_cursor(0)
	local last_popup_cursor = vim.w.lsp_diagnostics_last_cursor or {nil, nil}

	-- Show the popup diagnostics window,
	-- but only once for the current cursor location (unless moved afterwards).
	if not (current_cursor[1] == last_popup_cursor[1] and current_cursor[2] == last_popup_cursor[2]) then
		vim.w.lsp_diagnostics_last_cursor = current_cursor
		local _, winnr = _G.LspDiagnosticsShowPopup()
	end
end

vim.cmd [[
augroup LSPDiagnosticsOnHover
	autocmd!
	autocmd CursorHold *   lua _G.LspDiagnosticsPopupHandler()
augroup END
]]

-- Redfine diagnostic colors
-- vim.cmd [[
-- hi DiagnosticError		guifg=#e6645f ctermfg=167
-- hi DiagnosticWarn		guifg=#e5c07b ctermfg=180
-- hi DiagnosticHint		guifg=#98c379 ctermfg=114
-- hi DiagnosticInfo		guifg=#61afef ctermfg=75
-- ]]

-- Redefine signs (:help diagnostic-signs)
-- neovim >= 0.6.0
vim.fn.sign_define("DiagnosticSignError",  {text = " ", texthl = "DiagnosticSignError"})
vim.fn.sign_define("DiagnosticSignWarn",   {text = " ", texthl = "DiagnosticSignWarn"})
vim.fn.sign_define("DiagnosticSignInfo",   {text = " ", texthl = "DiagnosticSignInfo"})
vim.fn.sign_define("DiagnosticSignHint",   {text = " ", texthl = "DiagnosticSignHint"})

-------------------------------------------------------------------------------
-- nvim-cmp: completion support
-------------------------------------------------------------------------------
-- https://github.com/hrsh7th/nvim-cmp#recommended-configuration
-- ~/.vim/plugged/nvim-cmp/lua/cmp/config/default.lua

vim.o.completeopt = "menu,menuone,noselect"

local has_words_before = function()
	if vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt' then
		return false
	end

	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line-1, line, true)[1]:sub(col, col):match('%s') == nil
end

local kind_icons = {
	Text = "",
	Method = "",
	Function = "",
	Constructor = "",
	Field = "",
	Variable = "",
	Class = "ﴯ",
	Interface = "",
	Module = "",
	Property = "ﰠ",
	Unit = "",
	Value = "",
	Enum = "",
	Keyword = "",
	Snippet = "",
	Color = "",
	File = "",
	Reference = "",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "",
	Event = "",
	Operator = "",
	TypeParameter = ""
}

local winhighlight = {
  winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel",
}

local cmp = require('cmp')
local lspkind = require('lspkind')
cmp.setup {
	snippet = {
		expand = function(args)
		vim.fn["UltiSnips#Anon"](args.body)
		end,
	  },

	window = {
		completion = cmp.config.window.bordered(winhighlight),
		documentation = cmp.config.window.bordered(winhighlight),
	},

	mapping = {
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.close(),
		['<CR>'] = cmp.mapping.confirm({ select = false }),

		['<Tab>'] = function(fallback)  -- see GH-231, GH-286
			if cmp.visible() then cmp.select_next_item()
			elseif has_words_before() then cmp.complete()
			else fallback() end
		end,

		['<S-Tab>'] = function(fallback)
			if cmp.visible() then cmp.select_prev_item()
			else fallback() end
		end,
	},

	formatting = {
		format = lspkind.cmp_format({
			mode = "symbol_text",
			menu = ({
				buffer        = "[Buffer]",
				nvim_lsp      = "[LSP]",
				luasnip       = "[LuaSnip]",
				ultisnips     = "[UltiSnips]",
				nvim_lua      = "[Lua]",
				latex_symbols = "[Latex]",
			})
		}),
	},

	sources = {
		{ name = 'nvim_lsp', priority = 100 },
		{ name = 'ultisnips', keyword_length = 2, priority = 50 },
		{ name = 'path', priority = 30, },
		{ name = 'buffer', priority = 10 },
	},

	sorting = {
		comparators = {
			cmp.config.compare.offset,
			cmp.config.compare.exact,
			cmp.config.compare.score,
			cmp.config.compare.kind,
			cmp.config.compare.sort_text,
			cmp.config.compare.length,
			cmp.config.compare.order,
		},
	},
}

-- Highlights for nvim-cmp's custom popup menu (GH-224)
vim.cmd [[
  " To be compatible with Pmenu (#fff3bf)
  " hi CmpItemAbbr           guifg=#111111
  " hi CmpItemAbbrMatch      guifg=#f03e3e gui=bold
  " hi CmpItemAbbrMatchFuzzy guifg=#fd7e14 gui=bold
  " hi CmpItemAbbrDeprecated guifg=#adb5bd
  " hi CmpItemKindDefault    guifg=#cc5de8
  " hi! def link CmpItemKind CmpItemKindDefault
  " hi CmpItemMenu           guifg=#cfa050
]]

-------------------------------------------------------------------------------
-- LSPstatus
-------------------------------------------------------------------------------
local lsp_status = require('lsp-status')
lsp_status.config({
	-- Avoid using use emoji-like or full-width characters
	-- because it can often break rendering within tmux and some terminals
	-- See ~/.vim/plugged/lsp-status.nvim/lua/lsp-status.lua
	indicator_hint = '!',
	status_symbol = ' ',

	-- Automatically sets b:lsp_current_function
	current_function = true,
})

lsp_status.register_progress()

-- LspStatus(): status string for airline
_G.LspStatus = function()
	if #vim.lsp.buf_get_clients() > 0 then
		return lsp_status.status()
	end
	return ''
end

-- :LspStatus (command): display lsp status
vim.cmd [[
	command! -nargs=0 LspStatus   echom v:lua.LspStatus()
]]

-- Other LSP commands
vim.cmd [[
	command! -nargs=0 LspDebug  :tab drop $HOME/.cache/nvim/lsp.log
]]

-------------------------------------------------------------------------------
-- whichkey
-------------------------------------------------------------------------------
require('which-key').setup {}

-------------------------------------------------------------------------------
-- Telescope (requires ripgrep)
-------------------------------------------------------------------------------
require('telescope').setup {}

-------------------------------------------------------------------------------
-- Lualine
-------------------------------------------------------------------------------
require('lualine').setup{
	options = {
		icons_enabled = true,
		theme = 'auto',
		component_separators = { left = '', right = ''},
		section_separators = { left = '', right = ''},
		disabled_filetypes = {},
		always_divide_middle = true,
		globalstatus = true
	},

	sections = {
		lualine_a = {'mode'},
		lualine_b = {'branch', 'diff'},
		lualine_c = {
			{
				'diagnostics',
				sources={'nvim_lsp', 'coc'}
			}
		},
		lualine_x = {'encoding', 'fileformat', 'filetype'},
		lualine_y = {'progress'},
		lualine_z = {'location'}
	},

	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {'filename'},
		lualine_x = {'location'},
		lualine_y = {},
		lualine_z = {}
	},

	tabline = {
		lualine_a = {
			{
				'buffers',
				modified_status = true,
				symbols = {
					modified = ' ',      -- Text to show when the buffer is modified
					alternate_file = ' ', -- Text to show to identify the alternate file
					directory =  '',     -- Text to show when the buffer is a directory
				},
			}
		},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {'tabs'}
	},

	extensions = {}
}

-------------------------------------------------------------------------------
-- File manager support
-------------------------------------------------------------------------------
require('fm-nvim').setup{
	-- (Vim) Command used to open files
	edit_cmd = "edit",

	-- UI Options
	ui = {
		default = "float",
		float = {
			-- Floating window border (see ':h nvim_open_win')
			border    = "none",

			-- Highlight group for floating window/border (see ':h winhl')
			float_hl  = "Normal",
			border_hl = "FloatBorder",

			-- Floating Window Transparency (see ':h winblend')
			blend     = 0,

			-- Num from 0 - 1 for measurements
			height    = 0.85,
			width     = 0.85,

			-- X and Y Axis of Window
			x         = 0.5,
			y         = 0.5
		},

		split = {
			-- Direction of split
			direction = "topleft",

			-- Size of split
			size      = 24
		}
	},

	-- Terminal commands used w/ file manager (have to be in your $PATH)
	cmds = {
		xplr_cmd    = "xplr",
	},

	-- Mappings used with the plugin
	mappings = {
		vert_split = "<C-v>",
		horz_split = "<C-h>",
		tabedit    = "<C-t>",
		edit       = "<C-e>",
		ESC        = "<ESC>"
		},
}
