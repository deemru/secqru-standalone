set nginx_port=%1
set php_port=%2
set output=%3
 
(echo error_log stderr;) > %output%
(echo events {}) >> %output%
(echo http {) >> %output%
(echo     server {) >> %output%
(echo         listen %nginx_port%;) >> %output%
(echo.) >> %output%
(echo         access_log off;) >> %output%
(echo         index index.php;) >> %output%
(echo.) >> %output%
(echo         location /secqru {) >> %output%
(echo             try_files $uri $uri/ /secqru/index.php;) >> %output%
(echo         }) >> %output%
(echo.) >> %output%
(echo         location /secqru/var {) >> %output%
(echo                 return 403;) >> %output%
(echo         }) >> %output%
(echo.) >> %output%
(echo         location /secqru/.git {) >> %output%
(echo                 return 403;) >> %output%
(echo         }) >> %output%
(echo.) >> %output%
(echo         location /secqru/include {) >> %output%
(echo                 return 403;) >> %output%
(echo         }) >> %output%
(echo.) >> %output%
(echo         location ~ \.php$ {) >> %output%
(echo             fastcgi_pass 127.0.0.1:%php_port%;) >> %output%
(echo             fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;) >> %output%
(echo             include fastcgi_params;) >> %output%
(echo         }) >> %output%
(echo     }) >> %output%
(echo }) >> %output%
(echo.) >> %output%
