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

local function parse_hex(value)
  local hex = value:match("^#([0-9A-Fa-f]+)$")
  if not hex then
    return nil
  end

  if #hex == 3 then
    hex = hex:gsub(".", function(ch)
      return ch .. ch
    end)
  end

  if #hex == 6 then
    local r = tonumber(hex:sub(1, 2), 16)
    local g = tonumber(hex:sub(3, 4), 16)
    local b = tonumber(hex:sub(5, 6), 16)
    return r, g, b
  end

  if #hex == 8 then
    local r = tonumber(hex:sub(1, 2), 16)
    local g = tonumber(hex:sub(3, 4), 16)
    local b = tonumber(hex:sub(5, 6), 16)
    local a = tonumber(hex:sub(7, 8), 16)
    return r, g, b, a
  end

  return nil
end

local function fmt_hex(r, g, b)
  return string.format("#%02x%02x%02x", r, g, b)
end

local function blend_channel(fg, bg, alpha)
  return math.floor(((fg * alpha) + (bg * (255 - alpha))) / 255 + 0.5)
end

local function normalize_color(value, blend_base)
  if type(value) ~= "string" then
    return value
  end

  if value == "NONE" or value == "none" then
    return "NONE"
  end

  if value:sub(1, 1) ~= "#" then
    return value
  end

  local r, g, b, a = parse_hex(value)
  if not r then
    return "NONE"
  end

  if not a then
    return fmt_hex(r, g, b)
  end

  local br, bg, bb = parse_hex(blend_base or "#000000")
  if not br then
    br, bg, bb = 0, 0, 0
  end

  local out_r = blend_channel(r, br, a)
  local out_g = blend_channel(g, bg, a)
  local out_b = blend_channel(b, bb, a)

  return fmt_hex(out_r, out_g, out_b)
end

local function sanitize_spec(spec, default_bg)
  local normalized = {}
  local resolved_bg = default_bg

  if type(spec.bg) == "string" then
    local bg = normalize_color(spec.bg, default_bg)
    if bg ~= "NONE" then
      resolved_bg = bg
    end
  end

  for key, value in pairs(spec) do
    if COLOR_KEYS[key] then
      if key == "bg" or key == "ctermbg" then
        normalized[key] = normalize_color(value, default_bg)
        if key == "bg" and normalized[key] ~= "NONE" then
          resolved_bg = normalized[key]
        end
      else
        normalized[key] = normalize_color(value, resolved_bg)
      end
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
    vim.api.nvim_set_hl(0, group, sanitize_spec(spec, c.bg))
  end

  apply_terminal_colors(c)
end

return M
