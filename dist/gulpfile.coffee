gulp = require 'gulp'
coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
connect = require 'gulp-connect'
kit = require 'gulp-kit'
sass = require 'gulp-sass'
gutil = require 'gulp-util'
merge = require 'merge2'

gulp.task 'default', ['connect', 'kit', 'sass', 'sass:watch','coffee:watch', 'css', 'html-combine','coffee']

gulp.task 'kit', ()->
  return gulp.src('source/index.kit')
  .pipe(kit())
  .pipe(gulp.dest('public/'))

gulp.task 'connect', ->
  connect.server {
    root: 'public',
    livereload: true
  }


#make sure that take and make is compiled first since other files depend on it
#this only works with compiling the bower coffee script. The ** means any child directories and their children
#the same thing could be done for sass easily
gulp.task 'coffee', ->
  return gulp.src(['./bower_components/take-and-make/dist/take-and-make.coffee','./bower_components/**/*.coffee' ])
  .pipe(concat('scripts.coffee'))
  .pipe(coffee({})).on('error', gutil.log)
  .pipe(gulp.dest('public'))


gulp.task 'copyHtml', ->
#   copy html in source/ to public/
  return gulp.src('source/*.html').pipe(gulp.dest('public'))

#works the same as coffee
gulp.task 'sass', ->
  return gulp.src('source/sass/*.scss')
  .pipe(sass())
  .pipe(gulp.dest('public'))
  .pipe(connect.reload())

gulp.task 'html-combine', ->
  return gulp.src(['./source/html/top.html', './source/html/pages/**/*.html','./source/html/bottom.html' ])
  .pipe(concat('index2.html'))
  .pipe(gulp.dest('./public'))


gulp.task 'sass:watch', ->
  return gulp.watch './source/sass/*.scss', ['sass']

gulp.task 'coffee:watch', ->
  return gulp.watch './bower_components/**/*.coffee', ['coffee']

gulp.task 'css', ->
  return gulp.src('public/*.css')

#setting up a gulp watch will
gulp.task 'watch', ->
  return gulp.watch(['public/*.css'], ['css'])
