# StGit.nvim
A plugin to work with Stacked Git (stgit) inside Neovim.

`Warning! This is highly untested. If you value your repository don't run this plugin!`

## Install
I've only used Plug myself:

```
Plug 'joalon/stgit-unofficial.nvim'
```

The only command as of yet can be called with `require('stgit').Series()` which will
bring up a split with the current patch series. In the split the top can be pushed
or popped with Ctrl-j or Ctrl-k repspectively. Pressing `dd` will mark the patch
under the cursor for deletion. Writing the buffer (:w) will execute the changes.
If the index is dirty it will temporarily be stored on the git stash.

## Features
Right now you can... Check, push, pop and delete your patches! Seriously, that's it right now.
