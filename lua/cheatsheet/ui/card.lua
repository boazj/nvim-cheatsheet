---@class cs.card table
---@field name string
---@field title string
---@field lines string[]
---@field _column_width integer
---@field _blank_line string
local Card = {}

---card constructor
---@param column_width integer
---@param name string raw name of this card
---@param title string display name of this card with
---@param is_gap_line boolean should there be a gap line between the card title and body
---@return cs.card
function Card.new(column_width, name, title, is_gap_line)
  local new = {
    name = name,
    title = title,
    lines = {},
    _column_width = column_width,
    _blank_line = string.rep(' ', column_width),
  }
  if is_gap_line then
    table.insert(new.lines, new._blank_line)
  end

  setmetatable(new, { __index = Card })
  return new
end

function Card:append_blank_line()
  self:append_line(self._blank_line)
end

function Card:append_line(line)
  table.insert(self.lines, line)
end

---comparator for sort functions
---@param a cs.card
---@param b cs.card
---@return boolean
function Card.comparator(a, b)
  return a.name < b.name
end

return Card
