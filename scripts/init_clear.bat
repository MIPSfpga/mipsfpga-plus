set TOP_BOARD=..\boards
set TOP_PROGRAM=..\programs

rem delete all program\*\*.sh and program\*\*.bat
for /f %%f in ('dir /A:D /B %TOP_PROGRAM%') do (
    if not %%f == program (
        del  %TOP_PROGRAM%\%%f\*.sh
        del  %TOP_PROGRAM%\%%f\*.bat
    )
)
