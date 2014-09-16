Tag = module.exports = {}

#生成js标签
generateScriptTag = (src)->
  "<script src='#{src}'></script>"

#生成css标签
generateStyleTag = (href)->
  "<link href='#{href}' rel='stylesheet' type='text/css'>"

generateTags = (filePaths)->
  cssReg = /(\.css|\.less)$/
  jsReg = /(\.js|\.coffee)$/
  queue = []
  for uri in filePaths
   queue.push generateScriptTag uri if jsReg.test uri
   queue.push generateStyleTag uri if cssReg.test uri
  queue.join '\n'



Tag.generateScriptTag = generateScriptTag
Tag.generateStyleTag = generateStyleTag
Tag.generateTags = generateTags