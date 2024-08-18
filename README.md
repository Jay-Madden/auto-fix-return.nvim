# 🧰 auto-fix-return.nvim
Adds or removes parenthesis from Golang return defintions as you type. 

Supports 
- Single returns 
- Multi returns 
- Named returns 
- Functions
- Methods
- Lambdas
and hopefully all combinations of the above. If you find a bug please report it as an issue. 

## Preview
![high_res_final](https://github.com/user-attachments/assets/a5b9b50d-cbc7-42a6-b3f7-e20795c93823)

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

## ⚙️ Configuration

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
