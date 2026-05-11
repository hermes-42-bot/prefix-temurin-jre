#!/bin/bash
set -e

echo "Setting archive path..."
if [ "$(uname -s)" == "Darwin" ]; then
    ARCHIVE_PATH="Contents/Home/"
else
    ARCHIVE_PATH=""
fi

echo "Copying license file for packaging..."
if [ "$(uname -s)" == "Darwin" ]; then
    cp "${ARCHIVE_PATH}NOTICE" ./NOTICE 2>/dev/null || true
fi

echo "Creating library directory..."
mkdir -p "${PREFIX}/opt/temurin/lib"

echo "Copying graphics libraries..."
for ITEM in libawt_xawt libsplashscreen libjsound libjawt; do
    if [ -e "${ARCHIVE_PATH}lib/${ITEM}.so" ]; then
        cp "${ARCHIVE_PATH}lib/${ITEM}.so" "${PREFIX}/opt/temurin/lib/"
    fi
    if [ -e "${ARCHIVE_PATH}lib/${ITEM}.dylib" ]; then
        cp "${ARCHIVE_PATH}lib/${ITEM}.dylib" "${PREFIX}/opt/temurin/lib/"
    fi
done

echo "Build complete."
