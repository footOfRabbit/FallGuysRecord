# 简述

主要借鉴：https://github.com/shinq/FallGuysRecord

在此基础上添加小窗模式
小窗的样式借鉴：https://github.com/mzj21/FallGuysRecord

## 目前已新增

1. 已汉化该项目
2. 小窗模式
3. 小窗模式下能够调整字体大小颜色，字体样式，可以传入并使用网络自定义样式
4. 自定义小窗大小

## 后期计划

1. 主要是给`MMA自由格斗健身教练马哥🐎`的定制
在小窗里加个刷视屏的浏览器内核，但是会影响性能，暂时无从下手

2. 对于新增的自定义关卡进排位淘汰赛时的名称显示进行优化

---
## 使用说明
1. 运行方式，双击run.bat
2. 修改src/FallGuysRecord.java后重新封装jar包，双击build.bat
3. 将项目封装成exe文件(无需java环境即可运行)，双击package_exe.bat
    - 目前项目中少一个ico文件，要打包exe文件自己搞一个icon
    - 当然也可以不要ico文件，到package_exe.bat里修改一下，把jpackage下面 --icon那行删了

