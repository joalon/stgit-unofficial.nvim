# StGit.nvim
A plugin to work with Stacked Git (stgit) inside Neovim.

`Warning! This is highly untested. If you value your repository don't run this plugin!`

## Install
I've only used Plug myself:

```
call plug#begin(expand('~/.config/nvim/plugged'))
Plug 'joalon/stgit-unofficial.nvim'
call plug#end()
```

And run `:PlugInstall`.

The main command as of yet can be called with `:call StgSeries()`
which will bring up a split with the current patch series. In the split the
top can be pushed or popped with <leader>sj or <leader>sk respectively.
Pressing `dd` will mark the patch under the cursor for deletion. Writing the
buffer (`:w`) will execute the changes. If the index is dirty it will
temporarily be stored on the git stash.

There is also an `Stg` command which can be used directly: `:Stg refresh -i`

## Features
Right now you can... Check, push, pop and delete your patches! Seriously,
that's it right now.

## Testing
The unit tests are run using the [Busted](https://olivinelabs.com/busted/)
framework. Run them with `busted .` or `busted spec/`. There is a minimal
`test-init.vim` for demonstrating the keybindings. To only run with this
plugin and the vimrc use: `nvim -u test-init.vim --cmd "set rtp+=$(pwd)" .`
