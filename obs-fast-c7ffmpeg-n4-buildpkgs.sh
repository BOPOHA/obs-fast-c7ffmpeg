#!/bin/bash
LANG=en_US.UTF-8
REPONAME='obs-fast-c7ffmpeg'
export ACC=Admin
export REPO_NAME="home:$ACC:$REPONAME"
export TMP_DIR="/home/tmp"
export PKG_DIR="$HOME/$REPONAME"
mkdir -p $TMP_DIR 

cd $TMP_DIR
osc co $REPO_NAME
set -e
function push {
cd $TMP_DIR
PKG_NAME=$1
osc meta pkg $REPO_NAME $PKG_NAME -F - << EOF
<package name="$PKG_NAME">
<title>$PKG_NAME</title>
<description></description> 
</package>
EOF

cd $TMP_DIR/$REPO_NAME
osc up 
cd $TMP_DIR/$REPO_NAME/$PKG_NAME
rsync -av --delete --exclude=".osc/" $PKG_DIR/$PKG_NAME/ .
osc addremove
osc ci -m "init"
}

push lame
push ocl-icd
push x265
push x264
push xvidcore
push opencl-headers
push ffmpeg
push php-ffmpeg

osc results


