#!/bin/sh

LOCKFILE=nowbuilding.lock

if [ -e $LOCKFILE ]; then
  exit 0
fi

touch $LOCKFILE
pod install

run() {
  MODE=$1
  PRODUCT_NAME=StudyplusSDK
  HEADERS_DIR=./${PRODUCT_NAME}
  MODE_DIR=./build/${MODE}
  WORKING_DIR=${MODE_DIR}/working
  ARM_DIR=${WORKING_DIR}/arm
  I386_DIR=${WORKING_DIR}/i386
  X86_64_DIR=${WORKING_DIR}/x86_64
  DELIVERABLES_DIR=${MODE_DIR}/deliverables
  PROUDCT_DIR=${DELIVERABLES_DIR}/${PRODUCT_NAME}
  LIB_FILE_NAME=lib${PRODUCT_NAME}.a

  rm -rf $MODE_DIR
  mkdir -p $WORKING_DIR
  mkdir -p $ARM_DIR
  mkdir -p $I386_DIR
  mkdir -p $X86_64_DIR
  mkdir -p $DELIVERABLES_DIR
  mkdir -p $PROUDCT_DIR

  # iPhone
  xcodebuild -workspace StudyplusSDK.xcworkspace -scheme StudyplusSDK -configuration ${MODE} -sdk iphoneos        clean build ARCHS='armv7 armv7s arm64' VALID_ARCHS='armv7 armv7s arm64'
  xcodebuild -workspace StudyplusSDK.xcworkspace -scheme StudyplusSDK -configuration ${MODE} -sdk iphoneos        clean build ARCHS='armv7 armv7s arm64' VALID_ARCHS='armv7 armv7s arm64' TARGET_BUILD_DIR="${ARM_DIR}"

  # iPhone Simulator(32bit)
  xcodebuild -workspace StudyplusSDK.xcworkspace -scheme StudyplusSDK -configuration ${MODE} -sdk iphonesimulator clean build ARCHS='i386'
  xcodebuild -workspace StudyplusSDK.xcworkspace -scheme StudyplusSDK -configuration ${MODE} -sdk iphonesimulator clean build ARCHS='i386' TARGET_BUILD_DIR="${I386_DIR}"

  # iPhone Simulator(64bit)
  xcodebuild -workspace StudyplusSDK.xcworkspace -scheme StudyplusSDK -configuration ${MODE} -sdk iphonesimulator clean build ARCHS='x86_64' VALID_ARCHS='armv7 armv7s arm64 i386 x86_64'
  xcodebuild -workspace StudyplusSDK.xcworkspace -scheme StudyplusSDK -configuration ${MODE} -sdk iphonesimulator clean build ARCHS='x86_64' VALID_ARCHS='armv7 armv7s arm64 i386 x86_64' TARGET_BUILD_DIR="${X86_64_DIR}"

  # make universal library
  echo create $ARM_DIR/$LIB_FILE_NAME $I386_DIR/$LIB_FILE_NAME $X86_64_DIR/$LIB_FILE_NAME -output "${PROUDCT_DIR}/${LIB_FILE_NAME}"
  lipo -create $ARM_DIR/$LIB_FILE_NAME $I386_DIR/$LIB_FILE_NAME $X86_64_DIR/$LIB_FILE_NAME -output "${PROUDCT_DIR}/${LIB_FILE_NAME}"

  # headers
  cp -Rp $HEADERS_DIR/*.h $PROUDCT_DIR

  # documents
  cp -p ./LICENSE.txt $PROUDCT_DIR
  cp -p ./README.md $PROUDCT_DIR

  # zip
  cd $DELIVERABLES_DIR
  zip -9 -r ${PRODUCT_NAME}.zip ${PRODUCT_NAME}
  cd -

  return 0
}

archive() {
  ARCHIVE_DIR=build/archives
  ARCHIVE_NAME=`date +%Y_%m_%d_%H_%M_%S`.zip
  mkdir -p $ARCHIVE_DIR
  zip -r9 $ARCHIVE_DIR/$ARCHIVE_NAME build/Debug build/Release
}

echo "Archiving old deliverables..."
archive > /dev/null
echo "finish."
echo "===================================="
echo "Building with Debug configuration..."
run Debug > /dev/null
echo "finish."
echo "===================================="
echo "Building with Release configuration..."
run Release > /dev/null
echo "finish."
echo "===================================="
ls -lh build/**/deliverables/*.zip
echo "===================================="

rm $LOCKFILE
