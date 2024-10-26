local M = {}

local filetype = 'cheatsheet'

local function init_state()
  vim.g.cheatsheet = {
    displayed = false,
    cs_buffer = -1,
    previous_buffer = -1,
  }
end

local function get_state()
  return vim.g.cheatsheet
end

local function persist_state(state)
  vim.g.cheatsheet = state
end

local function set_displayed(is_displayed)
  local s = get_state()
  s.displayed = is_displayed
  persist_state(s)
end

local function set_previous_buffer(buf)
  local s = get_state()
  s.previous_buffer = buf
  persist_state(s)
end

local function set_cs_buffer(buf)
  local s = get_state()
  s.cs_buffer = buf
  persist_state(s)
end

local function kill_cs_buf(cs_buf)
  vim.api.nvim_buf_delete(cs_buf, { force = true })
  local s = get_state()
  s.cs_buffer = -1
  persist_state(s)
  set_displayed(false)
end

local function switch_to_previous_buf()
  local buf = get_state().previous_buffer
  set_previous_buffer(-1)
  if not vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_set_current_buf(buf)
    return buf
  end

  local has_previous = pcall(vim.cmd, 'bprevious')
  if has_previous and buf ~= vim.api.nvim_get_current_buf() then
    return vim.api.nvim_get_current_buf()
  end
end

function M.show()
  if get_state().displayed then
    return
  end

  local renderer = require 'cheatsheet.ui.render'
  local mapper = require 'cheatsheet.mappings'

  -- Save previous buffer ID
  set_previous_buffer(vim.api.nvim_get_current_buf())

  -- Create an empty buffer
  local buffer = vim.api.nvim_create_buf(false, true) -- buffer from scratch that won't be listed and thus not in tabs
  set_cs_buffer(buffer)

  -- Mark as displayed
  set_displayed(true)

  -- Switch to the new buffer
  vim.api.nvim_set_current_buf(buffer)
  local mapping = {}
  mapper.organize_mappings(M.opts, mapping)

  -- Draw the cheatsheet
  renderer.draw(buffer, M.opts, mapping)

  -- Configure the cheatsheet buffer
  vim.opt_local.bufhidden = 'delete'
  vim.opt_local.buflisted = false
  vim.opt_local.modifiable = false
  vim.opt_local.buftype = 'nofile'
  vim.opt_local.number = false
  vim.opt_local.list = false
  vim.opt_local.wrap = false
  vim.opt_local.relativenumber = false
  vim.opt_local.cursorline = false
  vim.opt_local.colorcolumn = '0'
  vim.opt_local.foldcolumn = '0'
  vim.opt_local.filetype = filetype

  -- Create a shortcut to hide and remove the cheatsheet buffer
  vim.keymap.set('n', '<Esc>', function()
    switch_to_previous_buf()
    -- no need to kill the buffer here, it will be killed automatically
  end, { buffer = buffer })

  vim.api.nvim_create_autocmd('BufWinLeave', {
    group = vim.api.nvim_create_augroup('cheatsheet', { clear = true }),
    callback = function()
      if vim.bo.ft == filetype then
        set_displayed(false)
      end
    end,
    buffer = buffer,
  })
end

function M.close()
  local s = get_state()
  if not s.displayed then
    return
  end

  if vim.api.nvim_get_current_buf() ~= s.cs_buffer then
    set_displayed(false)
    return
  end

  local cs_buf = vim.api.nvim_get_current_buf()
  switch_to_previous_buf()
  kill_cs_buf(cs_buf)
end

function M.toggle()
  if get_state().displayed then
    M.close()
  else
    M.show()
  end
end

function M.setup(opts)
  local conf = require 'cheatsheet.config'

  conf.set_config(opts)

  -- Merge user options with defaults
  M.opts = conf.get_config()

  init_state()

  vim.api.nvim_create_user_command('CheatsheetToggle', function(_)
    M.toggle()
  end, { bang = false, desc = 'Toggle Cheatsheet', nargs = 0, bar = false })

  vim.api.nvim_create_user_command('CheatsheetShow', function(_)
    M.show()
  end, { bang = false, desc = 'Show Cheatsheet', nargs = 0, bar = false })

  vim.api.nvim_create_user_command('CheatsheetClose', function(_)
    M.close()
  end, { bang = false, desc = 'Show Cheatsheet', nargs = 0, bar = false })
end

return M

-- vim: ts=2 sts=2 sw=2 et
