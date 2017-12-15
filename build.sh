#!/bin/sh

xcodebuild archive \
-workspace "selfish.xcworkspace" \
-scheme "selfish" \
-configuration "release" \
-archivePath "build/selfish.xcarchive" \
clean \
build \
-derivedDataPath "build/"


