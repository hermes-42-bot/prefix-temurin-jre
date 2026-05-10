@echo on

echo "Creating activate/deactivate directories..."
for %%C in (activate deactivate) do (
    if not exist "%PREFIX%\etc\conda\%%C.d" mkdir "%PREFIX%\etc\conda\%%C.d"
    copy "%RECIPE_DIR%\scripts\%%C.bat" "%PREFIX%\etc\conda\%%C.d\temurin-jre_%%C.bat"
    copy "%RECIPE_DIR%\scripts\%%C-win.sh" "%PREFIX%\etc\conda\%%C.d\temurin-jre_%%C.sh"
)

echo "Creating java home..."
if not exist "%PREFIX%\Library\temurin" mkdir "%PREFIX%\Library\temurin"

echo "Moving JRE files..."
for %%D in (bin conf legal lib) do (
    if exist "%%D" (
        xcopy /s /y /i "%%D" "%PREFIX%\Library\temurin\%%D\" >nul
    )
)
if exist "NOTICE" copy "NOTICE" "%PREFIX%\Library\temurin\"
if exist "release" copy "release" "%PREFIX%\Library\temurin\"

echo "Creating bin directory..."
if not exist "%PREFIX%\bin" mkdir "%PREFIX%\bin"

for %%F in ("%PREFIX%\Library\temurin\bin\*.exe") do (
    mklink "%PREFIX%\bin\%%~nF.exe" "%%F" >nul 2>&1 || copy "%%F" "%PREFIX%\bin\%%~nF.exe" >nul
)

set "JAVA_HOME=%PREFIX%\Library\temurin"

echo "Verifying installation..."
"%JAVA_HOME%\bin\java.exe" -version

echo "Running java -Xshare:dump..."
"%JAVA_HOME%\bin\java.exe" -Xshare:dump || echo "CDS dump skipped"

echo "Build complete."
