#!/usr/bin/env bash
# dependencies: 
# sudo snap install yq

# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=$(dirname "$SCRIPT")
WORKSPACEPATH="$SCRIPTPATH/.."

VERSION=$(cat $WORKSPACEPATH/vendor/package.json | jq -r '.dependencies["simple-icons-font"]')
VERSIONNUMBER=$(echo "$VERSION" | tr -d ^)

# check if version not in changelog and create new pubspec.yaml and add to CHANGELOG.md
if grep -q $VERSIONNUMBER $WORKSPACEPATH/CHANGELOG.md
then
    echo "Version Entry exists already in Changelog";
else
    echo "Adding new Version Entry";

    # creates new pubspec.yaml
    cat $WORKSPACEPATH/pubspec.yaml | yq e ".version = \"$VERSIONNUMBER\"" -i $WORKSPACEPATH/pubspec.yaml

    # adds line to CHANGELOG.md
    echo "## [$VERSIONNUMBER] - auto_generated update\n- real changelog\n" | cat - $WORKSPACEPATH/CHANGELOG.md > $WORKSPACEPATH/CHANGELOG.tmp.md
    mv -f $WORKSPACEPATH/CHANGELOG.tmp.md $WORKSPACEPATH/CHANGELOG.md
fi