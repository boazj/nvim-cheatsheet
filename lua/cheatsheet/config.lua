local M = {}

local default_header = {
  '                                      ',
  '                                      ',
  '                                      ',
  '█▀▀ █░█ █▀▀ ▄▀█ ▀█▀ █▀ █░█ █▀▀ █▀▀ ▀█▀',
  '█▄▄ █▀█ ██▄ █▀█ ░█░ ▄█ █▀█ ██▄ ██▄ ░█░',
  '                                      ',
  '                                      ',
  '                                      ',
}

local default_nerd_keys = {
  Leader = ' ',
  Up = ' ',
  Down = ' ',
  Left = ' ',
  Right = ' ',
  C = '󰘴 ',
  M = '󰘵 ',
  D = '󰘳 ',
  S = '󰘶 ',
  CR = '󰌑 ',
  Esc = '󱊷 ',
  ScrollWheelDown = '󱕐 ',
  ScrollWheelUp = '󱕑 ',
  NL = '󰌑 ',
  BS = '󰁮',
  Space = '󱁐 ',
  Tab = '󰌒 ',
  F1 = '󱊫 ',
  F2 = '󱊬 ',
  F3 = '󱊭 ',
  F4 = '󱊮 ',
  F5 = '󱊯 ',
  F6 = '󱊰 ',
  F7 = '󱊱 ',
  F8 = '󱊲 ',
  F9 = '󱊳 ',
  F10 = '󱊴 ',
  F11 = '󱊵 ',
  F12 = '󱊶 ',
}

local default_basic_keys = {
  Up = '<Up>',
  Down = '<Down>',
  Left = '<Left>',
  Right = '<Right>',
  C = '<C-…>',
  M = '<M-…>',
  D = '<D-…>',
  S = '<S-…>',
  CR = '<CR>',
  Esc = '<Esc>',
  ScrollWheelDown = '<ScrollWheelDown>',
  ScrollWheelUp = '<ScrollWheelUp>',
  NL = '<NL>',
  BS = '<BS>',
  Space = '<Space>',
  Tab = '<Tab>',
  F1 = '<F1>',
  F2 = '<F2>',
  F3 = '<F3>',
  F4 = '<F4>',
  F5 = '<F5>',
  F6 = '<F6>',
  F7 = '<F7>',
  F8 = '<F8>',
  F9 = '<F9>',
  F10 = '<F10>',
  F11 = '<F11>',
  F12 = '<F12>',
}

local default_modes = { 'n', 'i', 'x' }

---@type cs.config?
M.config = nil

---@type cs.config
M.default_config = {
  header = {
    show = true,
    custom_header = default_header,
  },
  keymaps = {
    modes = default_modes,
  },
  spec = {},
  excluded_groups = {},
  icons = {
    enabled = true,
    keys = default_nerd_keys,
  },
}

-- TODO: validate config

---@param base cs.config
---@param input cs.config
---@return cs.config
local function merge_configs(base, input)
  return vim.tbl_deep_extend('keep', input or {}, base) --[[@as cs.config]]
end

---@param config cs.config
---@return cs.config
M.set_config = function(config)
  M.config = merge_configs(M.default_config, config)

  return M.config
end

---@return cs.config
M.get_config = function()
  return M.config
end

return M

-- vim: ts=2 sts=2 sw=2 et
