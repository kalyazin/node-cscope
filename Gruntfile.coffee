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
      # FIXME: waiting for grunt-coffeelint to upgrade to
      # coffeelint-1.3.0
      options:
        indentation:
          level: 'warn'
      src: ['src/**/*.coffee']
      gruntfile: ['Gruntfile.coffee']

  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-coffeelint')

  grunt.registerTask('lint', ['coffeelint'])
  grunt.registerTask('default', ['lint', 'coffee'])
