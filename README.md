# 安装
基于nobone开发，安装package.json 中声明的全部依赖包
```shell
npm install
```

# 开发编译
自动开启服务，编译`stylus`，`coffee`，`tmpl`脚本等文件且watch监听，watch进程会自动编译更改的源文件，自动刷新浏览器页面。但如果确定效果需要提交时，需要`ctrl + c`暂停调watch进程，
```shell
cake dev
```

# 编译发布

```shell
cake build
```
上述命令会将编译好的css和js文件copy一份到dist目录中。

# 开发调试
```shell
cake [-p port] server
```
在指定端口启动开发server（默认端口：8077）。之后访问：http://127.0.0.1:8077/tab 可以查看tab组件的demo（tab可以替换成已开发的任一组件名）。
