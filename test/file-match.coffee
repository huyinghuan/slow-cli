config =  #项目打包时会读取该选项的配置
  target: "build" #打包文件存放的文件夹.支持绝对路径和相对路径(相对于运行slow的根目录)
  min: #需要进行压缩的文件 仅对于js和css
    include: /.+(\.css|\.js)$/ #需要包含的文件 #默认值 所有js和css全部进行压缩(排除已经压缩后的.)
    ignore: /.+\.min\.(css|js)$/ #已经压缩过的可以忽略, 此条规则优先于include
  hbsCompile: /.+(\.hbs)$/ #需要进行complie的文件
  coffeeCompile:
    include: /.+(.coffee)$/
  ignore: /^\.slow\/(.)+/


min = ["a/a.css", "a/a.js", "a.min.css", "c/a.min.js", "a.min.css.h"]

hbsComplie = ['asd.hbs', "asdsa/a.hbs", "a.hbs.css"]

coffeeComple = ['a.coffee', 'c.coffee', "d.coffee.js", "m/a.coffee.js"]

ignore = ['.slow/a.js', '/.slow/ab.d', '.slowadd']

isReg = (o)-> o instanceof RegExp

test = (config, arr)->
  config = include: config if isReg config
  match = []
  ignore = []
  redundancy = []
  for index in arr
    if isReg(config.ignore) and config.ignore.test index
      ignore.push index
    else if config.include.test index
      match.push index
    else
      redundancy.push index

  console.log match, ignore, redundancy

#test config.min, min
#test config.hbsCompile, hbsComplie
test config.coffeeCompile, coffeeComple





