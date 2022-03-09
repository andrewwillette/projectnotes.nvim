# projectnotes.nvim

A neovim plugin which allows the user to manage notes on a per-project basis in a unified manner.

## Customization
### Example configuration (lua)
```lua
require("projectnotes").setup({
    notes_root = vim.fn.resolve(os.getenv("HOME") .. "/git/manual/solution_specific/"),
    shortcut = "<leader>ep",
    init_filetype = ".norg",
    init_dirs = { "todo", "done" },
})
```
### Required:
`notes_root` - The absolute path to the directory where project notes should be stored.

`shortcut` - The shortcut for triggerring projectnotes telescope selection.

### Optional:
`init_file` - File to be created inside the project notes directory when initializing the directory.

`init_filetype` - Initializes <project_name>.<init_filetype> when initializing the directory. Ignored if `init_file` is supplied.

`init_dirs` - Base-level directories to be added when initializing the notes directory. Does not support nested directories. For example `extraNotes` is valid, but `extra/Notes` is not.

## Installation
Requires [telescope](https://github.com/nvim-telescope/telescope.nvim) and [luafilesystem](https://luarocks.org/modules/hisham/luafilesystem).

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):
```lua
...
    use 'andrewwillette/projectnotes.nvim'
    use_rocks "luafilesystem"
    use {
       "nvim-telescope/telescope.nvim",
       requires = {
           "nvim-lua/plenary.nvim",
       }
    }
...
```
