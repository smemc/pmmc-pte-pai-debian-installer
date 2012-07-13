#!/bin/sh

apply_patches() {
    DATA_DEST=$1
    PDIR=$PWD/patches
    count=0

    echo "Patching HTML files according to new filenames and/or HTML code for accents... "
    sleep 1

    cd $DATA_DEST

    for patch_file in $PDIR/*
    do
        patch -p0 < $patch_file
        count=$(( count + 1 ))
    done

    echo "$count files patched."

    sleep 1
}

apply_patches $1
