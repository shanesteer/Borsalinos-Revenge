setlocal
if NOT "%UE_SDKS_ROOT%"=="" (call %UE_SDKS_ROOT%\HostWin64\Android\SetupEnvironmentVars.bat)
set ANDROIDHOME=%ANDROID_HOME%
if "%ANDROIDHOME%"=="" set ANDROIDHOME=C:\Users\shane\AppData\Local\Android\Sdk
set ADB=%ANDROIDHOME%\platform-tools\adb.exe
set DEVICE=
if not "%1"=="" set DEVICE=-s %1
for /f "delims=" %%A in ('%ADB% %DEVICE% shell "echo $EXTERNAL_STORAGE"') do @set STORAGE=%%A
@echo.
@echo Uninstalling existing application. Failures here can almost always be ignored.
%ADB% %DEVICE% uninstall com.YourCompany.CapstoneProject
@echo.
@echo Installing existing application. Failures here indicate a problem with the device (connection or storage permissions) and are fatal.
%ADB% %DEVICE% install CapstoneProject-Android-Shipping_universal.apk
@if "%ERRORLEVEL%" NEQ "0" goto Error
%ADB% %DEVICE% shell rm -r %STORAGE%/UE4Game/CapstoneProject
%ADB% %DEVICE% shell rm -r %STORAGE%/UE4Game/UE4CommandLine.txt
%ADB% %DEVICE% shell rm -r %STORAGE%/obb/com.YourCompany.CapstoneProject
%ADB% %DEVICE% shell rm -r %STORAGE%/Android/obb/com.YourCompany.CapstoneProject
%ADB% %DEVICE% shell rm -r %STORAGE%/Download/obb/com.YourCompany.CapstoneProject
@echo.
@echo Installing new data. Failures here indicate storage problems (missing SD card or bad permissions) and are fatal.
%ADB% %DEVICE% push main.6.com.YourCompany.CapstoneProject.obb /data/local/tmp/obb/com.YourCompany.CapstoneProject/main.6.com.YourCompany.CapstoneProject.obb
if "%ERRORLEVEL%" NEQ "0" goto Error






%ADB% %DEVICE% shell mkdir %STORAGE%/Android/obb/com.YourCompany.CapstoneProject
%ADB% %DEVICE% shell mv /data/local/tmp/obb/com.YourCompany.CapstoneProject %STORAGE%/Android/obb/
if "%ERRORLEVEL%" NEQ "0" goto Error
%ADB% %DEVICE% shell rm -r /data/local/tmp/obb/
@echo.




@echo.
@echo Installation successful
goto:eof
:Error
@echo.
@echo There was an error installing the game or the obb file. Look above for more info.
@echo.
@echo Things to try:
@echo Check that the device (and only the device) is listed with "%ADB$ devices" from a command prompt.
@echo Make sure all Developer options look normal on the device
@echo Check that the device has an SD card.
@pause
