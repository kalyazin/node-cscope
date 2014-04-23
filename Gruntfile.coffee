module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    coffee:
      glob_to_multiple:
        expand: true
        cwd: 'src'
        src: ['*.coffee']
        dest: 'lib'
        ext: '.js'

    coffeelint:
      src: ['src/**/*.coffee']
      gruntfile: ['Gruntfile.coffee']

  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-coffeelint')

  grunt.registerTask('lint', ['coffeelint'])
  grunt.registerTask('default', ['lint', 'coffee'])
