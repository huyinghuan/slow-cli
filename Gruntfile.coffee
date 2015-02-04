_request = require 'request'
_path = require 'path'
_fse = require 'fs-extra'
_utils = require './src/lib/utils/file'

module.exports = (grunt)->
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.initConfig(
    pkg: grunt.file.readJSON 'package.json'
    coffee:
      build:
        expand: true
        flatten: false
        cwd: 'src'
        src: ['**/*.coffee', 'sample/.slow/*.coffee']
        dest: '.'
        ext: '.js'
  )

  grunt.registerTask('copySample', "copy sample", ->
    filesList = _utils.getAllFile(_path.resolve(__dirname, 'src/sample'))
    for filePath in filesList
      fileName = filePath.replace(__dirname, "").replace('src/' , '')
      continue if fileName.indexOf(".slow") isnt -1
      distFile = _path.join __dirname, fileName
      _fse.copySync filePath, distFile
  )

  grunt.registerTask('default', ['coffee:build', 'copySample'])

