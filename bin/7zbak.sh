#!/bin/bash
lCompr=7z

IFS="$(printf '\t\n\r')"

fPrintUsage(){
  echo "Create a file backup with the ${lCompr} compressor."
  echo "  Supply file name as parameter."
  echo "  Time stamp of last change of file in UTC will be appended to the file name."
}

if [ ${#} = 0 ]
then
  fPrintUsage
elif [ ${#} = 1 ]
then
  # ps -fu ${USER} | egrep -e "(${1})"
  if [ ! -e "${1}" ]
  then
    echo "File/Directory \"${1}\" to compress not found, will exit."
    exit 1
  fi
  export TZ=utc
  if [ -f "$1" ]
  then
    FN=$( date -u +%Y-%m-%d_%Hu%M_%S -r "$1" )
  elif [ -d "$1" ]
  then
    # https://stackoverflow.com/questions/1015678/get-most-recent-file-in-a-directory-on-linux
    FNel=$( ls -At "$1" | head -n 1 )
    FN=$( date -u +%Y-%m-%d_%Hu%M_%S -r "$1/$FNel" )
  else
    echo "Only real files or directories are allowed"
    exit 1
  fi
  FN=$( echo "$( basename ${1} )--${FN}.${lCompr}" )
  if [ ! -f "${FN}.001" ]
  then
    echo "Start compressing \"${1}\" into 650MB file(s)"
    echo "\"${FN}.[0-9][0-9][0-9]\" with ${lCompr}."
    echo "${lCompr} -v650m a \"${FN}\" \"${1}\""
    ${lCompr} -v650m a "${FN}" "${1}"
    lRet=$?
    if [ "0" != "${lRet}" ]
    then
      echo "Error ${lRet} while compressing \"${1}\"."
      echo "Think of removing \"${FN}\"."
    fi
  else
    echo "Found already existing file \"${FN}.001\","
    echo "will not compress file \"${1}\" with ${lCompr}."
    exit 2
  fi
else
  fPrintUsage
fi
