This is my personal Vim configuration and its associated scripts. If you would like to make use of it, feel free to clone:

	git clone --recursive https://github.com/cgioia/vimrc.git

Once cloning is complete, create some symbolic links in your home directory to get vim pointed at the right files:

	ln -s vimrc/vimrc .vimrc
	ln -s vimrc/vim/ .vim

Additionally, the [Command-T][ct] script requires a compile step in order to use it. Provided you have ruby installed:

	cd ~/.vim/bundle/Command-T/ruby/command-t/ext/command-t
	ruby extconf.rb
	make

I have—shall we say—borrowed quite liberally from both [Vincent Driessen][nvie] and [Steve Losh][sjl] to get everything where it is. So, credit where credit is due.

[nvie]: https://github.com/nvie/vimrc
[sjl]: https://bitbucket.org/sjl/dotfiles
[ct]: https://github.com/wincent/Command-T
