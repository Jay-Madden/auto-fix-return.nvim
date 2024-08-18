# auto-fix-return.nvim

## Installation

#### Lazy
```lua
return {
  "Jay-Madden/auto-fix-return.nvim",
  config = function()
    require("auto-fix-return").setup({})
  end
}
```

## Configuration

#### Defaults
```lua
require("auto-fix-return").setup({
  enable_autocmds = true, -- Enable or disable the autofix on type behvaior
})
```

### Commands

`AutoFixReturn`: Format the function definition under the cursor, adding or removing parenthesis as needed
`AutoFixReturnEnable`: Enable the autofix on type autocommands
`AutoFixReturnDisable`: Disable the autofix on type autocommands
