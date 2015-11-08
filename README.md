# secqru-standalone

[secqru-standalone](https://github.com/deemru/secqru-standalone) creates a portable version of [secqru](https://github.com/deemru/secqru) by deploying a simple stack of nginx + PHP on Windows

# Usage

- Put [secqru-standalone.bat](https://github.com/deemru/secqru-standalone/raw/master/secqru-standalone.bat) and [dlfl.exe](https://github.com/deemru/secqru-standalone/raw/master/third_party/dlfl/dlfl.exe) in your target directory
- Run [secqru-standalone.bat](https://github.com/deemru/secqru-standalone/raw/master/secqru-standalone.bat)
- Wait for success
- Open http://127.0.0.1:31337/secqru

# Requirements

[dlfl.exe](https://github.com/deemru/dlfl) is required to download files on the fly

# Notice

If you want a version which can run on Windows XP, you must run [secqru-standalone.bat](https://github.com/deemru/secqru-standalone/raw/master/secqru-standalone.bat) with "php54" parameter
