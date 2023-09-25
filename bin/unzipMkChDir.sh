#!/usr/bin/env bash

function unzipMkChDir()
{
    local lErr=0
    if [ "1" != "$#" ]
    then
        echo "Only one parameter, name of zip file to extract!"
    return 1
    fi
    local lFilName="$@"
    local lFilNameFQ="$(readlink -f "$lFilName")"
    local lFilNameStrippedExt=${lFilNameFQ/\.zip/}
    if [ "$lFilNameStrippedExt" == "$lFilName" ]
    then
        echo "Could not extract directory name from file name \"$lFilName\""
        return 1
    fi
	local lDirNameBN="$(basename "$lFilNameStrippedExt")"
    if [ -d "$lDirNameBN" ]
    then
        echo "Directory \"$lDirNameBN\" exists already."
        return 1
    fi
    if [ ! -f "$lFilName" ]
    then
        echo "File \"$lFilName\" not found."
        return 1
    fi
    echo "lFilName=$lFilName lFilNameStrippedExt=$lFilNameStrippedExt lDirNameBN=$lDirNameBN"
    mkdir "$lDirNameBN"
    lErr=$?
	if [ "0" != "$lErr" ]
	then
	    echo "Error creating directory \"$lDirNameBN\""
		return 1
	fi
    cd "$lDirNameBN"
    lErr=$?
	if [ "0" != "$lErr" ]
	then
	    echo "Error changing to directory \"$lDirNameBN\""
		return 1
	fi
    local lCmd="unzip"
    $lCmd "$lFilNameFQ"
    return $?
}

unzipMkChDir "$@"
exit $?
