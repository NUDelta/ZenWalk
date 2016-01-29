#!/bin/bash
# original source from http://www.thecave.com/2014/09/16/using-xcodebuild-to-export-a-ipa-from-an-archive/

xcodebuild clean -project ZenWalk -configuration Release -alltargets
xcodebuild archive -project ZenWalk.xcodeproj -scheme ZenWalk -archivePath ZenWalk.xcarchive
xcodebuild -exportArchive -archivePath ZenWalk.xcarchive -exportPath ZenWalk -exportFormat ipa -exportProvisioningProfile "Delta Lab"
