# Build AltTabber with llvm-mingw (no Visual Studio required).
# Usage: TOOLCHAIN=/path/to/llvm-mingw/bin sh build-mingw.sh
set -e
TOOLCHAIN="${TOOLCHAIN:?set TOOLCHAIN to llvm-mingw bin dir}"
CXX="$TOOLCHAIN/x86_64-w64-mingw32-clang++"
WINDRES="$TOOLCHAIN/x86_64-w64-mingw32-windres"

cd "$(dirname "$0")/AltTabber"
mkdir -p ../build

"$WINDRES" -c 65001 AltTabber.rc ../build/AltTabber.res.o

"$CXX" -municode -DUNICODE -D_UNICODE -DWIN32 -DNDEBUG \
    -DWINVER=0x0A00 -D_WIN32_WINNT=0x0A00 -D_WIN32_IE=0x0A00 -DNTDDI_VERSION=0x0A000000 \
    -O2 -std=c++17 -static -mwindows \
    -Wall -Wno-unknown-pragmas -Wno-writable-strings \
    AltTabber.cpp Gui.cpp Log.cpp MonitorGeom.cpp MoveFunctions.cpp \
    OverlayActivation.cpp Registry.cpp UIAutomationProvider.cpp stdafx.cpp \
    ../build/AltTabber.res.o \
    -o ../build/AltTabber.exe \
    -ldwmapi -lpsapi -luiautomationcore -lole32 -loleaut32 \
    -lgdi32 -lcomctl32 -lshell32 -luser32 -ladvapi32

echo "OK: $(cd ..; pwd)/build/AltTabber.exe"
