# 安装
暂时使用了sass & compass去编译css，因此需要提前安装compass：
http://compass-style.org/install/

之后，安装package.json 中声明的全部依赖包
```shell
npm install
```

# 编译
编译sass样式及coffee脚本等文件：
```shell
cake build
```
默认上述命令会将编译好的css和js文件copy一份到dist目录中，同时便于开发调试，上述命令会继续watch源码的改动。开发时，watch进程会自动编译更改的源文件，直接刷新浏览器页面即可看到效果。但如果确定效果需要提交时，需要`ctrl + c`暂停调watch进程，重新运行`cake build`编译文件并生成新的dist。

# 开发调试
```shell
cake [-p port] server
```
在指定端口启动开发server（默认端口：8077）。之后访问：http://127.0.0.1:8077/tab 可以查看tab组件的demo（tab可以替换成已开发的任一组件名）。
