#!/bin/bash
# vim:ts=4
# program: To satrt up  a context environment
# made by: Engells
# date: Nov 25, 2012
# content: This script could run in normal or chroot environment

dir_texbin="/opt/context"
dir_texdoc="/home/tex"

source /opt/context/tex/setuptex					# enable context environment
$dir_texbin/bin/mtxrun --generate
$dir_texbin/bin/mtxrun --script fonts --reload		# load fonts cache

cd $dir_texdoc

unset dir_texbin; unset dir_texdoc

