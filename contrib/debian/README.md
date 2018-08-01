
Debian
====================
This directory contains files used to package mnpcoind/mnpcoin-qt
for Debian-based Linux systems. If you compile mnpcoind/mnpcoin-qt yourself, there are some useful files here.

## mnpcoin: URI support ##


mnpcoin-qt.desktop  (Gnome / Open Desktop)
To install:

	sudo desktop-file-install mnpcoin-qt.desktop
	sudo update-desktop-database

If you build yourself, you will either need to modify the paths in
the .desktop file or copy or symlink your mnpcoinqt binary to `/usr/bin`
and the `../../share/pixmaps/mnpcoin128.png` to `/usr/share/pixmaps`

mnpcoin-qt.protocol (KDE)

