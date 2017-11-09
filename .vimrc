"  Показывать номера строк
set number
" Включить подсветку синтаксиса
syntax on
" Поиск в процессе набора
set incsearch
" Подсвечивание результатов поиска
set hlsearch
" умная зависимость от регистра. Детали `:h smartcase`
set ignorecase
set smartcase
" Кодировка текста по умолчанию utf8
set termencoding=utf8
" Включаем несовместимость настроек с Vi, так как Vi нам и не понадобится
set nocompatible
" Показывать положение курсора всё время.
set ruler
" Показывать незавершённые команды в статусбаре
set showcmd
" Фолдинг по отсупам
set foldenable
set foldlevel=100
set foldmethod=indent
" Выключаем звуковое оповещение о достижении конца буффера, невозможности действия и т.д.
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=
" Поддержка мыши
set mouse=a
set mousemodel=popup
" Не выгружать буфер, когда переключаемся на другой
" Это позволяет редактировать несколько файлов в один и тот же момент без необходимости сохранения каждый раз
" когда переключаешься между ними
set hidden
" Скрыть панель в gui версии
set guioptions-=T
" Сделать строку команд высотой в одну строку
set ch=1
" Скрывать указатель мыши, когда печатаем
set mousehide
" Включить автоотступы
set autoindent
" Не переносить строки
set nowrap
" Преобразование Таба в пробелы
" set expandtab
" Размер табуляции по умолчанию
set shiftwidth=8
set softtabstop=8
set tabstop=8
" Включаем "умные" отступы, например, авто отступ после `{`
set smartindent
" Отображение парных символов
set showmatch
" Навигация с учетом русских символов, учитывается командами следующее/предыдущее слово и т.п.
"set iskeyword=@,48-57,_,192-255
" Удаление символов бэкспэйсом в Windows
set backspace=indent,eol,start
" Увеличение размера истории
set history=200
" Дополнительная информация в строке состояния
set wildmenu
" Настройка отображения специальных символов
set list listchars=tab:→\ ,trail:·,extends:…
set textwidth=80
"autocmd BufNewFile,BufRead *.c,*.h exec 'match Todo /\%>' . &textwidth . 'v.\+/'
set clipboard=unnamedplus
" Включение сторонних плагинов
filetype plugin on

set tags=./tags,tags;
set laststatus=2

call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'terryma/vim-multiple-cursors'
Plug 'mbbill/undotree'
Plug 'easymotion/vim-easymotion'
call plug#end()
let g:airline_powerline_fonts = 1
"let g:airline_symbols.space = "\ua0"
let g:airline_theme='bubblegum'
nmap <Space>s <Plug>(easymotion-overwin-f)
