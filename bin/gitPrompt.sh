#!/bin/bash

# git prompt, developed (plus others) with the help of
#   https://stackoverflow.com/questions/21517281/ps1-command-substitution-fails-when-containing-newlines-on-msys-bash
#   http://stackoverflow.com/questions/8254120/how-to-escape-a-single-quote-in-single-quote-string-in-bash
# and a lot of time.
# The file can be seen here:
#   https://github.com/Dirk1966/NotPad/blob/gitPrompt/gitPrompt.sh

called=$_
# echo "called=${called} \$0=${0}"
if [ "${called}" == "${0}" ]
then
  echo "Script ${0} can be sourced to set the PS1"
  echo "prompt environment parameter."
  echo "  Call with \". ${0}\" to set a simple black and white prompt."
  echo "  Call with \". ${0} total\" to set a fancy colored prompt."
  echo "Supported parameters: (none), [total/full/color/clean]."
  echo "  Call with \". ${0} clean\" sets a black and"
  echo "       white prompt and resets the Window title to \"\"."
else
  # Reset
  ColOff="\033[0m"       # Text Reset

  # Regular Colors          Bold
  Black="\033[0;30m"  ; BBlack="\033[1;30m"    # Black
  Red="\033[0;31m"    ; BRed="\033[1;31m"      # Red
  Green="\033[0;32m"  ; BGreen="\033[1;32m"    # Green
  Yellow="\033[0;33m" ; BYellow="\033[1;33m"   # Yellow
  Blue="\033[0;34m"   ; BBlue="\033[1;34m"     # Blue
  Purple="\033[0;35m" ; BPurple="\033[1;35m"   # Purple
  Cyan="\033[0;36m"   ; BCyan="\033[1;36m"     # Cyan
  White="\033[0;37m"  ; BWhite="\033[1;37m"    # White

  if [ "> " == "$PS2" ]
  then
    PS2="» "
  fi

  if [ "TEST" == "${1}" ]
  then
    echo "PS1 set for TEST purposes."
    echo "Set simple black and white prompt, but should be area to do some fancy test stuff here!"
    # Various variables you might want for your PS1 prompt instead
    Time12h="\T"      ; Time12a="\@"
    PathShort="\w"    ; PathFull="\W"
    NewLine="\n"      ; Jobs="\j"
    export PS1="\t \
\u@\
\h:\
\w"\
'$(M=$(git branch 2>/dev/null | sed -n -e "s/^\*\ \(.*\)/ (\1)/p")
if [ "M" != "M${M}" ]
then
  echo "${M}"
else
  echo " <<no git branch>>"
fi)'\
''$'\nξ '  # ''$' for msys (git for Windows 2)

  export PS1

  elif [ "staycurious" == "${1}" ]
  then
    echo "Set PS1-total."

    export PS1='$(M=$(git branch 2>/dev/null | sed -n -e "s/^\*\ \(.*\)/ (\1)/p")
echo -n -e "\033]0;Stay curious and sound!\007\
${BPurple}\t${ColOff} \
${Green}\u${ColOff}@${Green}\h${ColOff} \
${BBlue}\w${ColOff}\
${Cyan}${M}${ColOff}")'\
''$'\nξ '  # MSYS: Escaping \n with '$'

  elif [ "full" == "${1}" -o "color" == "${1}" ]
  then
    if [ "full" == "${1}" ]
    then
      echo "Set PS1-full"
      # Header
      PS1='\[\033]0;\u@\h:\w\007\]'
    else
      echo "PS1-color (colored)."
      PS1=''
    fi
    export PS1="${PS1}${BPurple}\t${ColOff} \
${Green}\u${ColOff}@\
${Green}\h${ColOff}:\
${BBlue}\w${ColOff}"\
${Cyan}\
'$(git branch 2>/dev/null | sed -n -e "s/^\*\ \(.*\)/ (\1)/p")'\
${ColOff}\
''$'\nξ '  # ''$' for msys (git for Windows 2)

  elif [ "total" == "${1}" ]
  then
    echo "Set PS1-total."

    export PS1='$(M=$(git branch 2>/dev/null | sed -n -e "s/^\*\ \(.*\)/ (\1)/p")
echo -n -e "\033]0;\u@\h \w ${M}\007\
${BPurple}\t${ColOff} \
${Green}\u${ColOff}@${Green}\h${ColOff} \
${BBlue}\w${ColOff}\
${Cyan}${M}${ColOff}")'\
''$'\nξ '  # MSYS: Escaping \n with '$'

  elif [ "full" == "${1}" -o "color" == "${1}" ]
  then
    if [ "full" == "${1}" ]
    then
      echo "Set PS1-full"
      # Header
      PS1='\[\033]0;\u@\h:\w\007\]'
    else
      echo "PS1-color (colored)."
      PS1=''
    fi
    export PS1="${PS1}${BPurple}\t${ColOff} \
${Green}\u${ColOff}@\
${Green}\h${ColOff}:\
${BBlue}\w${ColOff}"\
${Cyan}\
'$(git branch 2>/dev/null | sed -n -e "s/^\*\ \(.*\)/ (\1)/p")'\
${ColOff}\
''$'\nξ '  # ''$' for msys (git for Windows 2)

  else
    echo "Set PS1-bw (black and white)."
    if [ "clean" == "${1}" ]
    # if [ "0" != $( echo "$PS1" | grep "\\033]0;.*\\007" | wc -l ) ]
    then
      echo -e '\033]0;\007Resetting window title to "".'
    fi
    export PS1='\t \u@\h:\w$(git branch 2>/dev/null | sed -n -e "s/^\*\ \(.*\)/ (\1)/p")'$'\n$ '
  fi
fi
