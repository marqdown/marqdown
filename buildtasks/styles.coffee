module.exports = (gulp, options) ->
	less    = require "gulp-less"
	lint    = require "gulp-lesshint"
	ifelse  = require "gulp-if-else"
	prefix  = require "gulp-autoprefixer"
	csso    = require "gulp-csso"
	postcss = require "gulp-postcss"
	uncss   = require "uncss"


	prefixerOptions = {
		# @see http://caniuse.com/usage-table
		browsers: [
			"not ie <= 8"
			"> 0.5%"
			"last 5 versions"
			"Firefox ESR"
		]
#		browsers:"> 5%"
	}

	unCSSClasses = [/\.CodeMirror.*/, /\.cm-s-marqdown.*/, /\.?table.*/, /@keyframe.*/, /#app-\w+/, /#preview.*/]
					.concat("h1,h2,h3,h4,h5,h6,blockquote,hr,pre,code".split(","))


	gulp.task "styles:lint", ->
		gulp.src "src/less/marqdown.less"
			.pipe lint()
			.pipe lint.reporter()


	gulp.task "styles:less", ->
		gulp.src "src/less/marqdown.less"
			.pipe less(compress: !options.debug, ieCompat: false)
			.pipe ifelse(!options.debug, -> prefix(prefixerOptions))
			.pipe gulp.dest "src/built_temp/"


	gulp.task "styles:postprocess", ["templates:prebuild"], ->
		plugins = [
			uncss.postcssPlugin({
				timeout: 3000
				html: ["src/built_temp/marqdown.html"]
				ignore: unCSSClasses
			})
		]

		gulp.src "src/built_temp/marqdown.css"
			.pipe ifelse(!options.debug, -> postcss(plugins))
			.pipe ifelse(!options.debug, csso)
			.pipe gulp.dest "src/built_temp/"


	gulp.task "styles", ["styles:lint", "styles:less"]
