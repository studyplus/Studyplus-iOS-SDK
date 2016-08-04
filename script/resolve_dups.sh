#!/bin/sh

CWD=`echo $(cd $(dirname $0);pwd)`
cd $CWD

WORKING_DIR=work_`date +%Y%m%d%H%M%S`
mkdir $WORKING_DIR

ARMV7_TMP=$WORKING_DIR/libStudyplusSDK_armv7_tmp.a
ARMV7S_TMP=$WORKING_DIR/libStudyplusSDK_armv7s_tmp.a
ARM64_TMP=$WORKING_DIR/libStudyplusSDK_arm64_tmp.a
I386_TMP=$WORKING_DIR/libStudyplusSDK_i386_tmp.a
X86_64_TMP=$WORKING_DIR/libStudyplusSDK_x86_64_tmp.a

# backup
cp -p libStudyplusSDK.a libStudyplusSDK.a_`date +%Y%m%d%H%M%S`

divide_lib() {
  lipo -thin armv7 libStudyplusSDK.a -output $ARMV7_TMP
  xcrun -sdk iphoneos lipo -thin armv7s libStudyplusSDK.a -output $ARMV7S_TMP
  xcrun -sdk iphoneos lipo -thin arm64 libStudyplusSDK.a -output $ARM64_TMP
  lipo -thin i386 libStudyplusSDK.a -output $I386_TMP
  lipo -thin x86_64 libStudyplusSDK.a -output $X86_64_TMP
}

remove_dup() {
  LIB=$1
  DUP=$2
  ar -dv $LIB $DUP
}

divide_lib

for dup in $@
do
  for lib in $ARMV7_TMP $ARMV7S_TMP $ARM64_TMP $I386_TMP $X86_64_TMP
  do
    remove_dup $lib $dup
  done
done

# to fat lib
lipo -create $ARMV7_TMP $ARMV7S_TMP $ARM64_TMP $I386_TMP $X86_64_TMP -output libStudyplusSDK.a

# clean
rm -rf $WORKING_DIR

