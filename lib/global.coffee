_path = require 'path'
_pathJudge = require 'path-judge'
_fs = require 'fs'
#slow-cli的相关文件夹文件名的设置
pkg =  _path.resolve __dirname, '../package.json'
version = require(pkg).version

$identity = ".slow"
$identityFile = "config"

$identityFilePath = _path.join $identity, $identityFile

#默认配置的位置
$defaultConfigFilePath = _path.resolve __dirname, "../sample", $identityFilePath
$defaultConfigDirectoryPath = _path.resolve __dirname, "../sample", $identity
#默认demo的文件夹位置
$defaultDemoDirectory = _path.resolve __dirname, "../sample"
#默认运行时文件夹 为 进程目录
$defaultRuntimeDirectory = process.cwd()
#默认运行时的配置文件位置
$defaultRuntimeConfigureFilePath = false

#初始化 运行demo所需的配置文件
initSampleGlobalConfig = (program, setting)->

  runtimeConfigureFilePath = $defaultConfigFilePath
  runtimeDirectory = $defaultDemoDirectory

  config = require runtimeConfigureFilePath
  console.log "Sample is running".green
  env = config.environment
  #读取相应环境配置
  configEnv = config[env]

  global.SLOW =
    version: config.version #工程版本
    _config_: config #全局配置
  #下面是slow start需要的相关配置
    _env_: config[env] #工作环境配置
    port: program.port or configEnv.port #运行的端口配置
    cwd: runtimeDirectory #slow 当前工作目录
    base: configEnv.base
    proxy: configEnv.proxy #代理配置
    env: env #当前工作环境
    log: configEnv.log #日志配置
    version: version #当前版本
    isProduct: -> false

#初始化运行时需要的全局变量
initRuntimeGlobalConfig = (program, setting)->
  #读取工作目录
  runtimeDirectory = setting.runtimeDirectory
  #获取实际运行时文件配置路径
  runtimeConfigureFilePath = setting.runtimeConfigureFilePath

  #如果配置文件不存在，那么则表示运行的是 demo
  if not (_fs.existsSync("#{runtimeConfigureFilePath}.js") or _fs.existsSync("#{runtimeConfigureFilePath}.coffee"))
    #获取demo的文件夹
    runtimeDirectory = $defaultDemoDirectory
    #获取demo的配置文件
    runtimeConfigureFilePath = $defaultConfigFilePath

    console.log "you have not init slow, " +
      "please run 'slow init' in the project directory \n" +
      "or set the project directory by 'slow -w path/to/project' \n" +
      "more information run 'slow -h'".yellow

  console.log "Now, project run with #{setting.runtimeConfigureFilePath}.(js|coffee)"

  console.log "slow run in #{runtimeDirectory}".blue

  config = require runtimeConfigureFilePath

  #开发模式 or 生产模式?
  env = program.env or config.environment
  #读取相应环境配置
  configEnv = config[env]

  global.SLOW =
    version: config.version #工程版本
    _config_: config #全局配置
    #下面是slow start需要的相关配置
    _env_: config[env] #工作环境配置
    port: program.port or configEnv.port #运行的端口配置
    cwd: runtimeDirectory #slow 当前工作目录
    base: configEnv.base
    proxy: configEnv.proxy #代理配置
    env: env #当前工作环境
    log: configEnv.log #日志配置
    version: version #当前版本
    plugins: configEnv.plugins or {}
    isProduct: -> env is 'product'

#初始化 初始化项目需要的全局变量
initInitGlobalConfig = (program, setting)->
  #读取工作目录
  runtimeDirectory = setting.runtimeDirectory
  global.SLOW =
    #初始化时，配置文件应该存放的文件路径
    $currentDefaultConfigFilePath: _path.join runtimeDirectory, $identityFilePath
    $currentDefaultConfigDirectoryPath: _path.join runtimeDirectory, $identity
    $defaultConfigDirectoryPath: $defaultConfigDirectoryPath #默认配置文件存储的文件夹

#初始化 编译项目需要的全局变量
initBuildGlobalConfig = (program, setting)->
  #1.获取需要编译的文件夹
  #2.获取编译配置
  #3.获取编输出文件夹
  #4.设置全局变量
  console.log
  #1.获取需要编译的文件夹
  if program.source
    compileDir =  _pathJudge.getFilePathBaseOnProcess(program.source)
  else
    compileDir = setting.runtimeDirectory
  #2.获取编译配置
  #是否已经指定编译配置文件
  if program.buildConfigure
    buildConfigureFile = _pathJudge.getFilePathBaseOnProcess buildConfigure
  #是否指定了项目配置文件，如果制定，则从中读取相关配置
  else if program.configure
    buildConfigureFile = _pathJudge.getFilePathBaseOnProcess program.configure
  #是否工作目录下已经包好了配置文件
  else
    buildConfigureFile = setting.runtimeConfigureFilePath

  configure = require(buildConfigureFile)
  buildConfigure = configure.build or configure

  #获取编输出文件夹
  if program.output
    buildConfigure.target = _pathJudge.getFilePathBaseOnProcess(program.output)
  else
    buildConfigure.target = _pathJudge.getFilePathBaseOnProcess(buildConfigure.target)


  console.log "Now compile config is #{buildConfigureFile}"
  console.log "Now compile project in #{compileDir}"


  global.SLOW =
    _config_: configure
    version: buildConfigure.version
    cwd: compileDir
    build: buildConfigure
    plugins: buildConfigure.plugins
    isProduct: -> true

###
# slow start, slow build 读取配置文件的顺序是：
# 1.指定了配置文件，则使用指定文件 不存在则进行下一步
# 2.读取进程目录下.slow/config.js文件 不存在则进行下一步
# 3. 读取slow默认的配置程序
###
#全局变量
module.exports = (program)->
  #运行时配置文件路径
  runtimeConfigureFilePath = false
  #运行时目录
  runtimeDirectory = false
  #是否指定运行时目录
  if program.workspace
    runtimeDirectory = _pathJudge.getFilePathBaseOnProcess(program.workspace)

  #读取配置文件顺序, step 1
  #如果指定运行时配置文件
  if program.configure
    runtimeConfigureFilePath = _pathJudge.getFilePathBaseOnProcess(program.configure)

  #读取工作目录 如果指定了项目目录，则使用指定目录，如果没有指定则使用主进程目录
  runtimeDirectory = runtimeDirectory or $defaultRuntimeDirectory
  #读取配置文件顺序, step 2
  #设置默认运行时配置文件路径
  $defaultRuntimeConfigureFilePath = _path.join runtimeDirectory, $identityFilePath
  #读取配置文件顺序, step 3
  #不需要init也能执行 如果执行执行目录下的配置文件不存在则读取默认配置
  if not (_fs.existsSync("#{$defaultRuntimeConfigureFilePath}.js") or _fs.existsSync("#{$defaultRuntimeConfigureFilePath}.coffee"))
    $defaultRuntimeConfigureFilePath = $defaultConfigFilePath

  #获取实际运行时文件配置路径 如果指定了配置文件，那么使用配置文件，否则使用
  runtimeConfigureFilePath = runtimeConfigureFilePath or $defaultRuntimeConfigureFilePath
  setting =
    runtimeDirectory: runtimeDirectory
    runtimeConfigureFilePath: runtimeConfigureFilePath

  if program.start
    initRuntimeGlobalConfig(program, setting)
  else if program.init
    initInitGlobalConfig(program, setting)
  else if program.build
    initBuildGlobalConfig(program, setting)
  else if program.sample
    initSampleGlobalConfig(program, setting)
  else
    console.log "Command is undefined! Please run 'slow -h' get help ".red
    process.exit 1