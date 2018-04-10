module.exports = (grunt) ->

# =============================== Load plugins =============================== #
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-compress'
  grunt.loadNpmTasks 'grunt-contrib-qunit'
  grunt.loadNpmTasks 'grunt-eslint'
  grunt.loadNpmTasks 'grunt-travis-lint'
  grunt.loadNpmTasks 'grunt-jsonlint'
  grunt.loadNpmTasks 'grunt-coffeelint'



# ================================= Settings ================================= #
  # Force use of Unix newlines
  grunt.util.linefeed = '\n'


  # Project configuration
  # =====================
  grunt.initConfig

    # Load external configurations
    pkg: grunt.file.readJSON 'package.json'

    # Sources configuration
    src:
      output: 'src/jquery.async-gravatar.min.js'
      input: 'src/jquery.async-gravatar.js'

    # Banner
    banner: '/*! <%= pkg.title %> v<%= pkg.version %> | (c) 2015-2016 <%= pkg.author.name %>. | MIT license */\n'



# =================================== Task =================================== #

    # Packaging
    # ---------

    # Uglify
    uglify:
      default:
        options:
          report: 'gzip'
          banner: '<%= banner %>'
        files:
          '<%= src.output %>': '<%= src.input %>'

    # Compress
    compress:
      main:
        options:
          archive: "build/<%= pkg.name %>-v<%= pkg.version %>.tar.gz"
        files : [
          {
            expand: true
            src : [
              '<%= src.output %>'
              '<%= src.input %>'
              'LICENSE.txt'
              'README.md'
            ]
            flatten: true
            cwd: './'
            dest: '<%= pkg.name %>-v<%= pkg.version %>/'
          }
        ]


    # Linters
    # ------

    # JS
    eslint:
      options:
        configFile: '.eslintrc',
      target: [
        '<%= src.input %>'
        "test/*.js"
      ]

    # JSON
    jsonlint:
      default:
        src: [
          "*.json"
          ".coffeelintrc"
          ".eslintrc"
        ]

    # Coffee
    coffeelint:
      default: [
        '*.coffee'
      ]
      options:
        configFile: '.coffeelintrc'


    # Unit tests
    # ----------
    qunit:
      options:
        timeout: 30000,
        "--web-security": "no",
        coverage:
          src: '<%= src.input %>'
          instrumentedFiles: "temp/"
          lcovReport: "build"
          linesThresholdPct: 70
      all: ['test/*.html']



# ============================== Callable tasks ============================== #
  grunt.registerTask 'test', [
    'lint'
    'unit_tests'
  ]

  grunt.registerTask 'lint', [
    'jsonlint'
    'travis-lint'
    'coffeelint'
    'eslint'
  ]

  grunt.registerTask 'unit_tests', [
    'qunit'
  ]

  grunt.registerTask 'build', [
    'lint'
    'unit_tests'
    'uglify'
  ]

  grunt.registerTask 'release', [
    'build'
    'compress'
  ]

  # Alias
  grunt.registerTask 'default', 'build'
