# synthwave84.nvim

High-fidelity Neovim port of **SynthWave '84** focused on the original palette, but intentionally **without glow effects**.

## Features

- SynthWave '84 color palette (VS Code inspired)
- No glow/shadow hacks (clean, crisp text)
- Treesitter + LSP semantic highlights
- Telescope, NvimTree, GitSigns defaults
- Transparent background option
- Override hook for custom highlight groups

## Install (lazy.nvim)

```lua
{
  "tahby/synthwave84.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    transparent = false,
    styles = {
      comments = true,
      keywords = false,
      parameters = true,
    },
    overrides = function(colors, highlights)
      return {
        -- Example:
        -- CursorLineNr = { fg = colors.orange, bold = true },
      }
    end,
  },
  config = function(_, opts)
    require("synthwave84").setup(opts)
    vim.cmd.colorscheme("synthwave84")
  end,
}
```

## Minimal setup

```lua
require("synthwave84").setup()
vim.cmd.colorscheme("synthwave84")
```

## Notes

- This theme intentionally omits the neon glow effect from the VS Code extension.
- Best experience with `termguicolors` enabled (auto-enabled by the theme).

## License

MIT
