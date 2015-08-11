gulp = require('gulp')
inject = require('gulp-inject')
gutil = require('gulp-util')
coffee = require('gulp-coffee')
less = require('gulp-less')
#serve = require('gulp-serve')
browserSync = require('browser-sync')
browserify = require('gulp-browserify')
uglify = require('gulp-uglify')
concat = require('gulp-concat')
cssMin = require('gulp-minify-css')
htmlMin = require('gulp-minify-html')
notify = require('gulp-notify')


gulp.task 'default',['js','less','serve'], ->
  #gulp.src('./src/index.html').pipe(gulp.dest('./dist'))
  target = gulp.src('./src/index.html')
  # It's not necessary to read the files (will speed up things), we're only after their paths:
  sources = gulp.src(['./dist/**/*.js', './dist/**/*.css'], {read: false})
  target.pipe(gulp.dest('./dist'))
    .pipe(inject(sources, {relative: true}))
    .pipe(gulp.dest('./dist'))

gulp.task 'coffee', ->
  gulp.src('./src/**/*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest('./src'))

gulp.task 'less', ->
  gulp.src('./src/**/*.less')
    .pipe(less().on('error', gutil.log))
    .pipe(gulp.dest('./dist'))

gulp.task 'js', ['coffee'], ->
  gulp.src('./src/**/*.js')
    .pipe(browserify().on('error',gutil.log))
    .pipe(uglify().on('error',gutil.log))
    .pipe(gulp.dest('./dist'))

gulp.task 'js-watch',['js'],browserSync.reload

gulp.task 'serve',['js'],->
  browserSync({
    server:{
      baseDir:"./dist"
    }
  })
  gulp.watch('./src/**/*.coffee',['js-watch'])
