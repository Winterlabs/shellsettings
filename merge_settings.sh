#!/bin/bash

# super simple script to merge settings into home dir


function show_help () {

cat << EOF
$0 [-h -f -v]
-h : help
-f : force
-v : verbose
-d : dry run

EOF

}


function confirm_file () {

	local msg="$1"

	echo -ne "${msg}. Press Enter to continue. CTRL+C to cancel.\n"
	read confirm

}

function backup_file () {

	local SOURCE=$1
	local DEST=$2

	echo "source:  $SOURCE  dest: $DEST"

	if [ "$SOURCE" == "" ] || [ "$DEST" == "" ]; then
		echo "specify source and dest to backup function!"
		exit 2
	fi

	cp -v $SOURCE $DEST
}


FORCE=0
REPLACE=0
VERBOSE=0
DRYRUN=0


args=$(getopt hdfrvu: $*)

set -- $args
for i; do
	case "$i"
	in
		-h)
			show_help;
			exit 1;;
		-v)
			VERBOSE=1;
			shift;;
		-f)
			echo "setting FORCE";
			FORCE=1;
			shift;;
     -r)
			echo "setting REPLACE";
			REPLACE=1;
			shift;;
		-d)
			echo "setting DRYRUN";
			DRYRUN=1;
			shift;;
		-u)
			OVERRIDEUSER=$OPTARG
			echo "Override user to $OVERRIDEUSER"

     --)
  shift; break;;
        esac
done



if [ "$HOME" == "" ]; then
	echo "HOME is not set!"
	exit 1
fi


if [ "$1" == "-f" ]; then
	FORCE=1
fi

SETTINGSFILES=$(find . -iname ".*" -type f | egrep -v "\.swp$|\.gitignore$|\.git$")

if [ $FORCE -eq 0 ]; then
	echo "Going to merge the following files to $HOME"
	echo $SETTINGSFILES
	echo -e "\nEnter to continue. CTRL+C to cancel"
	read wait
fi


for file in $SETTINGSFILES; do

	DESTFILE="$HOME/$(basename $file)"

	if [ $REPLACE -eq 1 ]; then
		[ $VERBOSE -eq 1 ] && echo "replacing $file to $DESTFILE"

		[ $FORCE -eq 0 ] && confirm_file "Replace ${file}?"

		# if destionation file exists, backup it
		[ $DRYRUN -eq 0 ] && test -f "$DESTFILE" && backup_file "$DESTFILE" "${DESTFILE}.bak"

		[ $DRYRUN -eq 1 ] && echo "Dryrun: overwriting $DESTFILE with contents of $file"
		[ $DRYRUN -eq 0 ] && cat $file | egrep -v "^#--" > $DESTFILE

	else
		[ $VERBOSE -eq 1 ] && echo "merging $file to $DESTFILE"

		[ $FORCE -eq 0 ] && confirm_file "Merge into ${file}?"

		# if destionation file exists, backup it
		[ $DRYRUN -eq 0 ] && test -f "$DESTFILE" && backup_file "$DESTFILE" "${DESTFILE}.bak"

		[ $DRYRUN -eq 1 ] && echo "Dryrun: adding contents of $file to $DESTFILE"
		[ $DRYRUN -eq 0 ] && cat $file | egrep -v "^#--" >> $DESTFILE
	fi

done
