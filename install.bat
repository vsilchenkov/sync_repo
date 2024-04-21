CHCP 65001
@Echo Off

@Set OneScript=c:\Program Files\OneScript\bin

@If not Exist "%OneScript%\*.*" (
   goto OneScript32
) Else (
   goto opm_install
)

:OneScript32
@Set OneScript=c:\Program Files (x86)\OneScript\bin
@If not Exist "%OneScript%\*.*" (
   Echo Установи oscript - https://oscript.io/docs/page/install
   goto end
)

:opm_install

chdir /d %OneScript%

start cmd /C opm update --all
timeout 15

start cmd /C opm install v8runner
start cmd /C opm install cmdline
start cmd /C opm install logos
start cmd /C opm install v8rac
start cmd /C opm install configor
start cmd /C opm install messenger
start cmd /C opm install 1commands
start cmd /C opm install v8storage
start cmd /C opm install gui
start cmd /C opm install autumn
start cmd /C opm install autumn-logos
start cmd /C opm install autumn-cli
start cmd /C opm install autumn-async
start cmd /C opm install sql
   
echo Пакеты установлены

:end
pause
exit