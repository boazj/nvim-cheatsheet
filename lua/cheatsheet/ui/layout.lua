---@class cs.layout table
---@field columns_count integer
---@field cards cs.card[]
---@field columns { [integer]: cs.card[] }
---@field _line_columns { [integer]: string[] }
---@field _render_lines string[]
---@field _layout_ready boolean
local Layout = {}

local cards_fac = require 'cheatsheet.ui.card'

local function init_tables_array(size)
  local ret = {}
  for i = 1, size, 1 do
    ret[i] = {}
  end
  return ret
end

local function append_table(tb1, tb2)
  for _, val in ipairs(tb2) do
    tb1[#tb1 + 1] = val
  end
end

function Layout.new()
  local new = {
    columns_count = -1,
    cards = {},
    columns = nil,
    _line_columns = nil,
    _render_lines = {},
    _layout_ready = false,
  }

  setmetatable(new, { __index = Layout })
  return new
end

---
---@param card cs.card
function Layout:append_card(card)
  table.insert(self.cards, card)
end

function Layout:prepare_masonry_layout(columns_count)
  if self._layout_ready then
    return
  end
  -- if columns_count < 1 then
  --   -- TODO: error
  -- end
  table.sort(self.cards, cards_fac.comparator)
  self.columns_count = columns_count

  self.columns = init_tables_array(columns_count) -- holds the cards in layout
  self.line_columns = init_tables_array(columns_count) -- holds the render text in layout

  for _, card in pairs(self.cards) do
    for i, column in ipairs(self.line_columns) do
      local prev_col = i - 1 == 0 and columns_count or (i - 1)
      if #column <= #self.line_columns[prev_col] then
        table.insert(self.columns[i], card)
        column[#column + 1] = card.title
        append_table(column, card.lines)
        break
      end
    end
  end

  self._layout_ready = true
end

---commena
---@return string[]
function Layout:get_lines_for_render(blank_line)
  -- if not self._layout_ready then
  --   -- TODO: error
  -- end

  local max_col_height = 0
  for _, column in ipairs(self.line_columns) do
    max_col_height = max_col_height < #column and #column or max_col_height
  end

  -- fill empty lines with whitespaces so all columns will have the same height
  for i, _ in ipairs(self.line_columns) do
    for _ = 1, max_col_height - #self.line_columns[i], 1 do
      table.insert(self.line_columns[i], blank_line)
      self.columns[i][#self.columns[i]]:append_blank_line()
      --table.insert(self.columns[i][table.maxn(self.columns[i])].lines, blank_line)
    end
  end

  for i = 1, max_col_height, 1 do
    local line = self.line_columns[1][i]
    for j = 2, self.columns_count, 1 do
      line = line .. '  ' .. self.line_columns[j][i]
    end
    table.insert(self._render_lines, line)
  end

  return self._render_lines
end

return Layout
