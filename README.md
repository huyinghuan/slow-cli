Slow
==============
A web develop framwork. http://xiacijian.com

## Install

```
npm install -g slow-cli
```

## Getting Start

In any directory, run
```
slow
```
and then open browser with http://localhost:3000

## Feature

### 1. support less

Done

### 2. support coffee-script
 
Done

### 3. support handlebar
Done.

#### 3.1 support import directive

#### 3.2 support include directive

### 4. support http-proxy

Done

### 5. support file watch

Done

### 6. support gzip

Done


## LICENCE

  MIT

## History
v0.1.8beta3

1. update command ```init```

v0.1.8-beta1

1. add shell ```slow build``` package slow project to a pure html project.
Don't need depend ```slow```

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