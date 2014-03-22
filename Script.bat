@echo off
COLOR 0A
mode con:cols=157
CLS
:MENU
CLS
echo  ---------------------------------------------------------------------------------------------------------------------------------------------------------
echo  ---------------------------------------------------------------------------------------------------------------------------------------------------------
echo        ///////////     ///////////     /////      /////            ///////////////////     /////////////     /////////////    ///            ///////////
echo        ///     ///     ///     ///     //////     /////            ///////////////////     ///       ///     ///       ///    ///            ///
echo        ///     ///     ///     ///     ///////   //////                    ///             ///       ///     ///       ///    ///            ///
echo        ///     ///     ///     ///     ///  /// /// ///                    ///             ///       ///     ///       ///    ///            ///
echo        ///     ///     ///     ///     ///   /////  ///                    ///             ///       ///     ///       ///    ///            ///////////
echo        ///////////     ///     ///     ///    ///   ///                    ///             ///       ///     ///       ///    ///                    ///
echo        ///  ///        ///     ///     ///     /    ///                    ///             ///       ///     ///       ///    ///                    ///
echo        ///   ///       ///     ///     ///          ///                    ///             ///       ///     ///       ///    ///                    ///
echo        ///    ///      ///     ///     ///          ///                    ///             ///       ///     ///       ///    ///                    ///
echo        ///     ///     ///////////     ///          ///                    ///             /////////////     /////////////    ///////////    ///////////
echo.
echo.
echo                                                               ============================
echo                                                                  Auto smali and Baksmali 
echo                                                               ============================
echo.
echo                                                                      version 2 Alpha
echo                                                               ============================
echo.
echo                                                                      by iamareebjamal   
echo                                                                      @ XDA Developers
echo  ------------------------------------------------------------------------------------------------------------------------------------------------------------
echo  ------------------------------------------------------------------------------------------------------------------------------------------------------------
echo.
echo.
echo Note:- In this early release, you must be careful not to overlap smali files. For that :-
echo 1. Keep only one classes.dex file in input folder and don't rename it
echo 2. Keep output folder empty for the coming compiled classes.dex or the file there will be deleted
echo 3. After editing smali files, just delete the classout folder from decompiled folder to avoid overlapping of smali files or classout folder will be deleted
echo.
echo.
echo  -----------------------------------------------------------------------------------------------------------------------------------------------------------
echo  -----------------------------------------------------------------------------------------------------------------------------------------------------------
echo   =================                   =================             =================                                   
echo     Main Options                       Reboot Options                 Miscellaneous                         
echo   =================                   =================             =================                               
echo.
echo 1. Decompile classes.dex              3. Reboot                     6. logcat
echo 2. Recompile classes.dex              4. Recovery                   7. Fix Permissions
echo                                       5. Hot Reboot(Preferred)                         
echo 0. Exit
echo  -----------------------------------------------------------------------------------------------------------------------------------------------------------
echo  -----------------------------------------------------------------------------------------------------------------------------------------------------------
SET /P option=Choose any option:
IF %option%==1 (goto dec)
IF %option%==2 (goto rec)
IF %option%==0 (goto exit)
IF %option%==3 (goto reboot)
IF %option%==4 (goto recovery)
IF %option%==5 (goto hot)
IF %option%==6 (goto log)
IF %option%==7 (goto fix)
:WHAT
echo Please Choose correct option from one of these
PAUSE
goto MENU
:dec
IF EXIST "decompiled/classout" (rmdir /S /Q "decompiled/classout")
IF NOT EXIST "input/classes.dex" GOTO notclass
java -jar tools/baksmali.jar -o decompiled/classout/ input/classes.dex
ECHO DONE
PAUSE
GOTO MENU
:rec
IF EXIST "output/classes.dex" (DEL /Q "output\classes.dex")
IF EXIST "output/classes.dex" (rmdir /S /Q "output/classes.dex")
IF NOT EXIST "decompiled/classout" GOTO notout
java -Xmx512M -jar tools/smali.jar -o output/classes.dex decompiled/classout/
ECHO Done
PAUSE
GOTO MENU
:reboot
tools\adb.exe wait-for-device
tools\adb.exe reboot
ECHO Done
PAUSE
GOTO MENU
:recovery
tools\adb.exe wait-for-device
tools\adb.exe reboot recovery
ECHO Done
PAUSE
GOTO MENU
:hot
tools\adb.exe wait-for-device
tools\adb.exe shell killall system_server
ECHO Done
PAUSE
GOTO MENU
:log
ECHO 1. Display logcat
ECHO 2. Save logcat
SET /P logcat=Choose any option:
IF %logcat%==1 (goto show)
IF %logcat%==2 (goto save)
:show
ECHO Press Enter to start viewing logcat
ECHO Press Ctrl+C and type Y to end logcat
PAUSE
tools\adb.exe logcat -v long
GOTO MENU
:save
ECHO Press Enter to start recording logcat
ECHO Press Ctrl+C and type Y to end recording process
PAUSE
tools\adb.exe logcat -v long > logcat%random%.txt
GOTO MENU
:fix
ECHO Fixing permissions of system/app, framework and etc/init.d. Please Wait...
tools\adb.exe wait-for-device
tools\adb.exe remount
tools\adb.exe shell chmod 644 /system/app/*
tools\adb.exe shell chmod 644 /system/framework/*
tools\adb.exe shell chmod 777 /system/etc/init.d
tools\adb.exe shell chmod 777 /system/etc/init.d/*
ECHO Done
PAUSE
GOTO MENU
:notclass
ECHO classes.dex not present in input folder
ECHO Please place it there
PAUSE
GOTO MENU
:notout
ECHO classes.dex not decompiled
ECHO First decompile it and then recompile
PAUSE
GOTO MENU
:exit
exit