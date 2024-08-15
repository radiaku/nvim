" Enable Mouse
set mouse=a
" tnoremap <Esc> <C-\><C-n> 
"
"

nnoremap <Tab> <Esc>

let s:fontsize = 14
function! AdjustFontSize(amount)
  echom "AdjustFontSize"
  let s:fontsize = s:fontsize + a:amount
  " let fontname = "CaskaydiaCove\ NF:h" . s:fontsize
  let fontname = "JetBrainsMono\ Nerd\ Font:h" . s:fontsize
  execute "GuiFont! " . fontname
endfunction

function! ResetFont()
  echom "ResetFont"
  execute "GuiFont! JetBrainsMono Nerd Font:h14"
endfunction


" Set Editor Font
if exists(':GuiFont')
  noremap <C-ScrollWheelUp> :call AdjustFontSize(1)<CR>
  noremap <C-ScrollWheelDown> :call AdjustFontSize(-1)<CR>
  inoremap <C-ScrollWheelUp> <Esc>:call AdjustFontSize(1)<CR>a
  inoremap <C-ScrollWheelDown> <Esc>:call AdjustFontSize(-1)<CR>a

  " Ctrl + Dash
  noremap <C--> :call AdjustFontSize(-1)<CR>

  " Ctrl + Equals (Plus)
  noremap <C-=> :call AdjustFontSize(1)<CR>

  " Ctrl + Equals (Plus)

  " Use GuiFont! to ignore font errors
  GuiFont! CaskaydiaCove\ NF:h12
  inoremap <silent> <S-Insert> <C-R>+
  cnoremap <S-Insert> <C-R>+
endif

" Disable GUI Tabline
if exists(':GuiTabline')
  GuiTabline 0
endif

" Disable GUI Popupmenu
if exists(':GuiPopupmenu')
  GuiPopupmenu 0
endif

" Enable GUI ScrollBar
if exists(':GuiScrollBar')
  GuiScrollBar 1
endif
"
if exists(':GuiWindowOpacity')
  GuiWindowOpacity 0.98 
endif

" Right Click Context Menu (Copy-Cut-Paste)
if exists(':GuiPopupmenu')
  nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
  inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
  xnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
  snoremap <silent><RightMouse> <C-G>:call GuiShowContextMenu()<CR>gvgv
endif

if has("persistent_undo")
   let target_path = expand('~/.undodir')

    " create the directory and any parent directories
    " if the location does not exist.
    if !isdirectory(target_path)
        call mkdir(target_path, "p", 0700)
    endif

    let &undodir=target_path
    set undofile
endif


