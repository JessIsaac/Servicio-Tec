var gulp = require("gulp");
var sass = require("gulp-sass");
var autoprefixer = require("gulp-autoprefixer");
var browserSync = require('browser-sync').create();

gulp.task("sasser",function()
{
	gulp.src("*.scss")
	.pipe(sass())
	.pipe(autoprefixer({ browsers:["last 3 versions"]}))
	.pipe(gulp.dest("app/assets/css"))
	browserSync.init({
        server: "./app"
    });
})

gulp.task("default",function()
{
	gulp.watch("app/assets/stylesheets/*.scss", ['sasser']);
	gulp.watch("app/*.erb").on('change', browserSync.reload);
})
