deepmerge = require 'deepmerge'

module.exports = (grunt)->
  resolveShared = (fileName)-> require('path').join './', 'shared', fileName

  @initConfig
    pkgFile: 'package.json'

    files:
      all: ['bin/npm-postinstall', 'lib/**/*.js']

    # JSHint
    jshint:
      node:
        # The node files you want to check
        src: ['<%= files.all %>']
        options: (deepmerge (require resolveShared 'jshint-node.json'),
          # Custom node files configuration (override the default node configuration file)
          strict: true
        )
      options: (deepmerge (require resolveShared 'jshint.json'),
        # Custom global configuration (override the default global configuration file)
          strict: true
      )

    # JSCS
    jscs:
      # The files you want to check
      all: ['<%= files.all %>']
      options:
        config: resolveShared 'jscs.json'
        # Custom configuration (override the default configuration file)
        disallowSpaceAfterKeywords: []

    simplemocha:
      options:
        ui: 'bdd'
        reporter: 'dot'
      src: [
        'test/mocha-globals.coffee',
        'test/**/*.coffee'
      ]

    # CoffeeLint
    coffeelint:
      # The files you want to check
      all: ['Gruntfile.coffee']
      options:
        configFile: resolveShared 'coffeelint.json'
        # Custom configuration (override the default configuration file)
        max_line_length:
          value: 100

    watch:
      test:
        files: ['<%= files.all %>', '<%= simplemocha.src %>']
        tasks: 'test'

  # Load tasks
  require('load-grunt-tasks') grunt

  # Register tasks
  @registerTask 'lint', ['coffeelint', 'jshint', 'jscs']
  @registerTask 'test', ['simplemocha']
  @registerTask 'default', ['lint', 'test']
