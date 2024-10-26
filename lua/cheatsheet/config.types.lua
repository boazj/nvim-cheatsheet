---@meta

---@class cs.config.header
---@field show boolean?
---@field custom_header string[]?

-- ''|'n'|'v'|'s'|'x'|'o'|'!'|'i'|'l'|'c'|'t'
---@class cs.config.modes: string[]

---@class cs.config.excluded_groups: string[]

---@class cs.config.spec: { [string]: string }

---@class cs.config.keymaps: { [string]: { [integer]: string } }
---@field modes cs.config.modes?

---@class cs.config.keys: { [string]: string }

---@class cs.config.icons
---@field keys cs.config.keys?
---@field enabled boolean?

---@class cs.config
---@field header cs.config.header?
---@field keymaps cs.config.keymaps?
---@field spec cs.config.spec?
---@field excluded_groups cs.config.excluded_groups?
---@field icons cs.config.icons?
