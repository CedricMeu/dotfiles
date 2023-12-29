local wezterm = require('wezterm')
local act = wezterm.action

return function(config)
  -- Disable default keys
  config.disable_default_key_bindings = true


  -- Show which key table is active in the status area
  wezterm.on('update-right-status', function(window, _)
    local name = window:active_key_table()
    window:set_right_status((name or 'normal'):upper() .. ' ')
  end)

  -- Set leader
  config.leader = { key = 'Space', mods = 'ALT' }

  -- Set key bindings
  config.keys = {
    -- Reset usefull defaults
    { key = 'q', mods = 'SUPER',       action = act.QuitApplication },
    { key = 'v', mods = 'SUPER',       action = act.PasteFrom 'Clipboard' },
    { key = 'c', mods = 'SUPER',       action = act.CopyTo 'Clipboard' },
    { key = '+', mods = 'SUPER',       action = act.IncreaseFontSize },
    { key = '-', mods = 'SUPER',       action = act.DecreaseFontSize },
    { key = '0', mods = 'SUPER',       action = act.ResetFontSize },
    { key = 'w', mods = 'SUPER',       action = act.CloseCurrentTab { confirm = true } },
    { key = '[', mods = 'SUPER',       action = act.ActivatePaneDirection 'Prev' },
    { key = ']', mods = 'SUPER',       action = act.ActivatePaneDirection 'Next' },
    { key = '[', mods = 'SUPER|SHIFT', action = act.ActivateTabRelative(-1) },
    { key = ']', mods = 'SUPER|SHIFT', action = act.ActivateTabRelative(1) },

    -- Remaps
    {
      key = 'Space',
      mods = 'LEADER',
      action = act.ActivateCommandPalette,
    },

    {
      key = 'k',
      mods = 'SUPER',
      action = act.ClearScrollback 'ScrollbackAndViewport',
    },

    -- Key table activation
    {
      key = 'p',
      mods = 'LEADER',
      action = act.ActivateKeyTable {
        name = 'pane',
        one_shot = false,
        until_unknown = true,
        -- timeout_milliseconds = 1000,
      },
    },

    {
      key = 's',
      mods = 'LEADER',
      action = act.ActivateKeyTable {
        name = 'scroll',
        one_shot = false,
        until_unknown = true,
      },
    },

    {
      key = 't',
      mods = 'LEADER',
      action = act.ActivateKeyTable {
        name = 'tab',
        one_shot = false,
        until_unknown = true,
      },
    },
  }

  config.key_tables = {

    pane = {

      -- Cancel the mode by pressing escape
      { key = 'Escape',     action = act.ClearKeyTableStack },

      -- Select
      { key = 'LeftArrow',  action = act.ActivatePaneDirection 'Left' },
      { key = 'h',          action = act.ActivatePaneDirection 'Left' },

      { key = 'RightArrow', action = act.ActivatePaneDirection 'Right' },
      { key = 'l',          action = act.ActivatePaneDirection 'Right' },

      { key = 'UpArrow',    action = act.ActivatePaneDirection 'Up' },
      { key = 'k',          action = act.ActivatePaneDirection 'Up' },

      { key = 'DownArrow',  action = act.ActivatePaneDirection 'Down' },
      { key = 'j',          action = act.ActivatePaneDirection 'Down' },

      -- Resize
      { key = 'LeftArrow',  mods = 'SHIFT',                            action = act.AdjustPaneSize { 'Left', 1 } },
      { key = 'h',          mods = 'SHIFT',                            action = act.AdjustPaneSize { 'Left', 1 } },

      { key = 'RightArrow', mods = 'SHIFT',                            action = act.AdjustPaneSize { 'Right', 1 } },
      { key = 'l',          mods = 'SHIFT',                            action = act.AdjustPaneSize { 'Right', 1 } },

      { key = 'UpArrow',    mods = 'SHIFT',                            action = act.AdjustPaneSize { 'Up', 1 } },
      { key = 'k',          mods = 'SHIFT',                            action = act.AdjustPaneSize { 'Up', 1 } },

      { key = 'DownArrow',  mods = 'SHIFT',                            action = act.AdjustPaneSize { 'Down', 1 } },
      { key = 'j',          mods = 'SHIFT',                            action = act.AdjustPaneSize { 'Down', 1 } },

      -- Split
      {
        key = 'v',
        action = act.Multiple {
          act.SplitHorizontal { domain = 'CurrentPaneDomain' },
          act.ClearKeyTableStack
        }
      },
      {
        key = 'd',
        action = act.Multiple {
          act.SplitVertical { domain = 'CurrentPaneDomain' },
          act.ClearKeyTableStack
        }
      },

    },

    scroll = {

      -- Cancel the mode by pressing escape
      { key = 'Escape', action = act.ClearKeyTableStack },

      -- Scroll line
      { key = 'k',      action = act.ScrollByLine(-1) },
      { key = 'j',      action = act.ScrollByLine(1) },

      -- Scroll page
      { key = 'k',      mods = 'SHIFT',                 action = act.ScrollByPage(-1) },
      { key = 'j',      mods = 'SHIFT',                 action = act.ScrollByPage(1) },

    },

    tab = {

      -- Cancel the mode by pressing escape
      { key = 'Escape', action = act.ClearKeyTableStack },

      -- New tab
      {
        key = 'n',
        action = act.Multiple {
          act.SpawnTab "CurrentPaneDomain",
          act.ClearKeyTableStack
        }
      },

      -- Close tab
      {
        key = 'q',
        action = act.Multiple {
          act.CloseCurrentTab { confirm = true },
          act.ClearKeyTableStack
        }
      },

      -- Select tab
      {
        key = 'h',
        action = act.ActivateTabRelative(-1),
      },

      {
        key = 'l',
        action = act.ActivateTabRelative(1),
      },

    }

  }
end
