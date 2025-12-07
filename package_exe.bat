@echo off
setlocal
chcp 65001 >nul
echo ==========================================
echo       FallGuysRecord 一键打包工具
echo       (基于 jpackage - JDK 14+)
echo ==========================================

REM --- 0. 环境检查 ---
where jpackage >nul 2>nul
if %errorlevel% neq 0 (
    echo [错误] 未找到 'jpackage' 命令。
    echo 请确保你安装了 JDK 14 或更高版本，并将 bin 目录添加到了系统 PATH 环境变量中。
    pause
    exit /b 1
)

REM --- 1. 清理旧的构建文件 ---
echo [1/6] 清理旧文件...
if exist classes rd /s /q classes
if exist jpackage_input rd /s /q jpackage_input
if exist output rd /s /q output
if exist FallGuysRecord.jar del FallGuysRecord.jar

mkdir classes

REM --- 2. 编译 Java 源码 ---
echo [2/6] 正在编译源码...
REM 使用项目中的 jar 包作为依赖进行编译
javac -encoding utf-8 -source 1.8 -target 1.8 -cp commons-io-2.11.0.jar;jackson-core-2.13.3.jar;jackson-databind-2.13.3.jar;jackson-annotations-2.13.3.jar -d classes src/*.java

if %errorlevel% neq 0 (
    echo [错误] 编译失败，请检查源码错误。
    pause
    exit /b %errorlevel%
)

REM --- 3. 复制资源文件 ---
echo [3/6] 复制资源文件...
REM 将 properties 文件复制到 classes 目录，以便打入 jar 包
copy src\*.properties classes\ >nul

REM --- 4. 创建 JAR 文件 ---
echo [4/6] 打包 JAR 文件...
jar -cmf manifest.mf FallGuysRecord.jar -C classes .

REM --- 5. 准备 jpackage 输入目录 ---
echo [5/6] 准备打包素材...
mkdir jpackage_input
REM 将主程序和所有依赖库放入同一个文件夹
copy FallGuysRecord.jar jpackage_input\ >nul
copy commons-io-2.11.0.jar jpackage_input\ >nul
copy jackson-core-2.13.3.jar jpackage_input\ >nul
copy jackson-databind-2.13.3.jar jpackage_input\ >nul
copy jackson-annotations-2.13.3.jar jpackage_input\ >nul

REM --- 6. 生成 EXE (App Image) ---
echo [6/6] 正在生成 EXE (这可能需要几秒钟)...

REM 参数说明：
REM --type app-image: 生成绿色版文件夹（无需安装）
REM --dest output: 输出目录
REM --input jpackage_input: 包含 jar 的源目录
REM --java-options: 强制指定 UTF-8 编码，防止中文乱码

jpackage ^
  --type app-image ^
  --dest output ^
  --input jpackage_input ^
  --name FallGuysRecord ^
  --main-jar FallGuysRecord.jar ^
  --main-class FallGuysRecord ^
  --icon icon.ico ^
  --java-options "-Dfile.encoding=UTF-8"

if %errorlevel% neq 0 (
    echo [错误] jpackage 打包失败！
    pause
    exit /b %errorlevel%
)

REM --- 7. (可选) 复制当前的配置文件到输出目录 ---
echo 正在迁移配置文件到输出目录...
if exist settings.ini copy settings.ini output\FallGuysRecord\ >nul
if exist creatives.tsv copy creatives.tsv output\FallGuysRecord\ >nul
if exist stats.tsv copy stats.tsv output\FallGuysRecord\ >nul
if exist mini_config.dat copy mini_config.dat output\FallGuysRecord\ >nul

echo.
echo ==========================================
echo           打包成功！ (SUCCESS)
echo ==========================================
echo.
echo 可执行文件位置:
echo    %~dp0output\FallGuysRecord\FallGuysRecord.exe
echo.
echo 你可以将 output\FallGuysRecord 文件夹压缩发给朋友。
echo.
pause