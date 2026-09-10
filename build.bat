@echo off
setlocal

set "PROJECT_DIR=%~dp0"
set "SRC=%PROJECT_DIR%src\main\java\com\healthcare"
set "OUT=%PROJECT_DIR%build\classes"
set "MYSQL_JAR=C:\Program Files\Java\mysql-connector-j-9.7.0.jar"
set "SERVLET_API=C:\Program Files\Apache Software Foundation\Tomcat 9.0\lib\servlet-api.jar"

if not exist "%OUT%" mkdir "%OUT%"

if not exist "%SERVLET_API%" (
    echo ERROR: Tomcat servlet-api.jar not found at:
    echo %SERVLET_API%
    echo Use Eclipse: Project - Clean - Build Project
    exit /b 1
)

echo Compiling backend servlets...
javac -encoding UTF-8 -cp "%SERVLET_API%;%MYSQL_JAR%" -d "%OUT%" ^
  "%SRC%\DBConnection.java" ^
  "%SRC%\PasswordUtil.java" ^
  "%SRC%\LoginServlet.java" ^
  "%SRC%\SignupServlet.java" ^
  "%SRC%\LogoutServlet.java" ^
  "%SRC%\AppointmentServlet.java" ^
  "%SRC%\AppointmentActionServlet.java" ^
  "%SRC%\DoctorServlet.java" ^
  "%SRC%\UpdateDoctorServlet.java" ^
  "%SRC%\DeleteDoctorServlet.java" ^
  "%SRC%\DeleteAppointmentServlet.java"

if errorlevel 1 (
    echo Compilation FAILED
    exit /b 1
)

copy /Y "%PROJECT_DIR%src\main\webapp\WEB-INF\classes\db.properties" "%OUT%\db.properties" >nul 2>&1
echo BUILD SUCCESS
dir /b "%OUT%\com\healthcare\*.class"
exit /b 0
