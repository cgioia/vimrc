This is my personal Vim configuration and its associated scripts. If you would like to make use of it, feel free to clone:

	git clone git://github.com/cgioia/vimrc.git

All of the scripts I use are actually git submodules, and you'll need to clone them too:

	cd vimrc
	git submodule update --init

Once cloning is complete, create some symbolic links to get vim pointed at the right files:

	ln -s vimrc ~/.vimrc
	ln -s vim/ ~/.vim

Additionally, the [Command-T][ct] script requires a compile step in order to use it. Provided you have ruby installed:

	cd vim/bundle/Command-T
	rake make

I have—shall we say—_borrowed_ quite liberally from both [Vincent Driessen][nvie] and [Steve Losh][sjl] to get everything where it is. So, credit where credit is due.

[nvie]: https://github.com/nvie/vimrc
[sjl]: https://bitbucket.org/sjl/dotfiles/
[ct]: https://github.com/wincent/Command-T
