var coffee = require('gulp-coffee');
var gulp = require('gulp');
var gutil = require('gulp-util');
var sourcemaps = require('gulp-sourcemaps');

gulp.task('coffee', function() {
	gulp.src('./client/js/src/*.coffee')
		.pipe(sourcemaps.init())
		.pipe(coffee({bare: true}).on('error', gutil.log))
		.pipe(sourcemaps.write('./maps/'))
		.pipe(gulp.dest('./client/js/build/'))
});