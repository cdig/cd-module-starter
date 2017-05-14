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
gulp_rev_all = require "gulp-rev-all"
gulp_sass = require "gulp-sass"
gulp_shell = require "gulp-shell"
gulp_sourcemaps = require "gulp-sourcemaps"
gulp_svgmin = require "gulp-svgmin"
gulp_uglify = require "gulp-uglify"
# gulp_using = require "gulp-using" # Uncomment and npm install for debug
main_bower_files = require "main-bower-files"


# STATE ###########################################################################################


prod = false


# CONFIG ##########################################################################################


assetTypes = "cdig,gif,jpeg,jpg,json,m4v,mp3,mp4,pdf,png,swf,txt,woff,woff2"


paths =
  assets: [
    "source/**/*.{#{assetTypes}}"
    "source/**/*.html" # Support for SVGA
    "!source/pages/*.html" # But don't match pages
    "bower_components/*/pack/**/*.{#{assetTypes}}"
  ]
  coffee: [
    "bower_components/**/pack/**/*.coffee"
    "source/**/*.coffee"
  ]
  dev: "dev/**/*"
  html: "bower_components/**/pack/**/*.html"
  kit:
    source: "source/index.kit"
    watch: "{source,bower_components}/**/*.{kit,html}"
  libs: [
    "public/_libs/bower/take-and-make/dist/take-and-make.js"
    "public/_libs/**/*"
  ]
  scss: [
    "bower_components/**/pack/**/vars.scss"
    "source/**/vars.scss"
    "bower_components/**/pack/**/*.scss"
    "source/**/*.scss"
  ]
  svg: "source/**/*.svg"


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


cond = (predicate, action)->
  if predicate
    action()
  else
    # This is what we use as a noop *shrug*
    gulp_rename (p)-> p


# TASKS: MODULE COMPILATION #######################################################################


gulp.task "assets", ()->
  gulp.src paths.assets
    .pipe gulp_rename (path)->
      path.dirname = path.dirname.replace /.*\/pack\//, ''
      path
    .pipe gulp_changed "public", hasChanged: gulp_changed.compareSha1Digest
    .pipe gulp.dest "public"
    .pipe browser_sync.stream
      match: "**/*.{#{assetTypes},html}"


gulp.task "coffee", ()->
  gulp.src paths.coffee
    .pipe cond !prod, ()-> gulp_sourcemaps.init()
    .pipe gulp_concat "scripts.coffee"
    .pipe gulp_coffee()
    .on "error", logAndKillError
    .pipe gulp_uglify()
    .pipe cond !prod, ()-> gulp_sourcemaps.write "."
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
    .on "error", logAndKillError
    .pipe gulp.dest "public/_libs/bower"


gulp.task "kit", ()->
  libs = gulp.src paths.libs, read: false
  # html = gulp.src main_bower_files("**/*.html")
  pack = gulp.src paths.html
  
  # libs.pipe(gulp_using()) # Uncomment for debug
  # html.pipe(gulp_using()) # Uncomment for debug
  # pack.pipe(gulp_using()) # Uncomment for debug

  gulp.src paths.kit.source
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
  gulp.src paths.scss
    .pipe cond !prod, ()-> gulp_sourcemaps.init()
    .pipe gulp_concat "styles.scss"
    .pipe gulp_sass
      errLogToConsole: true
      outputStyle: "compressed"
      precision: 1
    .on "error", logAndKillError
    .pipe gulp_autoprefixer
      browsers: "Android >= 4.4, Chrome >= 44, ChromeAndroid >= 44, Edge >= 12, ExplorerMobile >= 11, IE >= 11, Firefox >= 40, iOS >= 9, Safari >= 9"
      cascade: false
      remove: false
    .pipe cond !prod, ()-> gulp_sourcemaps.write "."
    .pipe gulp.dest "public"
    .pipe browser_sync.stream
      match: "**/*.css"
    .pipe gulp_notify
      title: "👍"
      message: "SCSS"



gulp.task "svg", ()->
  gulp.src paths.svg
    .on "error", logAndKillError
    .pipe gulp_replace "Lato_Regular_Regular", "Lato, sans-serif"
    .pipe gulp_replace "Lato_Bold_Bold", "Lato, sans-serif"
    .pipe gulp_replace "MEMBER_", "M_"
    .pipe gulp_replace "Layer", "L"
    .pipe gulp_replace "STROKES", "S"
    .pipe gulp_replace "FILL", "F"
    .pipe gulp_replace "writing-mode=\"lr\"", ""
    .pipe gulp_replace "baseline-shift=\"0%\"", ""
    .pipe gulp_replace "kerning=\"0\"", ""
    .pipe gulp_replace "xml:space=\"preserve\"", ""
    .pipe gulp_replace "fill-opacity=\".99\"", "" # This is close enough to 1 that it's not worth the cost
    .pipe gulp_svgmin (file)->
      full: true
      plugins: [
        {cleanupAttrs: true}
        {removeDoctype: true}
        {removeXMLProcInst: true}
        {removeComments: true}
        {removeMetadata: true}
        {removeTitle: true} # disabled by default
        {removeDesc: true}
        {removeUselessDefs: true}
        # {removeXMLNS: true} # for inline SVG, disabled by default
        {removeEditorsNSData: true}
        {removeEmptyAttrs: true}
        {removeHiddenElems: true}
        {removeEmptyText: true}
        {removeEmptyContainers: true}
        # {removeViewBox: true} # disabled by default
        {cleanUpEnableBackground: true}
        {minifyStyles: true}
        {convertStyleToAttrs: true}
        {convertColors:
          names2hex: true
          rgb2hex: true
        }
        {convertPathData:
          applyTransforms: true
          applyTransformsStroked: true
          makeArcs: {
            threshold: 20 # coefficient of rounding error
            tolerance: 10  # percentage of radius
          }
          straightCurves: true
          lineShorthands: true
          curveSmoothShorthands: true
          floatPrecision: 2
          transformPrecision: 2
          removeUseless: true
          collapseRepeated: true
          utilizeAbsolute: true
          leadingZero: true
          negativeExtraSpace: true
        }
        {convertTransform:
          convertToShorts: true
          degPrecision: 2 # transformPrecision (or matrix precision)
          floatPrecision: 2
          transformPrecision: 2
          matrixToTransform: true # Setting to true causes an error because of the inverse() call in SVG Mask
          shortTranslate: true
          shortScale: true
          shortRotate: true
          removeUseless: true
          collapseIntoOne: true
          leadingZero: true
          negativeExtraSpace: false
        }
        {removeUnknownsAndDefaults: true}
        {removeNonInheritableGroupAttrs: true}
        {removeUselessStrokeAndFill: true}
        {removeUnusedNS: true}
        {cleanupIDs: true}
        {cleanupNumericValues:
          floatPrecision: 2
        }
        {cleanupListOfValues:
          floatPrecision: 2
        }
        {moveElemsAttrsToGroup: true}
        {moveGroupAttrsToElems: true}
        {collapseGroups: true}
        {removeRasterImages: true} # disabled by default
        {mergePaths: true}
        {convertShapeToPath: true}
        {sortAttrs: true} # disabled by default
        # {transformsWithOnePath: true} # disabled by default
        # {removeDimensions: true} # disabled by default
        # {removeAttrs: attrs: []} # disabled by default
        # {removeElementsByAttr: id: [], class: []} # disabled by default
        # {addClassesToSVGElement: classNames: []} # disabled by default
        # {addAttributesToSVGElement: attributes: []} # disabled by default
        # {removeStyleElement: true} # disabled by default
        
      ]
    .pipe gulp.dest "public"
    


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
  gulp.watch paths.assets, gulp.series "assets"
  gulp.watch paths.coffee, gulp.series "coffee"
  gulp.watch paths.dev, gulp.series "dev"
  gulp.watch paths.kit.watch, gulp.series "kit", "reload"
  gulp.watch paths.scss, gulp.series "scss"
  gulp.watch paths.svg, gulp.series "svg", "reload"
  cb()


# This task is also used from the command line, for bulk updates
gulp.task "recompile",
  gulp.series "del:public", "dev", "coffee", "scss", "svg", "assets", "libs:bower", "kit"


gulp.task "default",
  gulp.series "recompile", "watch", "serve"
