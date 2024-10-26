local M = {}

local function capitalize(str)
  if not str then
    return str
  end
  return (str:gsub('^%l', string.upper))
end

local s2s_map = {
  ['<lt>'] = '<',
  ['<Bslash>'] = '\\',
  ['<Bar>'] = '|',
  ['<Return>'] = '<CR>',
  ['<Enter>'] = '<CR>',
  ['<EOL>'] = '<CR>',
}

--- Normalize and splits a raw keybind string to a string[] of keys including special keys
---@param lhs string
---@return string[]
local function normalize(lhs)
  local ret = {} ---@type string[]
  local special = nil ---@type string?
  for c in lhs:gmatch '.' do
    if c == '<' and special == nil then
      special = c
    elseif special ~= nil then
      special = special .. c
      if c == '>' then
        table.insert(ret, s2s_map[special] or special)
        special = nil
      end
    else
      if string.match(c, '%u') then
        c = '<S-' .. c .. '>'
      end
      table.insert(ret, s2s_map[c] or c)
    end
  end
  return ret
end

--- Create display string from normalized keys
---@param opts cs.config
---@param keybind string[]
local function display(opts, keybind)
  local ret = vim.tbl_map(function(key)
    local inner = key:match '^<(.*)>$'
    if not inner then
      return key
    end
    if inner == 'NL' then
      inner = 'C-J'
    end
    local parts = vim.split(inner, '-', { plain = true })
    for i, part in ipairs(parts) do
      if i == 1 or i ~= #parts or not part:match '^%w$' then
        parts[i] = opts.icons.keys[parts[i]] or parts[i]
      end
    end
    return table.concat(parts, '')
  end, keybind)
  return table.concat(ret, '')
end

local function get_spec_heading(opts, keys)
  for key_prefix, heading in pairs(opts.spec) do
    if string.sub(keys, 1, #key_prefix) == key_prefix then
      return capitalize(heading)
    end
  end
  return nil
end

local function get_fallback_heading(desc)
  local heading = desc:match '%S+' -- get first word
  heading = capitalize(heading)

  if desc ~= nil and desc ~= '' and desc ~= heading then
    desc = desc:match '%s(.+)' -- remove first word from desc
  end
  desc = capitalize(desc)
  return heading, desc
end

---@param opts cs.config
---@param mapping table: { [string]: string[] }
---@param keymaps vim.api.keyset.keymap[]
M.get_mappings = function(opts, mapping, keymaps)
  local excluded_groups = opts.excluded_groups or {}

  for _, v in ipairs(keymaps) do
    if not v.desc or v.desc == '' then
      goto continue
    end
    local lhs = v.lhs
    -- replace all kind of whitespaces with space and trim around
    local desc = v.desc:gsub('%s+', ' '):gsub('^%s*(.-)%s*$', '%1')
    local keys = lhs:gsub(vim.g.mapleader, '<Leader>')

    local heading = get_spec_heading(opts, keys)
    if heading == nil then
      -- fallback heading use first word of desc as a group heading
      heading, desc = get_fallback_heading(desc)
    end

    if desc == nil then
      goto continue
    end

    -- useful for removing groups || <Plug> lhs keymaps from cheatsheet
    if
      vim.tbl_contains(excluded_groups, heading)
      or vim.tbl_contains(excluded_groups, desc:match '%S+')
      or string.find(lhs, '<Plug>')
      or string.find(lhs, '<SID>')
    then
      goto continue
    end

    if not mapping[heading] then
      mapping[heading] = {}
    end

    local keys_display = display(opts, normalize(keys))

    local update_key = 0
    for key, val in pairs(mapping[heading]) do
      if val[1] == desc and val[2] == keys_display then
        update_key = key
      end
    end
    if update_key ~= 0 then
      mapping[heading][update_key][3] = mapping[heading][update_key][3] .. ' ' .. v.mode
    else
      table.insert(mapping[heading], { desc, keys_display, v.mode })
    end

    ::continue::
  end
end

M.organize_mappings = function(opts, mapping)
  local modes = opts.keymaps.modes

  for _, mode in ipairs(modes) do
    local keymaps = vim.api.nvim_get_keymap(mode)
    M.get_mappings(opts, mapping, keymaps)

    local bufkeymaps = vim.api.nvim_buf_get_keymap(0, mode)
    M.get_mappings(opts, mapping, bufkeymaps)
  end
end

return M
