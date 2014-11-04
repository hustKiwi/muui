# 安装
安装package.json 中声明的全部依赖
```shell
npm install
```
之后通过执`cake`可以查看所有可供运行的`task`。

# 开发
[nobone](https://github.com/ysmood/nobone) 为MuUI提供了基础的开发预览环境，
在server启动的状态下，会根据配置去render对应的`jade`, `stylus`和`coffee`等源码，
并自动刷新浏览器。启动开发调试环境，需执行：
```shell
cake [-p port] dev
```
会在指定端口启动开发server（默认端口：8077）。之后访问：http://127.0.0.1:8077/ 可以查看MuUI的组件列表。

另外如果要测试编译后的代码，可以键入`-s`指定static目录。比如指定编译后的`dist`为static目录，则运行：
```shell
cake -s ./dist dev
```

# 编译

```shell
cake build
```
上述命令会将`public`下的对应的源码编译到`dist`目录。