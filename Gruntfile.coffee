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
      test: ['spec/**/*.coffee']
      gruntfile: ['Gruntfile.coffee']

    shell:
      test:
        command: 'node_modules/jasmine-focused/bin/jasmine-focused ' +
          '--captureExceptions --coffee spec'
        options:
          stdout: true
          stderr: true
          failOnError: true

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-shell'

  grunt.registerTask 'lint', ['coffeelint']
  grunt.registerTask 'default', ['lint', 'coffee']
  grunt.registerTask 'test', ['default', 'shell:test']
