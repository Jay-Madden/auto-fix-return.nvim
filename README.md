# 🧰 auto-fix-return.nvim
Adds or removes parenthesis from Golang return defintions as you type. 

Supports 
- Single returns 
- Multi returns 
- Named returns 
- Functions
- Methods
- Lambdas
- Interfaces

and hopefully all combinations of the above. If you find a bug please report it as an issue. 

> [!NOTE]
> The plugin attempts to add parenthesis as you type. Which means that its mostly working off of invalid parse trees.
> This is very nice to use but makes it difficult to cover all edgecases from a parsing standpoint, as different error states of the tree can be matched incorectly. 
> If you find an error state that is not covered please report it as an issue. 
> 
> You can run the command `AutoFixReturnDisable` to turn off the autocommnd and make whatever changes you need to that line. 
> Then reenable the plugin with `AutoFixReturnEnable` and the line will not be edited again unless you touch the declaration again.

## Preview
![high_res_final](https://github.com/user-attachments/assets/a5b9b50d-cbc7-42a6-b3f7-e20795c93823)

## Installation

> [!IMPORTANT]  
> Requires the Go treesitter parser to be installed `TSInstall go` if using nvim-treesitter.

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
