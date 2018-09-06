@echo off
title ffmpeg视频转换脚本

set inFilePath="%cd%\test.mp4"
set outFilePath="%cd%\Videotransed-%Date:~0,4%%Date:~5,2%%Date:~8,2%.mp4"

echo 当前目录为: %cd%
set /p inFilePath="请输入待转码视频的<完整>路径(直接回车,默认为当前目录下test.mp4):"
set /p outFilePath="请输入转码输出视频的<完整>路径(直接回车,默认为当前目录下Videotransed-年月日.mp4):"

ffmpeg 1>null 2>&1

if %ERRORLEVEL% EQU 0 (
    echo "ffmpeg已安装,开始转码"
    call:doex 1 %cd% %inFilePath% %outFilePath%
) else (
    echo "ffmpeg未安装,请在安装后重新执行脚本"
    if not exist %cd%\ffmpeg-4.0-win64-static (
    call:down_extr %cd%
    )
    call:doex 0 %cd% %inFilePath% %outFilePath%
    
)

echo.&pause&goto:eof

::--------------------------------------------------------
::-- 下面写函数
::--------------------------------------------------------

:doex                 -转码,第一个参数为0,调用系统.为1,调用当前目录下
    if %1 EQU 0 (
        title 转码中
        %cd%\ffmpeg-4.0-win64-static\bin\ffmpeg.exe -i %3 -vcodec libx264 -vprofile main -preset slow -b:v 350k -maxrate 350k -bufsize 600k -vf scale=640x480 -threads 0 -acodec libmp3lame -ab 96k %4
    ) else (
        title 转码中
        ffmpeg.exe -i %3 -vcodec libx264 -vprofile main -preset slow -b:v 350k -maxrate 350k -bufsize 600k -vf scale=640x480 -threads 0 -acodec libmp3lame -ab 96k %4
    )

    if %ERRORLEVEL% EQU 0 ( echo [31m转码后文件为: %4[0m )
goto:eof


:down_extr          -下载并解压ffmpg
    echo. 当前目录为 %~1
    if not exist %cd%\ffmpeg-4.0-win64-static.zip (
        title 从官网下载ffmpeg4.0中,请稍候...
        bitsadmin /transfer "从官网下载ffmpeg4.0中,请稍候..." /download /priority foreground "https://ffmpeg.zeranoe.com/builds/win64/static/ffmpeg-4.0-win64-static.zip" "%~1/ffmpeg-4.0-win64-static.zip"
    )
    if exist %cd%\ffmpeg-4.0-win64-static.zip (    start winrar x "%cd%\ffmpeg-4.0-win64-static.zip" * "%~1/" )

goto:eof

pause