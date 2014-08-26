module.exports = (grunt)->
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.initConfig(
    pkg: grunt.file.readJSON 'package.json'
    coffee:
      dev:
        expand: true
        flatten: false
        cwd: 'src'
        src: ['*/*.coffee', '*/*/*.coffee']
        dest: '.'
        ext: '.js'
    watch:
      files: ['src/*.coffee', 'src/*/*.coffee', 'src/*/*/*.coffee']
      tasks: ['coffee:dev']
  )
