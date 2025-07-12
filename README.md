>**NOTE**
>
>If you want to use the current Neovim instance when editing diffs, please install this: [Gemini fork](https://github.com/JunYang-tes/gemini-cli.nvim) ([npm](https://www.npmjs.com/package/gemini-cli-neovim)) instead of official [Google Gemini CLI](https://github.com/google/gemini-cli)
>```bash
>bun i -g gemini-cli-neovim
>```
>If you are using npm
>```bash
>npm i -g gemini-cli-neovim
># Installing globally with npm may require root privileges.
>sudo npm i -g gemini-cli-neovim
>```


# gemini.nvim

An unofficial Neovim plugin to interact with the Google Gemini CLI within a persistent terminal window.

[![asciicast](https://asciinema.org/a/qCrA52b4s5lfnjQJRPc3Cnton.svg)](https://asciinema.org/a/qCrA52b4s5lfnjQJRPc3Cnton)



## Features

- Run the `gemini` CLI in a terminal session that persists in the background.
- Toggle the terminal window's visibility with a single command or keymap.
- Choose between a floating window or a vertical side panel.
- Highly configurable window geometry and keymaps.
- Integrates with Neovim's native `:checkhealth` system.

## Requirements

- Neovim >= 0.8
- [Google Gemini CLI](https://github.com/google/gemini-cli) or  [Gemini fork](https://github.com/JunYang-tes/gemini-cli.nvim) ([npm](https://www.npmjs.com/package/gemini-cli-neovim)) installed and available in your `$PATH`.
- Node.js >= 20



## Installation

Here is an example using `lazy.nvim`. As this plugin is currently part of a monorepo, you would need to point the `dir` to the local path of the package.

```lua
-- lazy.nvim spec
{
  'JunYang-tes/gemini-nvim',

  config = function()
    require('gemini-nvim').setup({
      -- Your configuration goes here
    })
  end,
}
```

## Configuration

Call the `setup` function to configure the plugin. Here are all the available options with their default values:

```lua
-- init.lua

require('gemini-nvim').setup({
  -- The style of the window to open.
  -- Can be 'float' or 'side'.
  window_style = 'float',

  -- For `window_style = 'side'`.
  -- Can be 'left' or 'right'.
  side_position = 'right',

  -- For `window_style = 'float'`.
  -- Values are a percentage of the editor's dimensions.
  float_width_ratio = 0.8,
  float_height_ratio = 0.8,

  -- Whether to create the default keymap for toggling the window.
  set_default_keymap = true,

  -- The keymap to use for toggling the window.
  toggle_keymap = '<F3>',
})
```

## Usage

- `:Gemini`: Toggles the Gemini terminal window (opens, hides, or shows it).
- Press `<F3>` (or your configured keymap) to do the same.
- `:checkhealth gemini`: Checks for dependencies (`gemini` executable, Node.js version, etc.).

### Additional explanation for those unfamiliar with Terminal Mode:

- In Normal Mode, press I to enter Terminal Mode, where you can interact with Gemini.

- In Terminal Mode, press Ctrl+N or Ctrl+\ to return to Normal Mode, where you can press <F3> to close the Gemini window.
