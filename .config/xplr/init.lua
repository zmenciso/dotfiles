version = "0.21.1"

local home = os.getenv("HOME")
package.path = home
  .. "/.config/xplr/plugins/?/init.lua;"
  .. home
  .. "/.config/xplr/plugins/?.lua;"
  .. package.path

xplr.config.node_types.directory.meta.icon = ""
xplr.config.node_types.file.meta.icon = ""
xplr.config.node_types.symlink.meta.icon = ""

local function stat(node)
  return node.mime_essence
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

-- The default layout
--
-- Type: [Layout](https://xplr.dev/en/layout)
xplr.config.layouts.builtin.default = {
  Horizontal = {
    config = {
      constraints = {
        { Percentage = 60 },
        { Percentage = 40 },
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
              { Percentage = 40 },
              { Percentage = 40 },
              { Percentage = 20 },
            },
          },
          splits = {
            "Selection",
			{
			  CustomContent = {
			    title = "Preview",
			    body = { DynamicParagraph = { render = "custom.preview_pane.render" } },
			  },
			},
            "HelpMenu",
          },
        },
      },
    },
  },
}

xplr.fn.custom.preview_pane = {}
xplr.fn.custom.preview_pane.render = function(ctx)
  local n = ctx.app.focused_node

  if n and n.canonical then
    n = n.canonical
  end

  if n then
    if n.is_file then
      return read(n.absolute_path, ctx.layout_size.height)
    else
      return stat(n)
    end
  else
    return ""
  end
end

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

-- The builtin create mode.
--
-- Type: [Mode](https://xplr.dev/en/mode)
xplr.config.modes.builtin.create = {
  name = "create",
  key_bindings = {
    on_key = {
      ["d"] = {
        help = "create directory",
        messages = {
          "PopMode",
          { SwitchModeBuiltin = "create_directory" },
          { SetInputBuffer = "" },
        },
      },
      ["f"] = {
        help = "create file",
        messages = {
          "PopMode",
          { SwitchModeBuiltin = "create_file" },
          { SetInputBuffer = "" },
        },
      },
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
          { CallLuaSilently = "builtin.try_complete_path" },
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
          { CallLuaSilently = "builtin.try_complete_path" },
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

-- The builtin action mode.
--
-- Type: [Mode](https://xplr.dev/en/mode)
xplr.config.modes.builtin.action = {
  name = "action to",
  key_bindings = {
    on_key = {
      ["!"] = {
        help = "shell",
        messages = {
          "PopMode",
          { Call0 = { command = os.getenv("SHELL") or "bash", args = { "-i" } } },
          "ExplorePwdAsync",
        },
      },
      ["c"] = {
        help = "create",
        messages = {
          "PopMode",
          { SwitchModeBuiltin = "create" },
        },
      },
      ["e"] = {
        help = "open in editor",
        messages = {
          {
            BashExec0 = [===[
              ${EDITOR:-vi} "${XPLR_FOCUS_PATH:?}"
            ]===],
          },
          "PopMode",
        },
      },
      ["l"] = {
        help = "logs",
        messages = {
          {
            BashExec = [===[
              [ -z "$PAGER" ] && PAGER="less -+F"
              cat -- "${XPLR_PIPE_LOGS_OUT}" | ${PAGER:?}
            ]===],
          },
          "PopMode",
        },
      },
      ["s"] = {
        help = "selection operations",
        messages = {
          "PopMode",
          { SwitchModeBuiltin = "selection_ops" },
        },
      },
      ["m"] = {
        help = "toggle mouse",
        messages = {
          "PopMode",
          "ToggleMouse",
        },
      },
      ["p"] = {
        help = "edit permissions",
        messages = {
          "PopMode",
          { SwitchModeBuiltin = "edit_permissions" },
          {
            BashExecSilently0 = [===[
              PERM=$(stat -c '%a' -- "${XPLR_FOCUS_PATH:?}")
              "$XPLR" -m 'SetInputBuffer: %q' "${PERM:?}"
            ]===],
          },
        },
      },
      ["v"] = {
        help = "vroot",
        messages = {
          "PopMode",
          { SwitchModeBuiltin = "vroot" },
        },
      },
      ["q"] = {
        help = "quit options",
        messages = {
          "PopMode",
          { SwitchModeBuiltin = "quit" },
        },
      },
    },
    on_number = {
      help = "go to index",
      messages = {
        "PopMode",
        { SwitchModeBuiltin = "number" },
        "BufferInputFromKey",
      },
    },
  },
}

-- The builtin selection ops mode.
--
-- Type: [Mode](https://xplr.dev/en/mode)
xplr.config.modes.builtin.selection_ops = {
  name = "selection ops",
  key_bindings = {
    on_key = {
      ["e"] = {
        help = "edit selection",
        messages = {
          {
            BashExec0 = [===[
              TMPFILE="$(mktemp)"
              (while IFS= read -r -d '' PTH; do
                echo $(printf %q "${PTH:?}") >> "${TMPFILE:?}"
              done < "${XPLR_PIPE_SELECTION_OUT:?}")
              ${EDITOR:-vi} "${TMPFILE:?}"
              [ ! -e "$TMPFILE" ] && exit
              "$XPLR" -m ClearSelection
              (while IFS= read -r PTH_ESC; do
                "$XPLR" -m 'SelectPath: %q' "$(eval printf %s ${PTH_ESC:?})"
              done < "${TMPFILE:?}")
              rm -- "${TMPFILE:?}"
            ]===],
          },
          "PopMode",
        },
      },
      ["l"] = {
        help = "list selection",
        messages = {
          {
            BashExec0 = [===[
              [ -z "$PAGER" ] && PAGER="less -+F"

              while IFS= read -r -d '' PTH; do
                echo $(printf %q "$PTH")
              done < "${XPLR_PIPE_SELECTION_OUT:?}" | ${PAGER:?}
            ]===],
          },
          "PopMode",
        },
      },
      ["c"] = {
        help = "copy here",
        messages = {
          {
            BashExec0 = [===[
              "$XPLR" -m ExplorePwd
              (while IFS= read -r -d '' PTH; do
                PTH_ESC=$(printf %q "$PTH")
                BASENAME=$(basename -- "$PTH")
                BASENAME_ESC=$(printf %q "$BASENAME")
                while [ -e "$BASENAME" ]; do
                  BASENAME="$BASENAME (copied)"
                  BASENAME_ESC=$(printf %q "$BASENAME")
                done
                if cp -vr -- "${PTH:?}" "./${BASENAME:?}"; then
                  "$XPLR" -m 'LogSuccess: %q' "$PTH_ESC copied to ./$BASENAME_ESC"
                  "$XPLR" -m 'FocusPath: %q' "$BASENAME"
                else
                  "$XPLR" -m 'LogError: %q' "could not copy $PTH_ESC to ./$BASENAME_ESC"
                fi
              done < "${XPLR_PIPE_SELECTION_OUT:?}")
              read -p "[enter to continue]"
            ]===],
          },
          "PopMode",
        },
      },
      ["m"] = {
        help = "move here",
        messages = {
          {
            BashExec0 = [===[
              "$XPLR" -m ExplorePwd
              (while IFS= read -r -d '' PTH; do
                PTH_ESC=$(printf %q "$PTH")
                BASENAME=$(basename -- "$PTH")
                BASENAME_ESC=$(printf %q "$BASENAME")
                while [ -e "$BASENAME" ]; do
                  BASENAME="$BASENAME (moved)"
                  BASENAME_ESC=$(printf %q "$BASENAME")
                done
                if mv -v -- "${PTH:?}" "./${BASENAME:?}"; then
                  "$XPLR" -m 'LogSuccess: %q' "$PTH_ESC moved to ./$BASENAME_ESC"
                  "$XPLR" -m 'FocusPath: %q' "$BASENAME"
                else
                  "$XPLR" -m 'LogError: %q' "could not move $PTH_ESC to ./$BASENAME_ESC"
                fi
              done < "${XPLR_PIPE_SELECTION_OUT:?}")
              read -p "[enter to continue]"
            ]===],
          },
          "PopMode",
        },
      },
      ["s"] = {
        help = "softlink here",
        messages = {
          {
            BashExec0 = [===[
              "$XPLR" -m ExplorePwd
              (while IFS= read -r -d '' PTH; do
                PTH_ESC=$(printf %q "$PTH")
                BASENAME=$(basename -- "$PTH")
                BASENAME_ESC=$(printf %q "$BASENAME")
                while [ -e "$BASENAME" ]; do
                  BASENAME="$BASENAME (softlinked)"
                  BASENAME_ESC=$(printf %q "$BASENAME")
                done
                if ln -sv -- "${PTH:?}" "./${BASENAME:?}"; then
                  "$XPLR" -m 'LogSuccess: %q' "$PTH_ESC softlinked as ./$BASENAME_ESC"
                  "$XPLR" -m 'FocusPath: %q' "$BASENAME"
                else
                  "$XPLR" -m 'LogError: %q' "could not softlink $PTH_ESC as ./$BASENAME_ESC"
                fi
              done < "${XPLR_PIPE_SELECTION_OUT:?}")
              read -p "[enter to continue]"
            ]===],
          },
          "PopMode",
        },
      },
      ["h"] = {
        help = "hardlink here",
        messages = {
          {
            BashExec0 = [===[
              "$XPLR" -m ExplorePwd
              (while IFS= read -r -d '' PTH; do
                PTH_ESC=$(printf %q "$PTH")
                BASENAME=$(basename -- "$PTH")
                BASENAME_ESC=$(printf %q "$BASENAME")
                while [ -e "$BASENAME" ]; do
                  BASENAME="$BASENAME (hardlinked)"
                  BASENAME_ESC=$(printf %q "$BASENAME")
                done
                if ln -v -- "${PTH:?}" "./${BASENAME:?}"; then
                  "$XPLR" -m 'LogSuccess: %q' "$PTH_ESC hardlinked as ./$BASENAME_ESC"
                  "$XPLR" -m 'FocusPath: %q' "$BASENAME"
                else
                  "$XPLR" -m 'LogError: %q' "could not hardlink $PTH_ESC as ./$BASENAME_ESC"
                fi
              done < "${XPLR_PIPE_SELECTION_OUT:?}")
              read -p "[enter to continue]"
            ]===],
          },
          "PopMode",
        },
      },
      ["u"] = {
        help = "clear selection",
        messages = {
          "ClearSelection",
          "PopMode",
        },
      },
    },
  },
}

-- The builtin go to mode.
--
-- Type: [Mode](https://xplr.dev/en/mode)
xplr.config.modes.builtin.go_to = {
  name = "go to",
  key_bindings = {
    on_key = {
      ["f"] = {
        help = "follow symlink",
        messages = {
          "FollowSymlink",
          "PopMode",
        },
      },
      ["g"] = {
        help = "top",
        messages = {
          "FocusFirst",
          "PopMode",
        },
      },
      ["p"] = {
        help = "path",
        messages = {
          "PopMode",
          { SwitchModeBuiltin = "go_to_path" },
          { SetInputBuffer = "" },
        },
      },
      ["i"] = {
        help = "initial $PWD",
        messages = {
          "PopMode",
          {
            BashExecSilently0 = [===[
              "$XPLR" -m 'ChangeDirectory: %q' "${XPLR_INITIAL_PWD:?}"
            ]===],
          },
        },
      },
      ["x"] = {
        help = "open in gui",
        messages = {
          {
            BashExecSilently0 = [===[
              if [ -z "$OPENER" ]; then
                if command -v xdg-open; then
                  OPENER=xdg-open
                elif command -v open; then
                  OPENER=open
                else
                  "$XPLR" -m 'LogError: %q' "$OPENER not found"
                  exit 1
                fi
              fi
              (while IFS= read -r -d '' PTH; do
                $OPENER "${PTH:?}" > /dev/null 2>&1
              done < "${XPLR_PIPE_RESULT_OUT:?}")
            ]===],
          },
          "ClearScreen",
          "PopMode",
        },
      },
    },
  },
}

-- The builtin delete mode.
--
-- Type: [Mode](https://xplr.dev/en/mode)
xplr.config.modes.builtin.delete = {
  name = "delete",
  key_bindings = {
    on_key = {
      ["D"] = {
        help = "force delete",
        messages = {
          {
            BashExec0 = [===[
              "$XPLR" -m ExplorePwd
              (while IFS= read -r -d '' PTH; do
                PTH_ESC=$(printf %q "$PTH")
                if rm -rfv -- "${PTH:?}"; then
                  "$XPLR" -m 'LogSuccess: %q' "$PTH_ESC deleted"
                else
                  "$XPLR" -m 'LogError: %q' "could not delete $PTH_ESC"
                  "$XPLR" -m 'FocusPath: %q' "$PTH"
                fi
              done < "${XPLR_PIPE_RESULT_OUT:?}")
              read -p "[enter to continue]"
            ]===],
          },
          "PopMode",
        },
      },
      ["d"] = {
        help = "delete",
        messages = {
          {
            BashExec0 = [===[
              "$XPLR" -m ExplorePwd
              (while IFS= read -r -d '' PTH; do
                PTH_ESC=$(printf %q "$PTH")
                if [ -d "$PTH" ] && [ ! -L "$PTH" ]; then
                  if rmdir -v -- "${PTH:?}"; then
                    "$XPLR" -m 'LogSuccess: %q' "$PTH_ESC deleted"
                  else
                    "$XPLR" -m 'LogError: %q' "could not delete $PTH_ESC"
                    "$XPLR" -m 'FocusPath: %q' "$PTH"
                  fi
                else
                  if rm -v -- "${PTH:?}"; then
                    "$XPLR" -m 'LogSuccess: %q' "$PTH_ESC deleted"
                  else
                    "$XPLR" -m 'LogError: %q' "could not delete $PTH_ESC"
                    "$XPLR" -m 'FocusPath: %q' "$PTH"
                  fi
                fi
              done < "${XPLR_PIPE_RESULT_OUT:?}")
              read -p "[enter to continue]"
            ]===],
          },
          "PopMode",
        },
      },
    },
  },
}

-- The builtin switch layout mode.
--
-- Type: [Mode](https://xplr.dev/en/mode)
xplr.config.modes.builtin.switch_layout = {
  name = "switch layout",
  key_bindings = {
    on_key = {
      ["1"] = {
        help = "default",
        messages = {
          { SwitchLayoutBuiltin = "default" },
          "PopMode",
        },
      },
      ["2"] = {
        help = "no help menu",
        messages = {
          { SwitchLayoutBuiltin = "no_help" },
          "PopMode",
        },
      },
      ["3"] = {
        help = "no selection panel",
        messages = {
          { SwitchLayoutBuiltin = "no_selection" },
          "PopMode",
        },
      },
      ["4"] = {
        help = "no help or selection",
        messages = {
          { SwitchLayoutBuiltin = "no_help_no_selection" },
          "PopMode",
        },
      },
    },
  },
}

require("dual-pane").setup{
  active_pane_width = { Percentage = 70 },
  inactive_pane_width = { Percentage = 30 },
}


-- require("map").setup{
--   mode = "default",  -- or `xplr.config.modes.builtin.default`
--   key = "M",
--   editor = os.getenv("EDITOR") or "vim",
--   editor_key = "ctrl-o",
--   prefer_multi_map = false,
--   placeholder = "{}",
--   spacer = "{_}",
--   custom_placeholders = {
--     ["{ext}"] = function(node)
--       -- See https://xplr.dev/en/lua-function-calls#node
--       return xplr.util.shell_quote(node.extension)
--     end,

--     ["{name}"] = map.placeholders["{name}"],
--   },
-- }

-- Type `M` to switch to single map mode.
-- Then press `tab` to switch between single and multi map modes.
-- Press `ctrl-o` to edit the command using your editor.


require("scp").setup{
  mode = "selection_ops",  -- or `xplr.config.modes.builtin.selection_ops`
  key = "S",
  scp_command = "scp -r",
  non_interactive = false,
  keep_selection = false,
}

-- Type `:sS` and send the selected files.
-- Make sure `~/.ssh/config` or `/etc/ssh/ssh_config` is updated.
-- Else you'll need to enter each host manually.


require("xclip").setup{
  copy_command = "xclip-copyfile",
  copy_paths_command = "xclip -sel clip",
  paste_command = "xclip-pastefile",
  keep_selection = false,
}

-- Type `yy` to copy and `p` to paste whole files.
-- Type `yp` to copy the paths of focused or selected files.
-- Type `yP` to copy the parent directory path.
