browser_sync = require("browser-sync").create()
del = require "del"
gulp = require "gulp"
gulp_autoprefixer = require "gulp-autoprefixer"
gulp_coffee = require "gulp-coffee"
gulp_concat = require "gulp-concat"
gulp_json_editor = require "gulp-json-editor"
gulp_kit = require "gulp-kit"
gulp_replace = require "gulp-replace"
gulp_sass = require "gulp-sass"
gulp_sourcemaps = require "gulp-sourcemaps"
gulp_using = require "gulp-using"
gulp_util = require "gulp-util"
main_bower_files = require "main-bower-files"
run_sequence = require "run-sequence"


# Some stuff is meant to be included in the module at compile time
  # Everything in the source folder, and all asset packs
# Everything else is meant to be included in the module at runtime
  # All other bower dependencies

# compile+merge coffee and scss, from source + all asset packs
# compile index.kit, folding-in .html and .kit in all asset packs


paths =
  coffee:
    source: [
      "bower_components/take-and-make/dist/take-and-make.coffee"
      "bower_components/**/pack/**/*.coffee"
      "source/**/*.coffee"
      "!source/**/*activity*/**/*.coffee" # Exclude activity stuff
      ]
    watch: "{bower_components,source}/**/*.coffee"
  kit:
    source: "source/index.kit"
    watch: "{bower_components,source}/**/*.{kit,html}"
  sass:
    source: [
      "bower_components/**/pack/**/vars.scss"
      "source/**/vars.scss"
      "bower_components/**/pack/**/*.scss"
      "source/**/*.scss"
    ]
    watch: "{bower_components,source}/**/*.scss"


gulp.task "coffee", ()->
  gulp.src paths.coffee.source
    # .pipe gulp_using() # Uncomment for debug
    .pipe gulp_sourcemaps.init()
    .pipe gulp_concat "scripts.coffee"
    .pipe gulp_coffee().on "error", gulp_util.log
    .pipe gulp_sourcemaps.write "."
    .pipe gulp.dest "public"
    .pipe browser_sync.stream match: "public/**/*.js"


gulp.task "kit", ()->
  gulp.src paths.kit.source
    # .pipe gulp_using() # Uncomment for debug
    .pipe gulp_kit()
    .pipe gulp.dest "public"
    .pipe browser_sync.stream match: "public/**/*.html"


gulp.task "sass", ()->
  gulp.src paths.sass.source
    # .pipe gulp_using() # Uncomment for debug
    .pipe gulp_sourcemaps.init()
    .pipe gulp_concat "styles.scss"
    .pipe gulp_sass
      errLogToConsole: true
      outputStyle: "compressed"
      precision: 1
    .pipe gulp_autoprefixer
      browsers: "last 5 Chrome versions, last 2 ff versions, IE >= 10, Safari >= 8, iOS >= 8"
      cascade: false
      remove: false
    .pipe gulp_sourcemaps.write "."
    .pipe gulp.dest "public"
    .pipe browser_sync.stream match: "public/**/*.css"


gulp.task "serve", ()->
  browser_sync.init
    ghostMode: false
    server: baseDir: "public"
    ui: false


gulp.task "default", ["coffee", "kit", "sass"], ()->
  gulp.run "serve"
  gulp.watch paths.coffee.watch, ["coffee"]
  gulp.watch paths.kit.watch, ["kit"]
  gulp.watch paths.sass.watch, ["sass"]


###################################################################################################


sortObjectKeys = (unsorted)->
  sorted = {}
  sorted[k] = unsorted[k] for k in Object.keys(unsorted).sort()
  return sorted


gulp.task "evolve:bower", ()->
  gulp.src "bower.json"
    .pipe gulp_json_editor (bower)->
      dependencies = bower.dependencies
      delete dependencies._project # Replaced by lbs-pack
      delete dependencies["flow-arrows"] # Included by svg-activity
      dependencies["cd-module"] = "cdig/cd-module#v2"
      dependencies["lbs-pack"] = "cdig/lbs-pack"
      return v2Bower =
        name: "cdig-module"
        description: "An LBS Module"
        dependencies: sortObjectKeys dependencies
        license: "UNLICENSED"
        private: true
    .pipe gulp.dest "."


gulp.task "evolve:del", ()->
  del "config.codekit"
  del ".codekit-cache"
  
  
gulp.task "evolve:rewrite", ()->
  gulp.src "source/**/*.{kit,html}"
    .pipe gulp_replace "<main", "<cd-main"
    .pipe gulp_replace "</main", "</cd-main"
    .pipe gulp_replace "<!-- @import ../bower_components/_project/dist/", "<!-- @import "
    .pipe gulp.dest (vinylFile)-> vinylFile.base
  gulp.src "source/**/*.{css,scss}"
    .pipe gulp_replace "_project/dist", "lbs-pack/pack"
    .pipe gulp.dest (vinylFile)-> vinylFile.base


gulp.task "evolve", ()->
  run_sequence "evolve:bower", "evolve:del", "evolve:rewrite"
