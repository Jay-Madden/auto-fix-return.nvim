# 🧰 auto-fix-return.nvim

[![Test](https://github.com/Jay-Madden/auto-fix-return.nvim/actions/workflows/run-tests.yml/badge.svg)](https://github.com/Jay-Madden/auto-fix-return.nvim/actions/workflows/run-tests.yml)

Plugin inspired by GoLand that adds or removes parentheses from Golang return definitions as you type.

Supports
- Functions
- Methods
- Interfaces
- Single returns
- Multi returns
- Named returns
- Channel returns

Coming soon:
- Closures

and hopefully all combinations of the above. If you find a bug please report it as an issue.

## Preview
![high_res_final](https://github.com/user-attachments/assets/a5b9b50d-cbc7-42a6-b3f7-e20795c93823)

> [!IMPORTANT]
> The plugin attempts to add parentheses as you type. This means that it's mostly working off invalid parse trees.
> This is very nice to use but makes it very difficult to cover all edge cases from a parsing standpoint, as different error states of the tree can be matched incorrectly.
> If you find an error state that is not covered please report it as an issue.
>
> You can run the command `AutoFixReturn disable` to turn off the autocommand and make whatever changes you need to that line.
> Then re-enable the plugin with `AutoFixReturn enable` and the line will not be edited unless you touch the declarations return definition again.

> [!TIP]
> You can always invoke the fix manually with `AutoFixReturn` as long as your cursor is in the return definition.

> [!NOTE]
> To ensure that we are not overly aggressive in the fixes that we apply and break unrelated code, whenever a fix is found, the contents of the current buffer and the fix are first copied to a scratch buffer and a full TreeSitter parse is run there before the fix is applied to the live buffer. If the buffer with the proposed fix from the builder contains **ANY** parse errors in it the fix will be ignored. 
>
> This is because in rare cases treesitter error tokens can apply across an arbitrary number of rows and we would end up deleting large swathes of code which is not what we want. 
>
> In practice this means that an invalid syntax error elsewhere in the buffer will essentially disable this plugin for that buffer. 

## Compatibility

Due to attempting to use in progress or invalid parse trees this plugin is very sensitive to changes in the compiled version of the underlying Go treesitter parser.


> [!IMPORTANT]
> The current tested version of the Go parser that this plugin was written against is [5e73f476efafe5c768eda19bbe877f188ded6144](https://github.com/tree-sitter/tree-sitter-go/commit/5e73f476efafe5c768eda19bbe877f188ded6144)

> [!NOTE]
> If you are using `nvim-treesitter` you can view your installed Go parser version with the following command
> ```
> lua vim.print(io.open(require("nvim-treesitter.configs").get_parser_info_dir() .. "/go.revision"):read("*a"))
> ```

Using an untested parser version may or may not work in all scenarios. The plugin will not write the fix back to the buffer in the case the fix will generate an invalid parse tree. So an untested parser version will refuse to make fixes in some circumstances.

## Installation

> [!IMPORTANT]
> Requires the Go treesitter parser to be installed.
> You can run `TSInstall go` if using nvim-treesitter.

#### Lazy
```lua
return {
  "Jay-Madden/auto-fix-return.nvim",
  event = "VeryLazy",

  -- nvim-treesitter is optional, the plugin will work fine without it as long as
  -- you have a valid Go parser in $rtp/parsers.
  -- However due to the Go grammar not being on Treesitter ABI 15 without 'nvim-treesitter'
  -- we are unable to detect and warn if an invalid parser version is being used.
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },

  config = function()
    require("auto-fix-return").setup({})
  end
}
```

## ⚙️ Configuration

#### Defaults
```lua
require("auto-fix-return").setup({
  -- Enable or disable the autofix on type behavior
  enabled = true,
  
  -- Default logging level for the plugin, if the plugin does not behave as it should
  -- set this to vim.log.levels.DEBUG
  log_level = vim.log.levels.INFO
})
```

### Commands

`AutoFixReturn`: Format the function definition under the cursor, adding or removing parenthesis as needed

`AutoFixReturn enable`: Enable the autofix on type behavior

`AutoFixReturn disable`: Disable the autofix on type behavior

## Contributing

Due to the nature of the plugins attempt to work with invalid parse trees a robust integration suite provides regression testing to ensure changes do not cascade issues.

The integration tests require `just` and `tree-sitter-cli` installed.

- [just](https://just.systems/man/en/pre-built-binaries.html)
- [tree-sitter-cli](https://tree-sitter.github.io/tree-sitter/creating-parsers/1-getting-started.html)

The command

```
just test
```

Will clone and build the currently supported version of the Go treesitter parser and use that for the tests.

## Git Hooks

To enable the pre-commit hook that runs `just fmt`:

```bash
git config core.hooksPath hooks
```
