local M = {}

local cards_fac = require 'cheatsheet.ui.card'
local layout_fac = require 'cheatsheet.ui.layout'
local colors = require 'cheatsheet.ui.colors' ---@type cs.colors
---
---@param buf integer
---@param win integer
---@param opts cs.config
---@return integer
local function render_header(buf, win, opts)
  -- Add left padding (strs) to ascii so it looks centered
  local ascii_header = vim.tbl_values(opts.header.custom_header)
  local ascii_padding_len = (vim.api.nvim_win_get_width(win) / 2) - (#ascii_header[1] / 2)
  local ascii_padding = string.rep(' ', ascii_padding_len)
  for i, str in ipairs(ascii_header) do
    ascii_header[i] = ascii_padding .. str .. ascii_padding
  end
  -- Draw header
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, ascii_header)
  return #ascii_header
end

local function calc_column_metrics(win, mappings_tb)
  -- column width
  local column_width = 0
  for _, section in pairs(mappings_tb) do
    for _, mapping in pairs(section) do
      local txt = vim.fn.strdisplaywidth('()  ' .. mapping[3] .. mapping[1] .. mapping[2])
      column_width = column_width > txt and column_width or txt
    end
  end

  -- 10 = space between mapping txt , 4 = 2 & 2 space around mapping txt

  local win_width = vim.api.nvim_win_get_width(win) - vim.fn.getwininfo(win)[1].textoff - 4
  local columns_qty = math.floor(win_width / column_width)

  column_width = math.floor((win_width - (column_width * columns_qty)) / columns_qty) + column_width
  return column_width, columns_qty
end

local function get_section_mode_len(section)
  local mode_width = 0
  for _, mapping in pairs(section) do
    local txt = vim.fn.strdisplaywidth('(' .. mapping[3] .. ')')
    mode_width = mode_width > txt and mode_width or txt
  end
  return mode_width
end

local function format_section_title(name, column_width)
  local padding_left = math.floor((column_width - vim.fn.strdisplaywidth(name)) / 2)
  local title = string.rep(' ', padding_left) .. name .. string.rep(' ', column_width - vim.fn.strdisplaywidth(name) - padding_left)
  return title
end

function M.draw(buf, opts, mappings_tb)
  -- Create namespace for the highlight groups
  local ns = vim.api.nvim_create_namespace 'cheatsheet'
  local win = vim.api.nvim_get_current_win()

  -- PREPARE
  local column_width, columns_count = calc_column_metrics(win, mappings_tb)
  local blank_line = string.rep(' ', column_width)

  ---@type cs.layout
  local layout = layout_fac.new(columns_count)

  for name, section in pairs(mappings_tb) do
    local title = format_section_title(name, column_width)

    ---@type cs.card
    local card = cards_fac.new(column_width, name, title, true)

    local mode_width = get_section_mode_len(section) + 1 -- to ensure we have at least one space

    for _, mapping in ipairs(section) do
      local mode_dis = '(' .. mapping[3] .. ')'
      local desc_dis = mapping[1]
      local keys_dis = mapping[2]

      local padding = column_width - mode_width - 4 - vim.fn.strdisplaywidth(keys_dis)
      local format = '  %-' .. mode_width .. 's%-' .. padding .. 's%s  '
      card:append_line(string.format(format, mode_dis, desc_dis, keys_dis))
    end
    card:append_blank_line()
    card:append_blank_line()
    layout:append_card(card)
  end

  -- LAYOUT
  layout:prepare_masonry_layout(columns_count)

  -- RENDER
  local top_line = render_header(buf, win, opts)
  local full_lines = layout:get_lines_for_render(blank_line)
  vim.api.nvim_buf_set_lines(buf, top_line, -1, false, full_lines)

  -- HIGHLIGHT
  vim.api.nvim_buf_set_extmark(buf, ns, 0, 0, { end_row = top_line, hl_group = colors.header })
  local line_ends = {}

  ---helper to calculate render cols
  ---@param left integer
  ---@param text string
  ---@return integer
  local real_length = function(left, text, pad)
    pad = pad or 0
    return left + vim.fn.strlen(text) + pad
  end

  local get_or = function(val, default)
    return val == nil and default or val
  end

  local hl_section = function(line, col_start, text)
    vim.api.nvim_buf_add_highlight(buf, ns, colors.section, line, col_start, real_length(col_start, text))
  end

  local hl_title = function(line, col_start, text)
    vim.api.nvim_buf_add_highlight(buf, ns, colors.get_random_color(), line, col_start - 1, real_length(col_start, text, 1))
  end

  for _, ccol in ipairs(layout.columns) do
    local line = top_line

    for _, card in ipairs(ccol) do
      local col_left = get_or(line_ends[line], 0)

      hl_section(line, col_left, card.title)
      hl_title(line, col_left + vim.fn.stridx(card.title, card.name), card.name)
      line_ends[line] = real_length(col_left, card.title, 2)
      line = line + 1

      local eoc = false
      for j = 1, #card.lines - 1, 1 do
        col_left = get_or(line_ends[line], 0)
        if card.lines[j] ~= blank_line or (card.lines[j] == blank_line and not eoc) then
          hl_section(line, col_left, card.lines[j])
          eoc = card.lines[j] == blank_line
        end
        line_ends[line] = real_length(col_left, card.lines[j], 2)
        line = line + 1
      end
      line_ends[line] = real_length(get_or(line_ends[line], 0), blank_line, 2)
      line = line + 1
    end
  end
end

return M

-- vim: ts=2 sts=2 sw=2 et
