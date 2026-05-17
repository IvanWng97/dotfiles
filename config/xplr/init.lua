version = "0.20.0"

local xplr = xplr

local home = os.getenv("HOME")
local xpm_path = home .. "/.local/share/xplr/dtomvan/xpm.xplr"
local xpm_url = "https://github.com/dtomvan/xpm.xplr"

package.path = package.path .. ";" .. xpm_path .. "/?.lua;" .. xpm_path .. "/?/init.lua"

os.execute(string.format("[ -e '%s' ] || git clone '%s' '%s'", xpm_path, xpm_url, xpm_path))

-- Plugins
xplr.config.modes.builtin.default.key_bindings.on_key.x = {
	help = "xpm",
	messages = {
		"PopMode",
		{ SwitchModeCustom = "xpm" },
	},
}

require("xpm").setup({
	auto_install = true,
	auto_cleanup = true,
	plugins = {
		-- Let xpm manage itself
		"dtomvan/xpm.xplr",
		"sayanarijit/tri-pane.xplr",
		"prncss-xyz/icons.xplr",
		"sayanarijit/zentable.xplr",
		{
			"sayanarijit/zoxide.xplr",
			setup = function()
				require("zoxide").setup({
					key = "z",
				})
			end,
		},

		{
			name = "sayanarijit/fzf.xplr",
			setup = function()
				require("fzf").setup({
					recursive = true,
					enter_dir = true,
				})
			end,
		},
	},
})

xplr.config.general.enable_mouse = true
xplr.config.general.show_hidden = true

xplr.config.general.selection_ui.style = {
	fg = "DarkGray",
	add_modifiers = {},
}

xplr.config.general.focus_selection_ui.style = {
	fg = "DarkGray",
	add_modifiers = { "Bold" },
}

xplr.config.modes.builtin.default.key_bindings.on_key["o"] = {
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
}

xplr.config.modes.builtin.default.key_bindings.on_key["e"] = {
	help = "open in editor",
	messages = {
		{
			BashExec0 = [===[
              ${EDITOR:-vi} "${XPLR_FOCUS_PATH:?}"
            ]===],
		},
		"PopMode",
	},
}
