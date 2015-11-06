@echo off

set nginx_port=31337
set php_port=31338
set php_threads=4

set prolog=secqru

set nginx_ver=nginx-1.8.0
set php56_ver=php-5.6.15
set php54_ver=php-5.4.45

set dlfl=third_party\dlfl\dlfl.exe
if not exist %dlfl% set dlfl=support\dlfl.exe
if not exist %dlfl% set dlfl=dlfl.exe
if not exist %dlfl% (
    echo ERROR: dlfl.exe required
    exit /b
)

set nginx_src=http://nginx.org/download/%nginx_ver%.zip
set php56_src=http://windows.php.net/downloads/releases/%php56_ver%-nts-Win32-VC11-x86.zip
set php54_src=http://windows.php.net/downloads/releases/%php54_ver%-nts-Win32-VC9-x86.zip
set zip_src=https://github.com/npocmaka/batch.scripts/raw/master/hybrids/jscript/zipjs.bat

set vc11_local=third_party\VC11_redist\vcredist_x86.exe
set vc11_src=https://github.com/deemru/secqru-standalone/raw/master/third_party/VC11_redist/vcredist_x86.exe
set vc9_local=third_party\VC9_redist\vcredist_x86.exe
set vc9_src=https://github.com/deemru/secqru-standalone/raw/master/third_party/VC9_redist/vcredist_x86.exe

set ngxcfg_local=support\createfile.nginx.conf.bat
set ngxcfg_src=https://github.com/deemru/secqru-standalone/raw/master/support/createfile.nginx.conf.bat

set is_php_default=1

if not "%1"=="" if "%1"=="php54" (
    set is_php_default=0
    set php_ver=%php54_ver%
    set php_src=%php54_src%
    set vc_local=%vc9_local%
    set vc_src=%vc9_src%
)

if %is_php_default%==1 (
    set php_ver=%php56_ver%
    set php_src=%php56_src%
    set vc_local=%vc11_local%
    set vc_src=%vc11_src%
)

if not exist support mkdir support

if not exist nginx/%prolog%-nginx.exe (
    if not exist temp mkdir temp
    if not exist temp\zipjs.bat %dlfl% %zip_src% temp\zipjs.bat
    if not exist temp\%nginx_ver%.zip %dlfl% %nginx_src% temp\%nginx_ver%.zip
    mkdir temp\nginx
    call temp\zipjs.bat unzip -source %CD%\temp\%nginx_ver%.zip -destination %CD%\temp\nginx
    move temp\nginx\%nginx_ver% nginx
    move nginx\nginx.exe nginx\%prolog%-nginx.exe
    rmdir temp\nginx
)

if not exist php/%prolog%-php-cgi.exe (
    if not exist temp mkdir temp
    if not exist temp\zipjs.bat %dlfl% %zip_src% temp\zipjs.bat
    if not exist temp\%php_ver%.zip %dlfl% %php_src% temp\%php_ver%.zip
    mkdir temp\php
    call temp\zipjs.bat unzip -source %CD%\temp\%php_ver%.zip -destination %CD%\temp\php
    move temp\php php
    copy php\php-cgi.exe php\%prolog%-php-cgi.exe
    (echo [PHP]) > php\php.ini
    (echo extension=ext\php_mbstring.dll) >> php\php.ini

    if not exist %vc_local% (
        if not exist temp\vcredist_x86.exe %dlfl% %vc_src% temp\vcredist_x86.exe
        temp\vcredist_x86.exe /q
    ) else (
        %vc_local% /q
    )
)

if not exist nginx/html/secqru (
    if not exist temp mkdir temp
    if not exist temp\zipjs.bat %dlfl% %zip_src% temp\zipjs.bat
    if not exist temp\secqru.zip %dlfl% https://github.com/deemru/secqru/archive/master.zip temp\secqru.zip
    mkdir temp\secqru
    call temp\zipjs.bat unzip -source %CD%\temp\secqru.zip -destination %CD%\temp\secqru
    move temp\secqru\secqru-master nginx/html/secqru
    rmdir temp\secqru
    copy nginx\html\secqru\secqru.config.sample.php nginx\html\secqru\secqru.config.php
)

if not exist support\%prolog%-php-cgi-spawner.exe %dlfl% https://github.com/deemru/php-cgi-spawner/releases/download/1.0.1/php-cgi-spawner.exe support\%prolog%-php-cgi-spawner.exe

if exist temp if exist nginx if exist php if exist nginx/html/secqru if exist php/%prolog%-php-cgi.exe if exist nginx/%prolog%-nginx.exe if exist support\%prolog%-php-cgi-spawner.exe (
    rmdir temp /s /q
)

if not exist %ngxcfg_local% %dlfl% %ngxcfg_src% %ngxcfg_local%
call %ngxcfg_local% %nginx_port% %php_port% nginx\conf\nginx.conf

( echo call %prolog%-stop.bat) > %prolog%-start.bat
( echo start support\%prolog%-php-cgi-spawner php\%prolog%-php-cgi %php_port% %php_threads%) >> %prolog%-start.bat
( echo cd nginx) >> %prolog%-start.bat
( echo start %prolog%-nginx.exe) >> %prolog%-start.bat
( echo cd ..) >> %prolog%-start.bat

( echo taskkill /F /IM %prolog%-php-cgi-spawner.exe) > %prolog%-stop.bat
( echo taskkill /F /IM %prolog%-php-cgi.exe) >> %prolog%-stop.bat
( echo taskkill /F /IM %prolog%-nginx.exe) >> %prolog%-stop.bat