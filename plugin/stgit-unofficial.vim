
function StgSeries()
    lua require('stgit-unofficial').series()
endfunction

function StgPop()
    lua require('stgit-unofficial').stage_pop()
endfunction

function StgPush()
    lua require('stgit-unofficial').stage_push()
endfunction

function StgDelete()
    lua require('stgit-unofficial').stage_delete()
endfunction

function StgExecute()
    lua require('stgit-unofficial').execute_staged()
endfunction

command! -nargs=* Stg lua require('stgit-unofficial').exec({<q-args>})
