#!/bin/sh

NAME=ZING

# CONFIGDIR=~/Projects/configuration-management/etc
CONFIGDIR=etc
GITREPO=git://github.com/mklappstuhl/dotfiles.git
IDENTITY_FILE="$CONFIGDIR"/INSTALLED_BY_"$NAME"
STEPS=4

#
# This script is used to install configs on unix systems
#
# 1. remove all existing stuff (~/.etc)
#     - check if there is an identifying file so that no
#       personal data is accidentially deleted
# 2. clone repository recursively with all submodules
# 3. check for common dependency management tools
#    like vundle
# 4. link everything into homedirectory with dotfiles script
#
# X. Remind user to switch to his preferred shell
#
# It's officially awesome.
#

# Checks if there are existing files and asks
# user if those can be deleted
preflight () {
printf "[1/$STEPS] Checking for existing Files..." #DEBUG
if [ ! -d "$HOME/$CONFIGDIR" ]; then
  printf " none\n"
else
  printf " found\n"
  if [ ! -e "$IDENTITY_FILE" ]; then
    read -p "Do you wish to delete the existing files in $HOME/$CONFIGDIR? [Y/n] " yn
    case $yn in
         [Yy]* )
           rm -rf "$HOME/$CONFIGDIR"
           ;;
         [Nn]* )
           exit
           ;;
         * )
           printf "Please answer yes or no.\n"
           ;;
    esac
  fi
fi
}

getConfiguration() {
  printf "[2/$STEPS] Getting your configuration..."
  if git clone --recursive $GITREPO $HOME/$CONFIGDIR 2> /dev/null
  then : touch "$IDENTITY_FILE"
  else : printf "Something went wrong when cloning your configuration!\n"
  fi

  printf " done\n"
}

checkForVundle() {
  printf "[4/$STEPS] Looking for additional dependency management tools...\n"
  # change into $CONFIGDIR
  if grep -rq "vundle" $HOME/$CONFIGDIR
  then
    printf "> Looks like you are using Vundle...\n"
    read -p "> Do you want me to execute :BundleInstall! for you now? [Y/n] " yn
    case $yn in
         [Yy]* )
           vim -s-ex -c 'BundleInstall!' -c 'qa'
           ;;
         [Nn]* )
           exit
           ;;
         * )
           printf "Please answer yes or no.\n"
           ;;
    esac
  fi
}

getFileList() {
  find $HOME/$CONFIGDIR -maxdepth 1 | cut -d / -f 5 | grep -vE ".git"
}

getStatusOfFile() {
  local name="$1"
  local src="$CONFIGDIR/$name"
  local dst="$HOME/.$name"
  if ! test -e "$dst" ; then
    echo "."
  elif ! test -L "$dst" ; then
    echo "file"
  else
    local cur="$(readlink $dst)"
    if test "$cur" = "$src" ; then
      echo "OK"
    else
      echo "link $cur"
    fi
  fi
}

# DEBUGGING CODE
# dotfilesStatus() {
#   local name
#   getFileList | while read name ; do
#     local status=$(getStatusOfFile "$name")
#     printf "%-30s   %s\n" "$name" "$status"
#   done
# }

dotfilesInstall() {
  printf "[3/$STEPS] Installing symlinks into your home directory...\n"
  local name
  local force
  local verbose
  local skip=false
  local dry
  local -a files
  [ "${#files[@]}" -gt 0 ] || files=( $( getFileList ) )
  for name in ${files[@]} ; do
    printf "installing %-30s " "/$name"
    local status=$(getStatusOfFile "$name")
    if [ -z "$force" -a "$status" == "OK" ] ; then
      echo "correct link exists, $status"
    else
      echo
      if ! ( ln $force $verbose -s $HOME/$CONFIGDIR/$name .$name ) ; then
        local rc=$?
        $skip || return $rc
      fi
    fi
  done
}

preflight
getConfiguration
# dotfilesStatus
dotfilesInstall
checkForVundle
