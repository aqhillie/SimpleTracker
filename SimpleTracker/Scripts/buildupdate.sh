#!/bin/sh
#
# buildupdate.sh
# SimpleTracker
#
# Created by Alex Quintana on 10/17/24.
#
# Copyright (C) 2024 Warpixel
#

cd "$SRCROOT/$PROJECT_NAME"

awk -F "=" '/BUILD_NUMBER/ {print $2}' Config.xcconfig | tr -d ' '

old_build_number=$(awk -F "=" '/BUILD_NUMBER/ {print $2}' Config.xcconfig | tr -d ' ')
new_build_number=$((old_build_number + 1))

# update BUILD_NUMBER with new build number while backing up Config.xcconfig
# then delete the backup after it completes
sed -i -e "/BUILD_NUMBER =/ s/= .*/= $new_build_number/" Config.xcconfig >> log.txt
rm -f Config.xcconfig-e >> log.txt
