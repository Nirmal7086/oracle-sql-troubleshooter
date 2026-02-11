#!/bin/bash
################################################################################
# MinimalTodo - Build & Export Script
# Purpose: Build the iOS app and create an IPA for local installation
# Usage:   ./build.sh [debug|release]
#
# Prerequisites:
#   - macOS with Xcode 15+ installed
#   - Valid Apple Developer account (free or paid)
#   - Device registered in developer portal (for ad-hoc)
################################################################################

set -euo pipefail

SCHEME="MinimalTodo"
PROJECT="MinimalTodo.xcodeproj"
BUILD_DIR="build"
CONFIGURATION="${1:-Debug}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== MinimalTodo Build Script ===${NC}"
echo "Configuration: $CONFIGURATION"
echo ""

# Check Xcode
if ! command -v xcodebuild &> /dev/null; then
    echo -e "${RED}Error: xcodebuild not found. Install Xcode from the App Store.${NC}"
    exit 1
fi

# Clean previous build
echo -e "${YELLOW}Cleaning previous build...${NC}"
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Build archive
echo -e "${YELLOW}Building archive...${NC}"
xcodebuild archive \
    -project "$PROJECT" \
    -scheme "$SCHEME" \
    -configuration "$CONFIGURATION" \
    -archivePath "$BUILD_DIR/$SCHEME.xcarchive" \
    -destination "generic/platform=iOS" \
    CODE_SIGN_STYLE=Automatic \
    -allowProvisioningUpdates \
    | tail -20

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Archive created successfully.${NC}"
else
    echo -e "${RED}Archive failed. Check Xcode signing settings.${NC}"
    exit 1
fi

# Export IPA
echo -e "${YELLOW}Exporting IPA...${NC}"
xcodebuild -exportArchive \
    -archivePath "$BUILD_DIR/$SCHEME.xcarchive" \
    -exportOptionsPlist ExportOptions-dev.plist \
    -exportPath "$BUILD_DIR/export" \
    -allowProvisioningUpdates \
    | tail -10

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}=== Build Complete ===${NC}"
    echo -e "IPA location: ${GREEN}$BUILD_DIR/export/$SCHEME.ipa${NC}"
    echo ""
    echo "To install on your device:"
    echo "  1. Open Finder, connect your iPhone"
    echo "  2. Drag the .ipa file onto your device in Finder"
    echo "  -- OR --"
    echo "  1. Open Xcode > Window > Devices and Simulators"
    echo "  2. Select your device, click '+' under Installed Apps"
    echo "  3. Select the .ipa file"
else
    echo -e "${RED}Export failed. Check signing configuration.${NC}"
    exit 1
fi
