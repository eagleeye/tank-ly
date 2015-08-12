coffee = require('gulp-coffee')
gulp = require('gulp')
gutil = require('gulp-util')
sourcemaps = require('gulp-sourcemaps')
del = require('del')
nodemon = require('gulp-nodemon')
stylus = require('gulp-stylus')

paths =
	coffeeClient: './client/js/src/*.coffee',
	jsClient: './client/js/build/',
	stylusSrc: './client/css/src/*.styl',
	stylusSrcWatch: './client/css/src/**/*.styl',
	cssBuild: './client/css/build/'

gulp.task 'coffee-client', ['clean-js'], ->
	gulp.src(paths.coffeeClient)
		.pipe(sourcemaps.init())
		.pipe(coffee(bare: true).on('error', gutil.log))
		.pipe(sourcemaps.write('./maps/'))
		.pipe(gulp.dest(paths.jsClient))

gulp.task 'watch', ['coffee-client', 'stylus'], ->
	gulp.watch(paths.coffeeClient, ['coffee-client'])
	gulp.watch(paths.stylusSrcWatch, ['stylus'])

gulp.task 'clean-js', (cb) ->
	del([paths.jsClient], cb)

gulp.task 'clean-css', (cb) ->
	del([paths.cssBuild], cb)

gulp.task 'nodemon', ->
	nodemon(
		script: "./source/app.coffee"
		ext: 'coffee js'
		watch: ['source/', 'views/']
	).on 'restart', ->
		gutil.log('Restarting app...')

gulp.task('dev', ['nodemon', 'watch'])
gulp.task('build', ['coffee-client', 'stylus'])

gulp.task 'stylus', ['clean-css'], ->
	gulp.src(paths.stylusSrc)
		.pipe(sourcemaps.init())
		.pipe(stylus())
		.pipe(sourcemaps.write('./maps/'))
		.pipe(gulp.dest(paths.cssBuild))
