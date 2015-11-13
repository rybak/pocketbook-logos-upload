#!/bin/bash

set -u
set -e

CONFIG='./upload.conf'
source "$CONFIG"

usage()
{
    HELPDEST="$(dirname $DEST)"
    HELPDEST="$(dirname $HELPDEST)"
    echo "
upload.sh
    Upload good logos to Pocketbook mounted on $HELPDEST
Usage: upload.sh [list | upload | check | help ]
    list   : list good logos
    upload : upload good logos to pocketbook
    check  : list logos on pocketbook
    help   : show this text
"
}

list()
{
    find ./ -iregex "[^2]*.bmp" | grep -v 0
}

check()
{
    echo "Content of $DEST"
    ls -AFlh "$DEST"
}

if [[ -d "$DEST" ]]
then
    echo Pocketbook detected
    OK=true
else
    echo Pocketbook not detected
    OK=false
fi

if [[ $# -gt 0 ]]
then
    case "$1" in
    "list" )
        list
        ;;
    "upload" )
        if $OK
        then
            NOCLOBBER="-n"
            if [ "$2" == "force" ];
            then
                NOCLOBBER=
            fi
            list | xargs -ISRC cp SRC "$DEST" $NOCLOBBER
        else
            echo "Can not upload."
            exit
        fi
        ;;
    "check" )
        if $OK
        then
            check
        else
            echo "Can not check."
        fi
        ;;
    * )
        echo "Not a command : $1"
        usage
        ;;
    esac
else
    echo "no command specified"
    usage
fi

