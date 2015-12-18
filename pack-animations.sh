#!/bin/bash

prefix=bootanimation-
restore_package=nonstock-rom-restore

# Cleanup
rm -f $prefix*.zip
rm $restore_package.zip

# Check for logo files > 4 MiB (The logo partition on Moto G devices is exactly 4 MiB)
error=false
for logo in `ls -1 boot-animations/*/logo/*/logo.bin`; do
    if [ `stat --printf="%s" $logo` -gt 4194304 ]; then
        echo "ERROR: logo file is greater than 4 MiB: $logo"
        error=true
    fi
done

# Abort on error
if [ "$error" = true ]; then
    echo "Please reduce the size of logo files and try again"
    exit 1
fi

# Zip the boot animations
for animation in `ls -1 boot-animations`; do
    zip -r $prefix$animation.zip META-INF
    zip -r $prefix$animation.zip bootanimation
    cd boot-animations/$animation
    zip -r ../../$prefix$animation.zip .
    cd ../..
done

# Zip the restore package
zip -r $restore_package.zip META-INF
cd restore
zip -r ../$restore_package.zip META-INF
cd ..
