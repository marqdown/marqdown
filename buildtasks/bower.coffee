module.exports = (gulp, options) ->
	bower = require "gulp-bower"

	gulp.task "bower:install", ->
		bower()

