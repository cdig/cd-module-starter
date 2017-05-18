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
watching = false


# CONFIG ##########################################################################################


# Assets that should just be copied straight from source to public with no processing
basicAssetTypes = "cdig,gif,jpeg,jpg,json,m4v,min.html,mp3,mp4,pdf,png,swf,txt,woff,woff2"


paths =
  basicAssets: [
    "bower_components/*/pack/**/*.{#{basicAssetTypes}}"
    "source/**/*.{#{basicAssetTypes}}"
  ]
  coffee: [
    "bower_components/**/pack/**/*.coffee"
    "source/**/*.coffee"
  ]
  dev: "dev/**/*"
  kit:
    libs: [
      "public/_libs/take-and-make/dist/take-and-make.js"
      "public/_libs/**/*.{css,js}"
    ]
    packHtml: "bower_components/**/pack/**/*.html"
    source: "source/index.kit"
    watch: "{source,bower_components}/**/*.{kit,html}"
  scss: [
    "bower_components/**/pack/**/vars.scss"
    "source/**/vars.scss"
    "bower_components/**/pack/**/*.scss"
    "source/**/*.scss"
  ]
  svg: [
    "bower_components/**/pack/**/*.svg"
    "source/**/*.svg"
  ]


svgConfig =
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
    {cleanupNumericValues: floatPrecision: 2}
    {cleanupListOfValues: floatPrecision: 2}
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

changed = ()->
  cond watching, ()->
    gulp_changed "public", hasChanged: gulp_changed.compareSha1Digest

stream = (glob)->
  cond watching, ()->
    browser_sync.stream match: glob

stripPack = (path)->
  path.dirname = path.dirname.replace /.*\/pack\//, ''
  path

initMaps = ()->
  cond !prod, ()->
    gulp_sourcemaps.init()

emitMaps = ()->
  cond !prod, ()->
    gulp_sourcemaps.write "."

notify = (msg)->
  cond watching, ()->
    gulp_notify
      title: "👍"
      message: msg


# TASKS: COMPILATION ##############################################################################


# Copy all basic assets in source and bower_component packs to public
gulp.task "basicAssets", ()->
  gulp.src paths.basicAssets
    .pipe gulp_rename stripPack
    .pipe changed()
    .pipe gulp.dest "public"
    .pipe stream "**/*.{#{basicAssetTypes},html}"


# Compile coffee in source and bower_component packs, with sourcemaps in dev and uglify in prod
gulp.task "coffee", ()->
  gulp.src paths.coffee
    .pipe initMaps()
    .pipe gulp_concat "scripts.coffee"
    .pipe gulp_coffee()
    .on "error", logAndKillError
    .pipe cond prod, ()-> gulp_uglify()
    .pipe emitMaps()
    .pipe gulp.dest "public"
    .pipe stream "**/*.js"
    .pipe notify "Coffee"


# Copy items in the dev folder (if it exists) to bower_components
gulp.task "dev", gulp_shell.task [
  'if [ -d "dev" ]; then rsync --exclude "*/.git/" --delete -ar dev/* bower_components; fi'
]


gulp.task "kit", ()->
  libs = gulp.src paths.kit.libs, read: false
  packHtml = gulp.src paths.kit.packHtml
  gulp.src paths.kit.source
    .pipe gulp_kit()
    .on "error", logAndKillError
    .pipe gulp_inject libs, name: "libs", ignorePath: "/public/", addRootSlash: false
    .pipe gulp_inject packHtml, name: "pack", transform: fileContents
    .pipe gulp_replace "<script src=\"_libs", "<script defer src=\"_libs"
    .pipe gulp.dest "public"
    .pipe notify "HTML"


# Copy cd-reset, normalize-css, and take-and-make to the public/_libs folder
gulp.task "libs", ()->
  gulp.src main_bower_files("**/*.{css,js}"), base: "bower_components/"
    .on "error", logAndKillError
    .pipe gulp.dest "public/_libs"


# Compile scss in source and bower_component packs, with sourcemaps in dev and autoprefixer in prod
gulp.task "scss", ()->
  gulp.src paths.scss
    .pipe initMaps()
    .pipe gulp_concat "styles.scss"
    .pipe gulp_sass
      errLogToConsole: true
      outputStyle: "compressed"
      precision: 1
    .on "error", logAndKillError
    .pipe cond prod, ()-> gulp_autoprefixer
      browsers: "Android >= 4.4, Chrome >= 44, ChromeAndroid >= 44, Edge >= 12, ExplorerMobile >= 11, IE >= 11, Firefox >= 40, iOS >= 9, Safari >= 9"
      cascade: false
      remove: false
    .pipe emitMaps()
    .pipe gulp.dest "public"
    .pipe stream "**/*.css"
    .pipe notify "SCSS"


# Clean and minify static SVG files in source and bower_component packs
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
    .pipe gulp_replace "fill-opacity=\".99\"", "" # This is close enough to 1 that it's not worth the perf cost
    .pipe gulp_svgmin (file)-> svgConfig
    .pipe gulp.dest "public"


# TASKS: SYSTEM ###################################################################################


gulp.task "del:public", ()->
  del "public"


gulp.task "del:deploy", ()->
  del "deploy"


gulp.task "prod:setup", (cb)->
  prod = true
  cb()
  

gulp.task "reload", (cb)->
  browser_sync.reload()
  cb()


gulp.task "rev", ()->
  gulp.src "public/**"
    .pipe gulp_rev_all.revision
      transformPath: (rev, source, path)-> # Applies to file references inside HTML/CSS/JS
        rev.replace /.*\//, ""
      transformFilename: (file, hash)->
        name = file.revHash + file.extname
        gulp_shell.task("rm -rf .deploy && mkdir .deploy && touch .deploy/#{name}")() if file.revPathOriginal.indexOf("/public/index.html") > 0
        name
    .pipe gulp_rename (path)->
      path.dirname = ""
      path
    .pipe gulp.dest "deploy"


gulp.task "serve", ()->
  browser_sync.init
    ghostMode: false
    notify: false
    server: baseDir: "public"
    ui: false
    watchOptions: ignoreInitial: true


gulp.task "watch", (cb)->
  watching = true
  gulp.watch paths.basicAssets, gulp.series "basicAssets"
  gulp.watch paths.coffee, gulp.series "coffee"
  gulp.watch paths.dev, gulp.series "dev"
  gulp.watch paths.kit.watch, gulp.series "kit", "reload"
  gulp.watch paths.scss, gulp.series "scss"
  gulp.watch paths.svg, gulp.series "svg", "reload"
  cb()


gulp.task "recompile",
  gulp.series "del:public", "dev", "libs", "basicAssets", "coffee", "scss", "svg", "kit"


gulp.task "prod",
  gulp.series "prod:setup", "recompile", "del:deploy", "rev"


gulp.task "default",
  gulp.series "recompile", "watch", "serve"
