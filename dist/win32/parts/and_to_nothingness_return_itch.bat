@ECHO OFF

cd ..

mkdir "%appdata%\And to Nothingness Return\"
mkdir "%appdata%\And to Nothingness Return\game"

set GF=%appdata%\And to Nothingness Return\game

copy ld45_itch.rb "%GF%\"
xcopy /s /y ruby "%GF%\ruby\"
xcopy /s /y src "%GF%\src\"
xcopy /s /y media "%GF%\media\"
xcopy /s /y data "%GF%\data\"

cd "%GF%"

ruby\bin\ruby.exe ld45_itch.rb

cd ..

del /Q game