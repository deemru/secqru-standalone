@echo off
set error=

set nginx_port=31337
set php_port=31338
set php_threads=4

set prolog=secqru

set nginx_ver=nginx-1.10.2
set php71_ver=php-7.1.0
set php70_ver=php-7.0.14
set php56_ver=php-5.6.29
set php54_ver=php-5.4.45

set dlfl=third_party\dlfl\dlfl.exe
if not exist %dlfl% set dlfl=support\dlfl.exe
if not exist %dlfl% set dlfl=dlfl.exe
if not exist %dlfl% (
    set error=ERROR: dlfl.exe is required
    goto :error
)

set nginx_src=http://nginx.org/download/%nginx_ver%.zip
set php71_src=http://windows.php.net/downloads/releases/%php71_ver%-nts-Win32-VC14-x86.zip
set php70_src=http://windows.php.net/downloads/releases/%php70_ver%-nts-Win32-VC14-x86.zip
set php56_src=http://windows.php.net/downloads/releases/%php56_ver%-nts-Win32-VC11-x86.zip
set php54_src=http://windows.php.net/downloads/releases/%php54_ver%-nts-Win32-VC9-x86.zip
set zip_src=https://github.com/npocmaka/batch.scripts/raw/master/hybrids/jscript/zipjs.bat

set vc14_local=third_party\VC14_redist\vcredist_x86.exe
set vc14_src=https://github.com/deemru/secqru-standalone/raw/master/third_party/VC14_redist/vcredist_x86.exe
set vc11_local=third_party\VC11_redist\vcredist_x86.exe
set vc11_src=https://github.com/deemru/secqru-standalone/raw/master/third_party/VC11_redist/vcredist_x86.exe
set vc9_local=third_party\VC9_redist\vcredist_x86.exe
set vc9_src=https://github.com/deemru/secqru-standalone/raw/master/third_party/VC9_redist/vcredist_x86.exe

set ngxcfg_local=temp\createfile.nginx.conf.bat
set ngxcfg_src=https://github.com/deemru/secqru-standalone/raw/master/support/createfile.nginx.conf.bat

set is_php_default=1

if not "%1"=="" if "%1"=="php54" (
    set is_php_default=0
    set php_ver=%php54_ver%
    set php_src=%php54_src%
    set vc_local=%vc9_local%
    set vc_src=%vc9_src%
    set vc_check=
)

if not "%1"=="" if "%1"=="php56" (
    set is_php_default=0
    set php_ver=%php56_ver%
    set php_src=%php56_src%
    set vc_local=%vc11_local%
    set vc_src=%vc11_src%
    set vc_check=msvcr110.dll
)

if not "%1"=="" if "%1"=="php70" (
    set is_php_default=0
    set php_ver=%php70_ver%
    set php_src=%php70_src%
    set vc_local=%vc14_local%
    set vc_src=%vc14_src%
    set vc_check=vcruntime140.dll
)

if not "%1"=="" if "%1"=="php71" (
    set is_php_default=0
    set php_ver=%php71_ver%
    set php_src=%php71_src%
    set vc_local=%vc14_local%
    set vc_src=%vc14_src%
    set vc_check=vcruntime140.dll
)

if %is_php_default%==1 (
    set php_ver=%php56_ver%
    set php_src=%php56_src%
    set vc_local=%vc11_local%
    set vc_src=%vc11_src%
    set vc_check=msvcr110.dll
)

if not exist nginx/%prolog%-nginx.exe (
    set echostep=Installing %nginx_ver%
    call :echostep
    if not exist temp mkdir temp || goto :error
    if not exist temp\zipjs.bat %dlfl% %zip_src% temp\zipjs.bat || goto :error
    if not exist temp\%nginx_ver%.zip %dlfl% %nginx_src% temp\%nginx_ver%.zip || goto :error
    mkdir temp\nginx || goto :error
    call temp\zipjs.bat unzip -source %CD%\temp\%nginx_ver%.zip -destination %CD%\temp\nginx
    if not exist temp\nginx\%nginx_ver% (
        set error=ERROR: zipjs.bat failed
        goto :error
    )
    move temp\nginx\%nginx_ver% nginx || goto :error
    move nginx\nginx.exe nginx\%prolog%-nginx.exe || goto :error
    rmdir temp\nginx || goto :error
)

if not exist php/%prolog%-php-cgi.exe (
    set echostep=Installing %php_ver%
    call :echostep
    if not exist temp mkdir temp || goto :error
    if not exist temp\zipjs.bat %dlfl% %zip_src% temp\zipjs.bat || goto :error
    if not exist temp\%php_ver%.zip %dlfl% %php_src% temp\%php_ver%.zip || goto :error
    mkdir temp\php || goto :error
    call temp\zipjs.bat unzip -source %CD%\temp\%php_ver%.zip -destination %CD%\temp\php
    if not exist temp\php (
        set error=ERROR: zipjs.bat failed
        goto :error
    )
    move temp\php php || goto :error
    copy php\php-cgi.exe php\%prolog%-php-cgi.exe || goto :error
    (echo memory_limit = 512M) > %prolog%-php.conf
    (echo post_max_size = 32M) >> %prolog%-php.conf
    (echo upload_max_filesize = 32M) >> %prolog%-php.conf
    (echo extension_dir = .) >> %prolog%-php.conf
    (echo extension = ext\php_mbstring.dll) >> %prolog%-php.conf
    (echo extension = ext\php_gd2.dll) >> %prolog%-php.conf
    (echo extension = ext\php_curl.dll) >> %prolog%-php.conf
    (echo zend_extension = ext\php_opcache.dll) >> %prolog%-php.conf
    (echo user_ini.filename = "") >> %prolog%-php.conf

    if not "%vc_check%"=="" if exist %windir%\SysWOW64 (
        if not exist %windir%\SysWOW64\%vc_check% call :redist
    ) else (
        if not exist %windir%\System32\%vc_check% call :redist
    )
)

if not exist nginx/html/secqru (
    set echostep=Installing github\deemru\secqru
    call :echostep
    if not exist temp mkdir temp || goto :error
    if not exist temp\zipjs.bat %dlfl% %zip_src% temp\zipjs.bat || goto :error
    if not exist temp\secqru.zip %dlfl% https://github.com/deemru/secqru/archive/master.zip temp\secqru.zip || goto :error
    mkdir temp\secqru || goto :error
    call temp\zipjs.bat unzip -source %CD%\temp\secqru.zip -destination %CD%\temp\secqru
    if not exist temp\secqru (
        set error=ERROR: zipjs.bat failed
        goto :error
    )
    move temp\secqru\secqru-master nginx/html/secqru || goto :error
    rmdir temp\secqru || goto :error
    copy nginx\html\secqru\secqru.config.sample.php nginx\html\secqru\secqru.config.php || goto :error
    ( echo ^<?php phpinfo^(^)^; ?^>) > nginx\html\index.php

    if not exist %ngxcfg_local% %dlfl% %ngxcfg_src% %ngxcfg_local% || goto :error
    call %ngxcfg_local% %nginx_port% %php_port% %prolog%-nginx.conf
)

if not exist support\%prolog%-php-cgi-spawner.exe (
    set echostep=Installing php-cgi-spawner
    call :echostep
    if not exist support mkdir support || goto :error
    %dlfl% https://github.com/deemru/php-cgi-spawner/releases/download/1.0.20/php-cgi-spawner.exe support\%prolog%-php-cgi-spawner.exe || goto :error
)

if not exist %prolog%-start.bat (
    ( echo set PHP_FCGI_MAX_REQUESTS=0) > %prolog%-start.bat
    ( echo tasklist /fi "imagename eq %prolog%-*" 2^>nul ^| find /i /n "%prolog%-"^>nul ^&^& call %prolog%-stop.bat) >> %prolog%-start.bat
    ( echo start support\%prolog%-php-cgi-spawner "php\%prolog%-php-cgi -c %prolog%-php.conf" %php_port% %php_threads%) >> %prolog%-start.bat
    ( echo cd nginx) >> %prolog%-start.bat
    ( echo start %prolog%-nginx.exe -c ..\%prolog%-nginx.conf) >> %prolog%-start.bat
    ( echo cd ..) >> %prolog%-start.bat
)

if not exist %prolog%-stop.bat (
    ( echo taskkill /F /IM %prolog%-php-cgi-spawner.exe) > %prolog%-stop.bat
    ( echo taskkill /F /IM %prolog%-php-cgi.exe) >> %prolog%-stop.bat
    ( echo taskkill /F /IM %prolog%-nginx.exe) >> %prolog%-stop.bat
)

set echostep=SUCCESS: run "%prolog%-start.bat", open "http://127.0.0.1:%nginx_port%/secqru"
call :echostep
if not "%nopause%"=="1" (
    pause
) else if "%makezip%"=="1" (
    set echostep=Making %prolog%-standalone.zip
    call :echostep
    if exist %prolog%-standalone.zip del %prolog%-standalone.zip
    if exist %prolog%-standalone rmdir %prolog%-standalone /s /q
    mkdir %prolog%-standalone || goto :error
    mkdir %prolog%-standalone\support || goto :error
    xcopy nginx %prolog%-standalone\nginx\ /s/e/h || goto :error
    xcopy php %prolog%-standalone\php\ /s/e/h || goto :error
    copy support\%prolog%-php-cgi-spawner.exe %prolog%-standalone\support\%prolog%-php-cgi-spawner.exe || goto :error
    copy %prolog%-nginx.conf %prolog%-standalone\%prolog%-nginx.conf || goto :error
    copy %prolog%-php.conf %prolog%-standalone\%prolog%-php.conf || goto :error
    copy %prolog%-start.bat %prolog%-standalone\%prolog%-start.bat || goto :error
    copy %prolog%-stop.bat %prolog%-standalone\%prolog%-stop.bat || goto :error
    call temp\zipjs.bat zipDirItems -source %prolog%-standalone -destination %prolog%-standalone.zip
    rmdir %prolog%-standalone /s /q
    if not exist %prolog%-standalone.zip (
        set error=ERROR: zipjs.bat failed
        goto :error
    )
)
goto :eof

:error
echo %error%
if not "%nopause%"=="1" (
    pause
)
exit /b

:redist
set echostep=Installing Visual C++ Redistributable
call :echostep
if not exist %vc_local% (
    if not exist temp\vcredist_x86.exe %dlfl% %vc_src% temp\vcredist_x86.exe || goto :error
    temp\vcredist_x86.exe /q
) else (
    %vc_local% /q
)
goto :eof

:echostep
echo ..................................................................
echo %echostep%
echo ..................................................................
goto :eof
