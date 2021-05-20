
#!/bin/bash

xcrun simctl shutdown all

path=$(find ~/Library/Developer/Xcode/DerivedData/Leeap-*/Build/Products/Debug-iphonesimulator -name "me.evanollivier.Leeap.app" | head -n 1)
echo "${path}"

filename=MultiSimConfig.txt
grep -v '^#' $filename | while read -r line
do
echo $line
xcrun instruments -w "$line"
xcrun simctl install booted $path
xcrun simctl launch booted me.evanollivier.leeap
done
