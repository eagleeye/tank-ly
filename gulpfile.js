var coffee = require('gulp-coffee');
var gulp = require('gulp');
var gutil = require('gulp-util');
var sourcemaps = require('gulp-sourcemaps');
var del = require('del');
var nodemon = require('gulp-nodemon');
//var stylus = require('gulp-stylus');

paths = {
	coffeeClient: './client/js/src/*.coffee',
	jsClient: './client/js/build/',
	stylusSrc: './client/css/src/*.styl',
	stylusSrcWatch: './client/css/src/**/*.styl',
	cssBuild: './client/css/build/'
};

gulp.task('coffee-client', ['clean-js'], function() {
	gulp.src(paths.coffeeClient)
		.pipe(sourcemaps.init())
		.pipe(coffee({bare: true}).on('error', gutil.log))
		.pipe(sourcemaps.write('./maps/'))
		.pipe(gulp.dest(paths.jsClient))
});

gulp.task('watch', ['coffee-client'], function() { //, 'sass'
	gulp.watch(paths.coffeeClient, ['coffee-client']);
	//gulp.watch(paths.sassSrcWatch, ['sass']);
});

gulp.task('clean-js', function(cb) {
	del([paths.jsClient], cb);
});

gulp.task('clean-css', function(cb) {
	del([paths.cssBuild], cb);
});

gulp.task('nodemon', function () {
	nodemon({ script: "./source/app.coffee",
		ext: 'coffee js',
		watch: ['source/']
	}).on('restart', function () {
		gutil.log('Restarting app...');
	});
});

gulp.task('dev', ['nodemon', 'watch']);
gulp.task('build', ['coffee-client']); //, 'sass'

//gulp.task('stylus', ['clean-css'], function () {
//	gulp.src(paths.stylusSrc)
//		.pipe(stylus({
//			sourceComments: 'map'
//		}))
//		.pipe(gulp.dest(paths.cssBuild));
//});