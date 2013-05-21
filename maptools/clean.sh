#! /bin/sh

PWD="`dirname $0`"
cd "$PWD"
TARGET="../maps/$1"
cp "$TARGET" "$TARGET.modified"
git checkout -- "$TARGET"
java -jar MapPatcher.jar -clean "$TARGET" "$TARGET.modified" "$TARGET"
mv "$TARGET.modified" "/tmp/$1.bak"