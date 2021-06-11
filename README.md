# StGit.nvim
A plugin to work with Stacked Git (stgit) inside Neovim.

`Warning! This is highly untested. If you value your repository don't run this plugin!`

## Install
I've only used Plug myself:

```
Plug 'joalon/stgit-unofficial.nvim'
```

The main command as of yet can be called with `require('stgit').series()` which will
bring up a split with the current patch series. In the split the top can be pushed
or popped with Ctrl-j or Ctrl-k repspectively. Pressing `dd` will mark the patch
under the cursor for deletion. Writing the buffer (`:w`) will execute the changes.
If the index is dirty it will temporarily be stored on the git stash.

## Features
Right now you can... Check, push, pop and delete your patches! Seriously, that's it right now.

## Example
I've got the following keybinds in my init.vim:

```
let mapleader="\<Space>"

" stgit config
nnoremap <leader>ss :call StgSeries()<CR>
nnoremap <leader>sj :call StgPop()<CR>
nnoremap <leader>sk :call StgPush()<CR>
nnoremap <leader>sr :!stg refresh -i<CR>
```
