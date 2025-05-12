version = "1.0.0"

local home = os.getenv("HOME")
package.path = home
  .. "/.config/xplr/plugins/?/init.lua;"
  .. home
  .. "/.config/xplr/plugins/?.lua;"
  .. package.path

xplr.config.node_types.directory.meta.icon = ""
xplr.config.node_types.file.meta.icon = ""
xplr.config.node_types.symlink.meta.icon = ""

xplr.config.node_types.extension.rs = { meta = { icon = "" } }
xplr.config.node_types.extension.py = { meta = { icon = "" } }
xplr.config.node_types.extension.png = { meta = { icon = "" } }
xplr.config.node_types.extension.jpg = { meta = { icon = "" } }
xplr.config.node_types.extension.svg = { meta = { icon = "" } }
xplr.config.node_types.extension.tex = { meta = { icon = "" } }
xplr.config.node_types.extension.md = { meta = { icon = "" } }
xplr.config.node_types.extension.html = { meta = { icon = "" } }
xplr.config.node_types.extension.docx = { meta = { icon = "" } }
xplr.config.node_types.extension.pptx = { meta = { icon = "" } }
xplr.config.node_types.extension.csv = { meta = { icon = "" } }
xplr.config.node_types.extension.xlsx = { meta = { icon = "" } }
xplr.config.node_types.extension.conf = { meta = { icon = "" } }

xplr.config.modes.builtin.go_to.key_bindings.on_key.h = {
	help = "history",
	messages = {
		"PopMode",
		{
			BashExec0 = [===[
			PTH=$(cat "${XPLR_PIPE_HISTORY_OUT:?}" | sort -z -u | fzf --read0)
			if [ "$PTH" ]; then
				"$XPLR" -m 'ChangeDirectory: %q' "$PTH"
				fi
				]===],
			},
		},
	}

xplr.config.modes.builtin.default.key_bindings.on_key.m = {
	help = "bookmark",
	messages = {
		{
			BashExecSilently0 = [===[
			PTH="${XPLR_FOCUS_PATH:?}"
			PTH_ESC=$(printf %q "$PTH")
			if echo "${PTH:?}" >> "${XPLR_SESSION_PATH:?}/bookmarks"; then
				"$XPLR" -m 'LogSuccess: %q' "$PTH_ESC added to bookmarks"
			else
				"$XPLR" -m 'LogError: %q' "Failed to bookmark $PTH_ESC"
				fi
				]===],
			},
		},
	}

	xplr.config.modes.builtin.default.key_bindings.on_key["`"] = {
		help = "go to bookmark",
		messages = {
			{
				BashExec0 = [===[
				PTH=$(cat "${XPLR_SESSION_PATH:?}/bookmarks" | fzf --no-sort)
				PTH_ESC=$(printf %q "$PTH")
				if [ "$PTH" ]; then
					"$XPLR" -m 'FocusPath: %q' "$PTH"
					fi
					]===],
				},
			},
		}

local function stat(node)
	return xplr.util.to_yaml(xplr.util.node(node.absolute_path))
end

local function read(path, height)
	local p = io.open(path)

	if p == nil then
		return nil
	end

	local i = 0
	local res = ""
	for line in p:lines() do
		if line:match("[^ -~\n\t]") then
			p:close()
			return
		end

		res = res .. line .. "\n"
		if i == height then
			break
		end
		i = i + 1
	end
	p:close()

	return res
end

xplr.fn.custom.preview_pane = {}
xplr.fn.custom.preview_pane.render = function(ctx)
	local title = nil
	local body = ""
	local n = ctx.app.focused_node
	if n and n.canonical then
		n = n.canonical
	end

	if n then
		title = { format = n.absolute_path, style = xplr.util.lscolor(n.absolute_path) }
		if n.is_file then
			body = read(n.absolute_path, ctx.layout_size.height) or stat(n)
		else
			body = stat(n)
		end
	end

	return { CustomParagraph = { ui = { title = title }, body = body } }
end

local preview_pane = { Dynamic = "custom.preview_pane.render" }
local split_preview = {
	Horizontal = {
		config = {
			constraints = {
				{ Percentage = 60 },
				{ Percentage = 40 },
			},
		},
		splits = {
			"Table",
			preview_pane,
		},
	},
}

xplr.config.layouts.builtin.default = {
	Horizontal = {
		config = {
			constraints = {
				{ Percentage = 70 },
				{ Percentage = 30 },
			},
		},
		splits = {
			{
				Vertical = {
					config = {
						constraints = {
							{ Length = 3 },
							{ Min = 1 },
							{ Length = 3 },
						},
					},
					splits = {
						"SortAndFilter",
						"Table",
						"InputAndLogs",
					},
				},
			},
			{
				Vertical = {
					config = {
						constraints = {
							{ Percentage = 30 },
							{ Percentage = 70 },
						},
					},
					splits = {
						"Selection",
						preview_pane,
					},
				},
			},
		},
	},
}

-- xplr.config.layouts.builtin.default = xplr.util.layout_replace(xplr.config.layouts.builtin.default, "Table", split_preview)

xplr.config.modes.builtin.default.key_bindings.on_key.R = {
	help = "batch rename",
	messages = {
		{
			BashExec = [===[
			SELECTION=$(cat "${XPLR_PIPE_SELECTION_OUT:?}")
			NODES=${SELECTION:-$(cat "${XPLR_PIPE_DIRECTORY_NODES_OUT:?}")}
			if [ "$NODES" ]; then
				echo -e "$NODES" | renamer
				"$XPLR" -m ExplorePwdAsync
				fi
				]===],
			},
		},
	}

-- The builtin create directory mode.
--
-- Type: [Mode](https://xplr.dev/en/mode)
xplr.config.modes.builtin.create_directory = {
	name = "create directory",
	prompt = " ❯ ",
	key_bindings = {
		on_key = {
			["tab"] = {
				help = "try complete",
				messages = {
					"TryCompletePath",
				},
			},
			["enter"] = {
				help = "submit",
				messages = {
					{
						BashExecSilently0 = [===[
						PTH="$XPLR_INPUT_BUFFER"
						PTH_ESC=$(printf %q "$PTH")
						if [ "$PTH" ]; then
							mkdir -p -- "$PTH" \
							&& "$XPLR" -m 'SetInputBuffer: ""' \
							&& "$XPLR" -m ExplorePwd \
							&& "$XPLR" -m 'LogSuccess: %q' "$PTH_ESC created" \
							&& "$XPLR" -m 'FocusPath: %q' "$PTH"
						else
							"$XPLR" -m PopMode
							fi
							]===],
						},
					},
				},
			},
			default = {
				messages = {
					"UpdateInputBufferFromKey",
				},
			},
		},
	}

-- The builtin create file mode.
--
-- Type: [Mode](https://xplr.dev/en/mode)
xplr.config.modes.builtin.create_file = {
	name = "create file",
	prompt = " ❯ ",
	key_bindings = {
		on_key = {
			["tab"] = {
				help = "try complete",
				messages = {
					"TryCompletePath",
				},
			},
			["enter"] = {
				help = "submit",
				messages = {
					{
						BashExecSilently0 = [===[
						PTH="$XPLR_INPUT_BUFFER"
						PTH_ESC=$(printf %q "$PTH")
						if [ "$PTH" ]; then
							mkdir -p -- "$(dirname $(realpath -m $PTH))"  # This may fail.
							touch -- "$PTH" \
							&& "$XPLR" -m 'SetInputBuffer: ""' \
							&& "$XPLR" -m 'LogSuccess: %q' "$PTH_ESC created" \
							&& "$XPLR" -m 'ExplorePwd' \
							&& "$XPLR" -m 'FocusPath: %q' "$PTH"
						else
							"$XPLR" -m PopMode
							fi
							]===],
						},
					},
				},
			},
			default = {
				messages = {
					"UpdateInputBufferFromKey",
				},
			},
		},
	}

require("dual-pane").setup{
	active_pane_width = { Percentage = 60 },
	inactive_pane_width = { Percentage = 40 },
}

local map = require("map")
map.setup{
	mode = "default",  -- or `xplr.config.modes.builtin.default`
	key = "M",
	editor = os.getenv("EDITOR") or "vim",
	editor_key = "ctrl-o",
	prefer_multi_map = false,
	placeholder = "{}",
	spacer = "{_}",
	custom_placeholders = map.placeholders,
}

-- Type `M` to switch to single map mode.
-- Then press `tab` to switch between single and multi map modes.
-- Press `ctrl-o` to edit the command using your editor.
--
require("scp").setup{
	mode = "selection_ops",  -- or `xplr.config.modes.builtin.selection_ops`
	key = "S",
	scp_command = "hpnscp -r",
	non_interactive = false,
	keep_selection = false,
}

-- Type `:sS` and send the selected files.
-- Make sure `~/.ssh/config` or `/etc/ssh/ssh_config` is updated.
-- Else you'll need to enter each host manually.

require("wl-clipboard").setup{
	copy_command = "wl-copy -t text/uri-list",
	paste_command = "wl-paste",
	keep_selection = false,
}

-- Type `yy` to copy and `p` to paste files.

require("fzf").setup{
	mode = "default",
	key = "ctrl-f",
	bin = "fzf",
	args = "--preview 'pistol {}'",
	recursive = false,  -- If true, search all files under $PWD
	enter_dir = false,  -- Enter if the result is directory
}

-- Press `ctrl-f` to spawn fzf in $PWD

require("dua-cli").setup{
	mode = "action",
	key = "D",
}

-- Type `:D` to spawn dua-cli in $PWD
