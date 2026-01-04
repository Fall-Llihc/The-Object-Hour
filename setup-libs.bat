@echo off
echo =============================================
echo The Object Hour - Library Setup Script
echo =============================================
echo.

:: Create lib directory if not exists
if not exist "lib" mkdir lib
if not exist "web\WEB-INF\lib" mkdir "web\WEB-INF\lib"

echo Checking required libraries...
echo.

:: Check PostgreSQL Driver
if not exist "lib\postgresql-42.7.3.jar" (
    echo [MISSING] postgresql-42.7.3.jar
    echo Downloading PostgreSQL Driver...
    powershell -Command "Invoke-WebRequest -Uri 'https://jdbc.postgresql.org/download/postgresql-42.7.3.jar' -OutFile 'lib\postgresql-42.7.3.jar'"
    if exist "lib\postgresql-42.7.3.jar" (
        echo [SUCCESS] Downloaded postgresql-42.7.3.jar
    ) else (
        echo [FAILED] Could not download postgresql-42.7.3.jar
        echo Please download manually from: https://jdbc.postgresql.org/download/
    )
) else (
    echo [OK] postgresql-42.7.3.jar
)

:: Check OpenPDF
if not exist "lib\openpdf-1.3.26.jar" (
    echo [MISSING] openpdf-1.3.26.jar
    echo Downloading OpenPDF...
    powershell -Command "Invoke-WebRequest -Uri 'https://repo1.maven.org/maven2/com/github/librepdf/openpdf/1.3.26/openpdf-1.3.26.jar' -OutFile 'lib\openpdf-1.3.26.jar'"
    if exist "lib\openpdf-1.3.26.jar" (
        echo [SUCCESS] Downloaded openpdf-1.3.26.jar
    ) else (
        echo [FAILED] Could not download openpdf-1.3.26.jar
        echo Please download manually from: https://repo1.maven.org/maven2/com/github/librepdf/openpdf/1.3.26/
    )
) else (
    echo [OK] openpdf-1.3.26.jar
)

:: Check JSTL
if not exist "web\WEB-INF\lib\jstl-1.2.jar" (
    echo [MISSING] jstl-1.2.jar
    echo Downloading JSTL...
    powershell -Command "Invoke-WebRequest -Uri 'https://repo1.maven.org/maven2/javax/servlet/jstl/1.2/jstl-1.2.jar' -OutFile 'web\WEB-INF\lib\jstl-1.2.jar'"
    if exist "web\WEB-INF\lib\jstl-1.2.jar" (
        echo [SUCCESS] Downloaded jstl-1.2.jar
    ) else (
        echo [FAILED] Could not download jstl-1.2.jar
    )
) else (
    echo [OK] jstl-1.2.jar
)

echo.
echo Copying libraries to WEB-INF/lib...
copy /Y "lib\*.jar" "web\WEB-INF\lib\" >nul 2>&1
echo Done!

echo.
echo =============================================
echo Library setup complete!
echo Please rebuild the project in NetBeans.
echo =============================================
pause
