---@alias cs.color string
---@class cs.colors
---@field section cs.color
---@field header cs.color
local M = {
  section = 'ChSection',
  header = 'ChHeader',
}

M._color_highlights = {
  'CheatsheetWhite',
  'CheatsheetGray',
  'CheatsheetBlue',
  'CheatsheetCyan',
  'CheatsheetRed',
  'CheatsheetGreen',
  'CheatsheetYellow',
  'CheatsheetOrange',
  'CheatsheetPurple',
  'CheatsheetMagenta',
} ---@type string[]

---
---@return string color
M.get_random_color = function()
  return M._color_highlights[math.random(1, #M._color_highlights)]
end

return M
