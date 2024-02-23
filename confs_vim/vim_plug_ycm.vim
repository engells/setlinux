" vim:tabstop=8
" made by: Engells
" date: Jan 31, 2017
" content: setups for YouCompleteMe

set runtimepath+=~/.vim/plugs/YouCompleteMe
let g:ycm_collect_identifiers_from_tags_files = 1           " 採 tags files 模式
let g:ycm_collect_identifiers_from_comments_and_strings = 1 " 包括註釋與字串
let g:syntastic_ignore_files=[".*\.py$"]
let g:ycm_seed_identifiers_with_syntax = 1                  " 語法關鍵字補完
let g:ycm_complete_in_comments = 1
let g:ycm_confirm_extra_conf = 0
let g:ycm_key_list_select_completion = ['<c-n>', '<Down>']  " 改以 Crtl＋n，啟用補完 
let g:ycm_key_list_previous_completion = ['<c-p>', '<Up>']
let g:ycm_complete_in_comments = 1                          " 註釋輸入補完
let g:ycm_complete_in_strings = 1                           " 字串輸入補完
let g:ycm_collect_identifiers_from_comments_and_strings = 1 " 註釋與字串中的文字也納入補完
let g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
let g:ycm_show_diagnostics_ui = 0                           " 禁用語法檢查
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>" |            " Enter 代表確認目前選項
nnoremap <c-j> :YcmCompleter GoToDefinitionElseDeclaration<CR>|     " 跳到定義處
"let g:ycm_min_num_of_chars_for_completion=2                 " 自第 2 個鍵入值開始補完

