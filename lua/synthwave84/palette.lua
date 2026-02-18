local M = {}

function M.get()
  return {
    bg = "#262335",
    bg_dark = "#241b2f",
    bg_float = "#2a2139",
    bg_visual = "#ffffff20",
    bg_cursorline = "#34294f66",
    fg = "#ffffff",
    fg_dim = "#b6b1b1",
    fg_gutter = "#848bbd",

    pink = "#ff7edb",
    red = "#fe4450",
    orange = "#f97e72",
    yellow = "#fede5d",
    green = "#72f1b8",
    cyan = "#36f9f6",
    blue = "#03edf9",
    purple = "#b893ce",

    diff_add = "#0beb9935",
    diff_delete = "#fe445035",
    diff_change = "#49549539",

    warning = "#72f1b8",
    error = "#fe4450",
    info = "#03edf9",
    hint = "#ff7edb",
  }
end

return M
