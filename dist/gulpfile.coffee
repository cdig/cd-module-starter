beepbeep = require "beepbeep"
browser_sync = require("browser-sync").create()
chalk = require "chalk"
del = require "del"
gulp = require "gulp"
gulp_autoprefixer = require "gulp-autoprefixer"
gulp_changed = require "gulp-changed"
gulp_coffee = require "gulp-coffee"
gulp_concat = require "gulp-concat"
gulp_inject = require "gulp-inject"
gulp_kit = require "gulp-kit"
gulp_notify = require "gulp-notify"
gulp_rename = require "gulp-rename"
gulp_replace = require "gulp-replace"
gulp_sass = require "gulp-sass"
gulp_shell = require "gulp-shell"
# gulp_sourcemaps = require "gulp-sourcemaps" # Uncomment and npm install for debug
# gulp_using = require "gulp-using" # Uncomment and npm install for debug
main_bower_files = require "main-bower-files"
path_exists = require("path-exists").sync


# CONFIG ##########################################################################################


assetTypes = "cdig,gif,ico,jpeg,jpg,json,m4v,mp3,mp4,pdf,png,svg,swf,txt,woff,woff2"


paths =
  assets:
    public: "public/**/*.{#{assetTypes}}"
    source: [
      "source/**/*.{#{assetTypes}}"
      "source/**/*.html" # Support for SVGA
      "bower_components/*/pack/**/*.{#{assetTypes}}"
    ]
  coffee:
    source: [
      "bower_components/**/pack/**/*.coffee"
      "source/**/*.coffee"
    ]
    watch: "{source,bower_components}/**/*.coffee"
  dev: "dev/**/*"
  html:
    pack: "bower_components/**/pack/**/*.html"
  kit:
    source: "source/index.kit"
    watch: "{source,bower_components}/**/*.{kit,html}"
  libs:
    source: [
      "public/_libs/bower/angular/angular*.js"
      "public/_libs/bower/take-and-make/dist/take-and-make.js"
      "public/_libs/**/*"
    ]
  scss:
    source: [
      "bower_components/cd-reset/dist/cd-reset.css"
      "bower_components/**/pack/**/vars.scss"
      "source/**/vars.scss"
      "bower_components/**/pack/**/*.scss"
      "source/**/*.scss"
    ]
    watch: "{source,bower_components}/**/*.scss"


gulp_notify.logLevel(0)
gulp_notify.on "click", ()->
  do gulp_shell.task "open -a Terminal"


# HELPER FUNCTIONS ################################################################################


fileContents = (filePath, file)->
  file.contents.toString "utf8"


logAndKillError = (err)->
  beepbeep()
  console.log chalk.bgRed("\n## Error ##")
  console.log chalk.red err.toString() + "\n"
  gulp_notify.onError(
    emitError: true
    icon: false
    message: err.message
    title: "👻"
    wait: true
    )(err)
  @emit "end"


# TASKS: MODULE COMPILATION #######################################################################


gulp.task "assets", ()->
  gulp.src paths.assets.source
    # .pipe gulp_using() # Uncomment for debug
    .pipe gulp_rename (path)->
      path.dirname = path.dirname.replace /.*\/pack\//, ''
      path
    .pipe gulp_changed "public"
    .pipe gulp.dest "public"
    .pipe browser_sync.stream
      match: "**/*.{#{assetTypes}}"
    .pipe gulp_notify
      title: "👍"
      message: "Assets"


gulp.task "coffee", ()->
  gulp.src paths.coffee.source
    # .pipe gulp_using() # Uncomment for debug
    # .pipe gulp_sourcemaps.init() # Uncomment for debug
    .pipe gulp_concat "scripts.coffee"
    .pipe gulp_coffee()
    .on "error", logAndKillError
    # .pipe gulp_sourcemaps.write "." # Uncomment for debug
    .pipe gulp.dest "public"
    .pipe browser_sync.stream
      match: "**/*.js"
    .pipe gulp_notify
      title: "👍"
      message: "Coffee"


gulp.task "del:public", ()->
  del "public"


gulp.task "dev", gulp_shell.task [
  'if [ -d "dev" ]; then rsync --exclude "*/.git/" --delete -ar dev/* bower_components; fi'
]


gulp.task "libs:bower", ()->
  gulp.src main_bower_files("**/*.{css,js}"), base: "bower_components/"
    # .pipe gulp_using() # Uncomment for debug
    .on "error", logAndKillError
    .pipe gulp.dest "public/_libs/bower"


gulp.task "kit", ()->
  libs = gulp.src paths.libs.source, read: false
  # html = gulp.src main_bower_files("**/*.html")
  pack = gulp.src paths.html.pack
  
  # libs.pipe(gulp_using()) # Uncomment for debug
  # html.pipe(gulp_using()) # Uncomment for debug
  # pack.pipe(gulp_using()) # Uncomment for debug

  gulp.src paths.kit.source
    # .pipe gulp_using() # Uncomment for debug
    .pipe gulp_kit()
    .on "error", logAndKillError
    .pipe gulp_inject libs, name: "bower", ignorePath: "/public/", addRootSlash: false
    # .pipe gulp_inject html, name: "bower", transform: fileContents
    .pipe gulp_inject pack, name: "pack", transform: fileContents
    .pipe gulp_replace "<script src=\"_libs", "<script defer src=\"_libs"
    .pipe gulp.dest "public"
    .pipe gulp_notify
      title: "👍"
      message: "HTML"


gulp.task "reload", (cb)->
  browser_sync.reload()
  cb()


gulp.task "scss", ()->
  gulp.src paths.scss.source
    # .pipe gulp_using() # Uncomment for debug
    # .pipe gulp_sourcemaps.init() # Uncomment for debug
    .pipe gulp_concat "styles.scss"
    .pipe gulp_sass
      errLogToConsole: true
      outputStyle: "compressed"
      precision: 1
    .on "error", logAndKillError
    .pipe gulp_autoprefixer
      browsers: "last 5 Chrome versions, last 5 ff versions, IE >= 10, Safari >= 8, iOS >= 8"
      cascade: false
      remove: false
    # .pipe gulp_sourcemaps.write "." # Uncomment for debug
    .pipe gulp.dest "public"
    .pipe browser_sync.stream
      match: "**/*.css"
    .pipe gulp_notify
      title: "👍"
      message: "SCSS"


gulp.task "serve", ()->
  browser_sync.init
    ghostMode: false
    notify: false
    server:
      baseDir: "public"
    ui: false
    watchOptions:
      ignoreInitial: true


gulp.task "watch", (cb)->
  gulp.watch paths.assets.source, gulp.series "assets"
  gulp.watch paths.coffee.watch, gulp.series "coffee"
  gulp.watch paths.dev, gulp.series "dev"
  gulp.watch paths.kit.watch, gulp.series "kit", "reload"
  gulp.watch paths.scss.watch, gulp.series "scss"
  cb()


# This task is also used from the command line, for bulk updates
gulp.task "recompile",
  gulp.series "del:public", "dev", "coffee", "scss", "assets", "libs:bower", "kit"


gulp.task "default",
  gulp.series "recompile", "watch", "serve"
