
#SLOW

[TOC]

# What is SLOW?

>SLOW is a web framework that help web developer focus on html,css,
>javascript and don't need care for server. You can develop web with LESS
>and Coffee and don't need compile them, SLOW will do them automatically.
>So you just need spend less time in work, coding slowly and thinking in coding,
>enjoy coding. Coding is not just for finish your work.

#How to install?
`slow` need be installed as global.
`sudo npm install -g slow-cli`

# Getting Start
There is a slow project sample in "slow-cli/sample".

## Init a slow project
```shell
#In the project directory, get a slow project by runing
slow init
```   
    

##Take over and starup a http server   
```shell
#In the project directory run.
slow
#And then open the browser with http://localhost:3000
```    
## Enjoy your develop!

Now, you can enjoy coding with handlebar, coffeescript, less.
don't need use grunt or gulp compile your project.

#Develop with slow
There are all configs for slow, every fields will be described in the
next section. this is develop config:(you can find it in `.slow/config.js`)

```   
{
	"environment": "develop",
	"develop": {
	  "port": 3000,
	  "base": {
	    "index": "index.html",
	    "cache-time": 60 * 60 * 24 * 7,
	    "gzip": true,
	    "isWatchFile": true,
	    "showResponseTime": true
	  },
	  "proxy": {
	    "path": /^\/api/,
	    "options": {
	    "target": "http://localhost:8000"
	  }
	  },
	  "error": {
	    "403": ''
	  },
	  "log": {
	    "log2console": true,
	    "timestamp": false,
	    "levelShow": true,
	    "lineInfo": false,
	    "log2file": false
	  }
}
```
This is product config, you can find it in `.slow/product-config.js`
it's same with develop config.
```
{
  "port": 3000,
  "base": {
    "index": "index.html",
    "cache-time": 60 * 60 * 24 * 7,
    "gzip": true,
    "isWatchFile": true,
    "showResponseTime": false
  },
  "proxy": false,
  "error": {
    "403": ''
  }
}
```
This is build config. it be used when you run `slow build`
you can modify in .slow/build.js
```
 {
   "target": "build",
   "mincss": {
     "include": /.+\.(less|css)$/,
     "ignore": [/.+(\.min\.css)$/],
     "options": {}
   },
   "minjs": {
     "include": /.+\.(js|coffee)$/,
     "ignore": [/.+(\.min\.js)$/],
     "options": {
       "mangle": false,
       "compress": {}
     }
   },
   "hbsCompile": {
     "include": /.+(\.hbs)$/
   },
   "coffeeCompile": /.+(.coffee)$/,
   "lessCompile": /.+(.less)$/,
   "ignore": [/^(\.slow).+/, /.*(\.gitignore)$/]
 }
```
## Set work environment

When we are developing a web project, we are in develop environment,
so, at the first, you can setting slow work environment to be "develop"
like this:
```js
 module.export =
 {
   "environment": "develop",
   //...
 }
```     
There just are two values for `environment` option, `develop` and `product`.
the default setting is "develop". the environment option tell `slow` which
config should be load when it is working.

## Config develop environment
After set the work environment be `develop`, Now we can config the develop environment.
There already has some default config option at ".slow/config.js". You define
them by yourself in "develop" field.

### port
the port that be `slow`used.default is `3000`.
### base
#### index
#### cache-time
#### gzip
#### isWatchFile
#### showResponseTime
### proxy
#### path
#### options
### error
### log
## Config product enviroment
## Config build enviroment
###target
###mincss
####include
####ignore
####options
###minjs
###hbscompile
###cofeeCompile
###lessComplie
###ignore
#HTML derective
## include
## import
## watch_file

#Slow extensions

#Shell

##slow init
##slow build
##slow update
##slow
### slow -p [port]
### slow -env [develop | product]

# Feature

1. support less
2. support coffee-script
3. support handlebar
- support import directive
- support include directive
4. support http-proxy
5. support file watch
6. support gzip

# LICENCE

  MIT

# History

v0.1.8-beta1

1. add shell ```slow build``` package slow project to a pure html project.
not need depend ```slow```

>slow build support:
>1. autocompile coffee, less, handlebar
>2. compress js, css to min file



v0.1.7

1. fix a bug that slow-cli crash when proxy config don't exists
2. add log config in config.js. more config see [log4slow](github.com/huyinghuan/log4slow)
3. add build project optional.(doing. it will publish in v0.1.8)

v0.1.6

1. fix a bug about issue #1

v0.1.4

1. exchange ```import``` and ```include``` function

v0.1.3

1. fix some bugs.

v0.1.1

1. update README.md and fix bug can not install 

v0.1.0

1. finish basic function