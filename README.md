# secqru-standalone

[secqru-standalone](https://github.com/deemru/secqru-standalone) creates a portable version of [secqru](https://github.com/deemru/secqru) by deploying a simple stack of nginx + PHP on Windows

# Deployment case 1

- Put [secqru-standalone.bat](https://github.com/deemru/secqru-standalone/raw/master/secqru-standalone.bat) and [dlfl.exe](https://github.com/deemru/secqru-standalone/raw/master/third_party/dlfl/dlfl.exe) in your target directory
- Run [secqru-standalone.bat](https://github.com/deemru/secqru-standalone/raw/master/secqru-standalone.bat)
- Wait `secqru-standalone.bat` to finish with success
- Run `secqru-start.bat`
- Open http://127.0.0.1:31337/secqru

# Deployment case 2
- Download a prebuilt archive from [releases](https://github.com/deemru/secqru-standalone/releases)
- Unzip
- Run `secqru-start.bat`
- Open http://127.0.0.1:31337/secqru
 
###### Visual C++ Redistributables
- php54: [VC9](https://github.com/deemru/secqru-standalone/tree/master/third_party/VC9_redist)
- php56: [VC11](https://github.com/deemru/secqru-standalone/tree/master/third_party/VC11_redist)
- php70: [VC14](https://github.com/deemru/secqru-standalone/tree/master/third_party/VC14_redist)

# Notice

If you want a version which can run on Windows XP, you must run [secqru-standalone.bat](https://github.com/deemru/secqru-standalone/raw/master/secqru-standalone.bat) with `php54` parameter or download `secqru-standalone-php54.zip` from [releases](https://github.com/deemru/secqru-standalone/releases)
