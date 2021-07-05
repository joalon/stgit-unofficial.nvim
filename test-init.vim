let mapleader="\<Space>"

" stgit config
nnoremap <leader>ss :call StgSeries()<CR>
nnoremap <leader>sk :call StgPop()<CR>
nnoremap <leader>sj :call StgPush()<CR>
nnoremap <leader>se :call StgExecute()<CR>
nnoremap <leader>sr :!stg refresh -i<CR>
