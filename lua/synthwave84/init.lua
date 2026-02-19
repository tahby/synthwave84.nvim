local palette = require("synthwave84.palette")
local highlights = require("synthwave84.highlights")

local M = {}

local COLOR_KEYS = {
  fg = true,
  bg = true,
  sp = true,
  ctermfg = true,
  ctermbg = true,
}

local function normalize_color(value)
  if type(value) ~= "string" then
    return value
  end

  if value == "NONE" or value == "none" then
    return "NONE"
  end

  if value:sub(1, 1) ~= "#" then
    return value
  end

  local hex = value:match("^#([0-9A-Fa-f]+)$")
  if not hex then
    return "NONE"
  end

  if #hex == 3 then
    hex = hex:gsub(".", function(ch)
      return ch .. ch
    end)
    return "#" .. hex
  end

  if #hex == 8 then
    return "#" .. hex:sub(1, 6)
  end

  if #hex == 6 then
    return "#" .. hex
  end

  return "NONE"
end

local function sanitize_spec(spec)
  local normalized = {}

  for key, value in pairs(spec) do
    if COLOR_KEYS[key] then
      normalized[key] = normalize_color(value)
    else
      normalized[key] = value
    end
  end

  return normalized
end

M.config = {
  transparent = false,
  styles = {
    comments = true,
    keywords = false,
    parameters = true,
  },
  overrides = function(_colors, _highlights)
    return {}
  end,
}

local function apply_terminal_colors(c)
  vim.g.terminal_color_0 = "#241b2f"
  vim.g.terminal_color_1 = c.red
  vim.g.terminal_color_2 = c.green
  vim.g.terminal_color_3 = c.yellow
  vim.g.terminal_color_4 = c.blue
  vim.g.terminal_color_5 = c.pink
  vim.g.terminal_color_6 = c.cyan
  vim.g.terminal_color_7 = c.fg
  vim.g.terminal_color_8 = c.bg_float
  vim.g.terminal_color_9 = c.red
  vim.g.terminal_color_10 = c.green
  vim.g.terminal_color_11 = c.yellow
  vim.g.terminal_color_12 = c.blue
  vim.g.terminal_color_13 = c.pink
  vim.g.terminal_color_14 = c.cyan
  vim.g.terminal_color_15 = c.fg
end

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

function M.load()
  if vim.g.colors_name then
    vim.cmd("hi clear")
  end

  vim.o.termguicolors = true
  vim.g.colors_name = "synthwave84"

  local c = palette.get()
  local groups = highlights.get(c, M.config)

  local extra = M.config.overrides(c, groups) or {}
  groups = vim.tbl_extend("force", groups, extra)

  for group, spec in pairs(groups) do
    vim.api.nvim_set_hl(0, group, sanitize_spec(spec))
  end

  apply_terminal_colors(c)
end

return M
