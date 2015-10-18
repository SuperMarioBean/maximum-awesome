# SMB Maximum Awesome

## 须知

在安装前应该尝试打开系统对安装程序的安全开关，因为本环境配置中会给 `Terminal.app` 安装一个 `solarized 配色`，会引发系统警告，当然，你也可以忽略这一步，最后手动安装。

## 特性

该版本库fork自[square/maximum-awesome][1], 根据自己的情况做了定制化的处理，比较大的处理如下：

+ 用 `neovim` 覆盖了系统的 `vim`

  本配置中只提供 cli 配置，不提供类似 macvim 的 gui 配置

> + 终端选择使用了 `Terminal.app`，而不是 `iTerm2`
>
>   `iTerm2` 固然好，但是始终感觉用不上，集成的 `tmux` 也没有让我感觉特别实用，还不如直接在命令行里面用 `tmux`。
>   相对麻烦的是为了和 `tmux` 兼容 ( `Terminal.app` 中开启 `tmux` 会无法响应鼠标事件，需要一个基于 `SIMBL` 的插件 `mouseterm` 才能)需要做一些额外的工作，这个在最后的脚本输出有提示，各位注意下。

> + 终端选择已经重新使用了 `iTerm2`, 最近 repo 主换了新机器, 然后`mouseterm` 也不好用了, 就换回来了

+ Mac OS X 10.11 El Capitan 之后, Terminal.app 内建支持鼠标事件, 不再需要 mouseterm 支持, 加之 oh-my-zsh 越来越慢, 所以索性换回了 Terminal.app 并且使用了 prezto.

+ 删除了一部分的和 `ruby` 相关的插件，增加了部分 `javascript` 相关的插件。加入 `youcompleteme` 插件

+ 增加工具 [tig][2]，在 rake 中加入了自动安装 `tig` 并建立 `.tigrc` 的链接，除了其内建的部分快捷键，我还增加了一些自己常用的快捷键，如果你想自定义更多，可以去 `tig` 的官网看看。

  通过 `,g` 来唤出 `tig` 界面。自定义的快捷键都是在 `tig` 的 `main` 视图

	  p git push %(branch)
	  f git fetch %(branch)
	  b git rebase %(branch)
	  B git rebase -i %(commit)
	  ! git revert %(commit)
	  \ git format-patch -1 %(commit)
	  | git format-patch %(commit)
	  a git am *.patch

  ps: 当你打开任何文件时，`vim` 都会自动 `cd` 到该目录下

# Maximum Awesome

Config files for vim and tmux, lovingly tended by a small subculture of
peace-loving hippies. Built for Mac OS X.

## What's in it?

* [MacVim][3] (independent or for use in a terminal)
* [iTerm 2][4]
* [tmux][5]
* Awesome syntax highlighting with the [Solarized color scheme][6]
* Want to know more? [Fly Vim, First Class][7]

### vim

* `,d` brings up [NERDTree][8], a sidebar buffer for navigating and manipulating files
* `,t` brings up [ctrlp.vim][9], a project file filter for easily opening specific files
* `,b` restricts ctrlp.vim to open buffers
* `,a` starts project search with [ag.vim][10] using [the silver searcher][11] (like ack, but faster)
* `ds`/`cs` delete/change surrounding characters (e.g. `"Hey!"` + `ds"` = `Hey!`, `"Hey!"` + `cs"'` = `'Hey!'`) with [vim-surround][12]
* `gcc` toggles current line comment
* `gc` toggles visual selection comment lines
* `vii`/`vai` visually select *in* or *around* the cursor's indent
* `Vp`/`vp` replaces visual selection with default register *without* yanking selected text (works with any visual selection)
* `,[space]` strips trailing whitespace
* `<C-]>` jump to definition using ctags
* `,l` begins aligning lines on a string, usually used as `,l=` to align assignments
* `<C-hjkl>` move between windows, shorthand for `<C-w> hjkl`

### tmux

* `<C-a>` is the prefix
* mouse scroll initiates tmux scroll
* `prefix v` makes a vertical split
* `prefix s` makes a horizontal split

If you have three or more panes:
* `prefix +` opens up the main-horizontal-layout
* `prefix =` opens up the main-vertical-layout

You can adjust the size of the smaller panes in `tmux.conf` by lowering or increasing the `other-pane-height` and `other-pane-width` options.

## Install

	rake

## Update

	rake

This will update all installed plugins using Vundle's `:PluginInstall!`
command. Any errors encountered during this process may be resolved by clearing
out the problematic directories in \~/.vim/bundle. `:help PluginInstall`
provides more detailed information about Vundle.

## Customize
In your home directory, Maximum Awesome creates `.vimrc.local`, `.vimrc.bundles.local` and `.tmux.conf.local` files where you can customize
Vim and tmux to your heart’s content. However, we’d love to incorporate your changes and improve Vim and tmux
for everyone, so feel free to fork Maximum Awesome and open some pull requests!

## Uninstall

	rake uninstall

Note that this won't remove everything, but your vim configuration should be reset to whatever it was before installing. Some uninstallation steps will be manual.

## Contribute

Before creating your pull request, consider whether the feature you want to add
is something that you think *every* user of maximum-awesome should have. Is it
support for a very common language people would ordinarily use vim to write? Is
it a useful utility that does not change many defaults and composes well with
other parts of maximum-awesome? If so then perhaps it would be a good fit. If
not, perhaps keep it in your `*.local` files. This does not apply to bug fixes.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Any contributors to the master maximum-awesome repository must sign the
[Individual Contributor License Agreement (CLA)][13].  It's a short form that
covers our bases and makes sure you're eligible to contribute.

When you have a change you'd like to see in the master repository, [send a pull
request](https://github.com/square/maximum-awesome/pulls). Before we merge your
request, we'll make sure you're in the list of people who have signed a CLA.

## Acknowledgements

Thanks to the vimsters at Square who put this together. Thanks to Tim Pope for
his awesome vim plugins.

[1]:	https://github.com/square/maximum-awesome
[2]:	https://github.com/jonas/tig
[3]:	https://code.google.com/p/macvim/
[4]:	http://www.iterm2.com/
[5]:	http://tmux.sourceforge.net/
[6]:	http://ethanschoonover.com/solarized
[7]:	http://corner.squareup.com/2013/08/fly-vim-first-class.html
[8]:	https://github.com/scrooloose/nerdtree
[9]:	https://github.com/kien/ctrlp.vim
[10]:	https://github.com/rking/ag.vim
[11]:	https://github.com/ggreer/the_silver_searcher
[12]:	https://github.com/tpope/vim-surround
[13]:	https://spreadsheets.google.com/spreadsheet/viewform?formkey=dDViT2xzUHAwRkI3X3k5Z0lQM091OGc6MQ&ndplr=1
