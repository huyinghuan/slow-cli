SLOW
----------
前端开发， 构建工具。

## 安装

```shell
npm install -g slow-cli
```

##使用

在项目根目录下运行
```
slow init
```
进行初始化。 完成后会有相关配置 在.slow文件夹下生成。 可以根据自己需要配置。当然，可以使用默认配置

之后运行
```
slow
```
就可以跑起来了。 默认端口是3000.

## 配置

配置请参考 src/sample/.slow/config.coffee 配置


## Shell 命令

### slow init

初始化slow 项目根目录运行一次即可

### slow build
将整个工程 进行构建。  构建完成后，不依赖slow， 可以通过nginx配置后，直接跑起来。当然， 如果你配置过
路径代理， 那么nginx需要进行相应配置才行。


### slow

将项目 运行在http 服务内（slow 自带）， 可以通过 -p 指定端口， 通过 -dev 指定运行环境


### 指令

在hbs 文件中支持 include 和import 指令。


#### include

将其他文件包含进来。 例如
a.html
```
<div>hello world</div>
```

b.hbs
```
<body>
{{include "a.html"}}
</body>
```

编译后（在浏览器访问 localhost:xxx/xx/b.html）
得到的结果是

```
<body>
  <div>hello world</div>
</body>
```

### import

import指令主要用于引用 css 和js 文件

例如

```
<head>
{{import "css/*"}}
</head>
```
得到的结果是将文件夹css下的所有文件全部引入到head标签中。 不包括子文件夹。

这个指令支持css和js文件资源的自动引入。 包括 less 和 coffee


### proxy代理

解决跨域问题。  在前后端分离的趋势下， 前段 不依赖后台服务器  进行api访问。

如果直接访问api 会造成 跨域 限制。 通过proxy 配置，跨域解决这个问题，
支持多路径 代理。 具体参考配置文件```src/sample/.slow/config.coffee``` 的proxy相关设置。

### 其他

支持 coffee，less原生编译， 也就是如果你是通过 coffee写的文件 ，按照 .js文件的方法引用即可

如： a.coffee 在引用时 写成```<script src="xx/a.js"></script>```即可。less同理。

### 运用

芒果tv内部某些属于我的任务中使用。

### Bug 与 Suggestion

可以提issue 或者 pr

### 扩展

SLOW 支持一定程度上的扩展。比如中间件方式等。只需要在src/lib/middleware 下添加服务相关格式的函数即可自动添加到运行环境中。
比如 添加支持Sass支持。只需在该目录下添加个文件如 xxx-sass.coffee （如果你不用coffee那么，在lib/middleware下建立js文件即可）

```coffee
_async = require 'async'

isSassFile = (path)->
   if ....
      return true

   else
      return false

module.exports = (req, resp, next)->
  pathName = req.client.pathName

  if not isSassFile(pathName) #如果pathName 不是 sass文件类型 #伪代码
      return next() #当请求路径不符合你的拦截请求的话，运行next()  将请求交给下个 拦截器

  ....
  err = null
  #编译 sass文件
  try
    result = _sass.compile .....
  catch e
    err = e
  ...
  return resp.throwsServerError() if err
  resp.sendContent result, "text/css"
```

如果你使用的是coffee，那么需要目录下编译一次 (不是每个人都用coffee，编译好后，会自动生成到lib相应目录下，方便其他人使用)
```
grunt coffee
```

例外还支持一些其他的扩展方式，如果有需要，可以在issue中提出，我会回复。

## 未来

 1. 将集成我的另外一个库slow-data 进行api 数据模拟， 避免 后台开发延期导致前端 无法获取数据而造成的 任务进程停滞不前。

 2. 完成具体的插件机制， 增加更多可选插件。 比如文件合成等等