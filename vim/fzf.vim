let g:mru_files = get(g:, 'mru_files', [])

function! UpdateMRUFiles(filename)
  let filename = fnamemodify(a:filename, ":~:.")
  call filter(g:mru_files, 'v:val !=# filename')
  call add(g:mru_files, filename)
endfunction

augroup fzf_filemru
  autocmd!
  autocmd BufWritePost * call UpdateMRUFiles(expand('%'))
  autocmd BufReadPost * call UpdateMRUFiles(expand('%'))
augroup END

function! FZFGitFolders(...)
  let root = split(system('git rev-parse --show-toplevel'), '\n')[0]
  if v:shell_error
    return s:warn('Not in git repo')
  endif
  let source = split(system('git ls-tree -rd HEAD'), '\n')
  return fzf#run({'source': source, 'sink': 'e', 'options': '--reverse'})
endfunction

function! FZFGitFiles(...)
  let root = split(system('git rev-parse --show-toplevel'), '\n')[0]
  if v:shell_error
    return s:warn('Not in git repo')
  endif
  let mru = reverse(copy(g:mru_files))
  let files = split(system('git ls-files -oc --exclude-standard'))
  let relative_mru = filter(copy(mru), 'index(files, v:val) != -1')
  let filename = fnamemodify(expand('%'), ":~:.")
  let relative_mru_without_current = filter(copy(relative_mru), 'v:val !=# filename')
  let files_without_mru = filter(copy(files), 'index(relative_mru, v:val) == -1')
  let source = extend(relative_mru_without_current, files_without_mru)
  return fzf#run({'source': source, 'sink': 'e', 'options': '--reverse'})
endfunction
