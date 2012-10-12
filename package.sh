#!/bin/bash

DOZIP=false
DODELETE=false

while getopts "v:zd" opt; do
	case $opt in
		v)
			VERSION=$OPTARG
		;;
		z)
			DOZIP=true
		;;
		d)
			DODELETE=true
		;;
		\?)
			echo "Invalid option: -$OPTARG" >&2
			exit 1
		;;
		:)
			echo "Option -$OPTARG requires an argument." >&2
			exit 1
		;;
	esac
done

# Clone repository
git clone git://github.com/symphonycms/symphony-2.git symphony-$VERSION

# Checkout desired version
cd symphony-$VERSION
git checkout $VERSION

# Initialize submodules
git submodule update --init

# Clone Workspace
git clone git://github.com/symphonycms/workspace.git

# Checkout latest version of workspace
cd workspace
git checkout integration
cd ../

# Remove Git cruft
for i in `find . -name '.git*'`; do
	rm -rf $i
done

cd ../

# Zip it
if [ $DOZIP == true ]; then
	zip -r symphony$VERSION.zip symphony-$VERSION
fi

# Delete folder
if [ $DODELETE == true ]; then
	rm -rf symphony-$VERSION/
fi