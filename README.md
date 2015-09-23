SLOW
----------
前端开发， 构建工具。

## 安装

```shell
npm install -g slow-cli coffee-script
```

##使用

在项目根目录下运行
```
slow init
```
进行初始化。 完成后会有相关配置 在.slow文件夹下生成。
(当然也可以不进行初始化，这时使用默认配置运行）

之后运行
```
slow start
```
就可以跑起来了。 默认端口是3000.

## 配置

配置请参考 src/sample/.slow/config.coffee 配置


## Shell 命令

### slow init

仅当你需要对该工程进行特殊配置时，才需要初始化。初始化slow 项目根目录运行一次即可

### slow build
将整个工程 进行构建。  构建完成后，不依赖slow， 可以通过nginx配置后，直接跑起来。当然， 如果你配置过
路径代理， 那么nginx需要进行相应配置才行。
可选参数：
```
('-s, --source [value]', '构建项目时，指定 项目的文件夹路径')
('-o, --output [value]', '制定项目构建后的输出路径')
('-c, --configure [value]', '使用指定的slow 配置文件运行项目')
('-b, --buildConfigure [value]', '使用指定的配置文件进行项目构建') 和-c功能一致, -b优先读取
('-w, --workspace [value]', '指定运行时目录') 在build时候，功能和-s一致， 优先读取-s
```

### slow start

将项目 运行在http 服务内（slow 自带）
可选配置为： 

```
  ('-p, --port <n>', '指定运行端口') 默认为3000
  ('-e, --env [value]', '指定运行时环境')#废弃
  ('-c, --configure [value]', '使用指定的slow 配置文件运行项目')
  ('-b, --buildConfigure [value]', '使用指定的配置文件进行项目构建')
  ('-w, --workspace [value]', '指定运行时目录')
```

### slow sample

运行demo. 可选配置为： 

```
('-p, --port <n>', '指定运行端口')
```

### 指令

仅在```.hbs``` 文件中支持 include 和import 指令。 html文件不支持。 这点主要是考虑到某些前端mvc框架如angularjs
有自己的模板引擎，其中的引用符号会有冲突，导致无法正确解析文件。


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

#### import

import指令主要用于引用 css 和js 文件

例如

```
<head>
{{import "css/*"}}
</head>
```
得到的结果是将文件夹css下的所有文件全部引入到head标签中。 不包括子文件夹。

这个指令支持css和js文件资源的自动引入。 包括 less, coffee, cjsx和jsx

#### watch_file

watch_file 指令使用来 监测 文件变化 从而自动刷新浏览器的。也就是 livereload功能。

在你需要的自动刷新的页面加上 指令 {{watch_file}} 即可。

> Note： 该指令在slow build 会自动忽略不会引用到正式文件里面去。

### proxy代理

解决跨域问题。  在前后端分离的趋势下， 前段 不依赖后台服务器  进行api访问。

如果直接访问api 会造成 跨域 限制。 通过proxy 配置，跨域解决这个问题，
支持多路径 代理。 具体参考配置文件```src/sample/.slow/config.coffee``` 的proxy相关设置。

### 其他

支持 coffee，less原生编译， 也就是如果你是通过 coffee写的文件 ，按照 .js文件的方法引用即可

如： a.coffee 在引用时 写成```<script src="xx/a.js"></script>```即可。less同理。

### 自己扩展slow-cli

#### 假如你不会coffee:
clone到项目本地后, 进入项目目录运行
```
npm install
npm test
```
这样就编译完成slow-cli．

然后在lib目录下编写代码即可．

如何测试本版本？


在本地任何一个目录新建一个软连接到```path/to/slow-cli/bin/index```,然后把该目录设置到环境变量里面.
就可以测试使用slow-cli了．

```
cd /envirmoent/to/path/
cp -s path/to/slow-cli/bin/index slow-test
slow sample #运行demo
```
#### 假如你会coffee

clone到项目本地后, 进入项目目录运行
```
npm install
```
修改 ```/path/to/slow-cli/bin/index```
为
```
#!/usr/bin/env node
require('../src/lib/index')
```
即可．然后在src/lib下编写代码．

如何测试本版本？


在本地任何一个目录新建一个软连接到```path/to/slow-cli/bin/index```,然后把该目录设置到环境变量里面.
就可以测试使用slow-cli了．

```
cd /envirmoent/to/path/
cp -s path/to/slow-cli/bin/index slow-test
slow-test sample #运行demo
```

### Bug 与 Suggestion

可以提issue 或者 pr

### 扩展

SLOW 支持一定程度上的扩展。比如中间件方式等。只需要在lib/middleware 下添加服务相关格式的函数即可自动添加到运行环境中。
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

例外还支持一些其他的扩展方式，如果有需要，可以在issue中提出，我会回复。

## 未来

 1. 将集成我的另外一个库slow-data 进行api 数据模拟， 避免 后台开发延期导致前端 无法获取数据而造成的 任务进程停滞不前。

 2. 完成具体的插件机制， 增加更多可选插件。 比如文件合成等等


## History

v0.2.3

  Support React jsx;
  see the ```sample/index.jsx```. Demo: 
```
  slow sample
```
open the browser with 'http://localhost:3000/index.js'