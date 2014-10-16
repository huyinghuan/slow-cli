_request = require 'request'

module.exports = (grunt)->
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'


  grunt.registerTask('explore', 'visit localhost', ()->
    this.async()
    _request 'http://localhost:3000', (err, response, body)->
      return console.log err if err
      console.log body
  )

  _fs = require 'fs'
  grunt.registerTask('fs-test', 'test fs', ()->
    console.log _fs.existsSync('.slow')
    console.log _fs.existsSync('sample/.slow')
  )

  grunt.initConfig(
    pkg: grunt.file.readJSON 'package.json'
    coffee:
      dev:
        expand: true
        flatten: false
        cwd: 'src'
        src: ['*/*.coffee', '*/*/*.coffee',
              '*/*/*/*.coffee', '*/*/*/*/*.coffee',
              'sample/.slow/*.coffee']
        dest: '.'
        ext: '.js'
    watch:
      files: ['src/*.coffee', 'src/*/*.coffee', 'src/*/*/*.coffee', 'src/sample/.slow/*.coffee']
      tasks: ['coffee:dev']
  )



