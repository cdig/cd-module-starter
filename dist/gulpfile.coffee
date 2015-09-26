browser_sync = require("browser-sync").create()
gulp = require "gulp"
gulp_autoprefixer = require "gulp-autoprefixer"
gulp_coffee = require "gulp-coffee"
gulp_concat = require "gulp-concat"
gulp_kit = require "gulp-kit"
gulp_sass = require "gulp-sass"
gulp_sourcemaps = require "gulp-sourcemaps"
gulp_using = require "gulp-using"
gulp_util = require "gulp-util"

paths =
  coffee:
    source: [
      "bower_components/take-and-make/dist/take-and-make.coffee" # Take & Make first
      "{bower_components,source}/**/*.coffee"
      "!/**/*{activity,flow-arrows}*/**/*.coffee" # Exclude activity stuff
      ]
    watch: "{bower_components,source}/**/*.coffee"
  kit:
    source: "source/index.kit"
    watch: "{bower_components,source}/**/*.{kit,html}"
  sass:
    source: "source/styles.scss"
    watch: "{bower_components,source}/**/*.scss"


gulp.task "coffee", ()->
  gulp.src paths.coffee.source
    # .pipe gulp_using() # Uncomment for debug
    .pipe gulp_sourcemaps.init()
    .pipe gulp_concat "scripts.coffee"
    .pipe gulp_coffee().on "error", gulp_util.log
    .pipe gulp_sourcemaps.write "."
    .pipe gulp.dest "public"
    .pipe browser_sync.stream match: "**/*.js"


gulp.task "kit", ()->
  gulp.src paths.kit.source
    # .pipe gulp_using() # Uncomment for debug
    .pipe gulp_kit()
    .pipe gulp.dest "public"
    .pipe browser_sync.stream match: "**/*.html"


gulp.task "sass", ()->
  gulp.src paths.sass.source
    # .pipe gulp_using() # Uncomment for debug
    .pipe gulp_sourcemaps.init()
    .pipe gulp_sass
      errLogToConsole: true
      outputStyle: "compressed"
      precision: 1
    .pipe gulp_autoprefixer
      browsers: "last 2 Chrome versions, last 2 ff versions, IE >= 10, Safari >= 8, iOS >= 8"
      cascade: false
      remove: false
    .pipe gulp_sourcemaps.write "public"
    .pipe gulp.dest "public"
    .pipe browser_sync.stream match: "**/*.css"


gulp.task "serve", ()->
  browser_sync.init
    ghostMode: false
    logLevel: "silent"
    server: baseDir: "public"
    ui: false


gulp.task "default", ["coffee", "kit", "sass", "serve"], ()->
  gulp.watch paths.coffee.watch, ["coffee"]
  gulp.watch paths.kit.watch, ["kit"]
  gulp.watch paths.sass.watch, ["sass"]
