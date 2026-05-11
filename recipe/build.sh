#!/bin/bash
set -e

echo "Creating activate/deactivate scripts..."
for CHANGE in "activate" "deactivate"; do
    mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
    cp "${RECIPE_DIR}/scripts/${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/temurin-jre_${CHANGE}.sh"
done

echo "Creating java home..."
mkdir -p "${PREFIX}/opt/temurin"

# macOS JREs have Contents/Home/ prefix
if [ "$(uname -s)" == "Darwin" ]; then
    ARCHIVE_PATH="Contents/Home/"
else
    ARCHIVE_PATH=""
fi

if [ "$(uname -s)" == "Darwin" ]; then
    cp "${ARCHIVE_PATH}NOTICE" ./NOTICE
fi

echo "Copying JRE files..."
for ITEM in bin conf legal lib NOTICE release; do
    if [ -e "${ARCHIVE_PATH}${ITEM}" ]; then
        cp -r "${ARCHIVE_PATH}${ITEM}" "${PREFIX}/opt/temurin/"
    fi
done

echo "Creating symlinks..."
mkdir -p "${PREFIX}/bin"
for exe in "${PREFIX}/opt/temurin/bin/"*; do
    basename_exe=$(basename "$exe")
    ln -sf "$exe" "${PREFIX}/bin/${basename_exe}"
done

export JAVA_HOME="${PREFIX}/opt/temurin"
export PATH="${JAVA_HOME}/bin:${PATH}"

echo "Verifying installation..."
java -version

echo "Creating CDS archive..."
java -Xshare:dump || true

# Remove X11/graphics-related libraries for a headless-like JRE
if [ "$(uname -s)" == "Darwin" ]; then
    rm -f "${PREFIX}/opt/temurin/lib/libsplashscreen.dylib" || true
    rm -f "${PREFIX}/opt/temurin/lib/libjsound.dylib" || true
    rm -f "${PREFIX}/opt/temurin/lib/libjawt.dylib" || true
else
    rm -f "${PREFIX}/opt/temurin/lib/libawt_xawt.so" || true
    rm -f "${PREFIX}/opt/temurin/lib/libsplashscreen.so" || true
    rm -f "${PREFIX}/opt/temurin/lib/libjsound.so" || true
    rm -f "${PREFIX}/opt/temurin/lib/libjawt.so" || true
fi

echo "Build complete."
