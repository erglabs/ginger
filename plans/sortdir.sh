#!/bin/bash

# works only based on extension,
# it would be to hard to check it based on file magic


function _g_setxdgdirs() {
	truncate -s 0 ~/.config/user-dirs.dirs
	echo 'XDG_DESKTOP_DIR="$HOME/.workspace"' >> ~/.config/user-dirs.dirs
	echo 'XDG_DOWNLOAD_DIR="$HOME/.downloads"' >> ~/.config/user-dirs.dirs
	echo 'XDG_TEMPLATES_DIR="$HOME/.templates"' >> ~/.config/user-dirs.dirs
	echo 'XDG_PUBLICSHARE_DIR="$HOME/.share"' >> ~/.config/user-dirs.dirs
	echo 'XDG_DOCUMENTS_DIR="$HOME/.media/doc"' >> ~/.config/user-dirs.dirs
	echo 'XDG_MUSIC_DIR="$HOME/.media/music"' >> ~/.config/user-dirs.dirs
	echo 'XDG_PICTURES_DIR="$HOME/.media/pic"' >> ~/.config/user-dirs.dirs
	echo 'XDG_VIDEOS_DIR="$HOME/.media/video"' >> ~/.config/user-dirs.dirs
}

function _g_check_xdg_dirs() {
	[[ -f ~/.config/user-dirs.dirs ]] && source ~/.config/user-dirs.dirs || "xdg not set"
	[[ ! -f ~/.config/user-dirs.dirs ]] && "xdg not set" && return 2

	echo "$XDG_DESKTOP_DIR"
	echo "$XDG_DOWNLOAD_DIR"
	echo "$XDG_TEMPLATES_DIR"
	echo "$XDG_PUBLICSHARE_DIR"
	echo "$XDG_DOCUMENTS_DIR"
	echo "$XDG_MUSIC_DIR"
	echo "$XDG_PICTURES_DIR"
	echo "$XDG_VIDEOS_DIR"
}

function _sortdir_vid() {
	echo sorting $(pwd)
	mv *.webm ${XDG_VIDEOS_DIR} 2>/dev/null
	mv *.mp4 ${XDG_VIDEOS_DIR} 2>/dev/null
	mv *.avi ${XDG_VIDEOS_DIR} 2>/dev/null
	mv *.mpeg ${XDG_VIDEOS_DIR} 2>/dev/null
}

function _sortdir_music() {
	echo sorting $(pwd)
	mv *.mp3 ${XDG_MUSIC_DIR} 2>/dev/null
	mv *.ogg ${XDG_MUSIC_DIR} 2>/dev/null
	mv *.acc ${XDG_MUSIC_DIR} 2>/dev/null
	mv *.wav ${XDG_MUSIC_DIR} 2>/dev/null
}

function _sortdir_pic() {
	echo sorting $(pwd)
	mv *.jpeg ${XDG_PICTURES_DIR} 2>/dev/null
	mv *.jpg ${XDG_PICTURES_DIR} 2>/dev/null
	mv *.png ${XDG_PICTURES_DIR} 2>/dev/null
	mv *.bmp ${XDG_PICTURES_DIR} 2>/dev/null
	mv *.gif ${XDG_PICTURES_DIR} 2>/dev/null
	mv *.png ${XDG_PICTURES_DIR} 2>/dev/null
	mv *.tiff ${XDG_PICTURES_DIR} 2>/dev/null
	mv *.webp ${XDG_PICTURES_DIR} 2>/dev/null
}

function _sortdir_doc() {
	echo sorting $(pwd)
	mv *.md ${XDG_DOCUMENTS_DIR} 2>/dev/null
	mv *.pdf ${XDG_DOCUMENTS_DIR} 2>/dev/null
	mv *.txt ${XDG_DOCUMENTS_DIR} 2>/dev/null
	mv *.nfo ${XDG_DOCUMENTS_DIR} 2>/dev/null
	mv *.info ${XDG_DOCUMENTS_DIR} 2>/dev/null
	mv *.tt ${XDG_DOCUMENTS_DIR} 2>/dev/null
	mv *.asci ${XDG_DOCUMENTS_DIR} 2>/dev/null
}

function _sortdir_all() {
	_sortdir_doc
	_sortdir_pic
	_sortdir_vid
	_sortdir_music
}