gulp   = require "gulp"
jade   = require "gulp-jade"
coffee = require "gulp-coffee"
less   = require "gulp-less"
uncss  = require "gulp-uncss"
csso   = require "gulp-csso"
concat = require "gulp-concat"
uglify = require "gulp-uglify"
addSrc = require "gulp-add-src"

debug = false

addons = [
#	"comment/comment.js"
#	"comment/continuecomment.js"

	"display/placeholder.js"

	"edit/closebrackets.js"
#	"edit/closetag.js"
#	"edit/continuelist.js"
#	"edit/matchbrackets.js"
#	"edit/matchtags.js"
#	"edit/trailingspace.js"

#	"fold/foldcode.js"
#	"fold/foldgutter.js"
#	"fold/brace-fold.js"
#	"fold/xml-fold.js"
#	"fold/comment-fold.js"
	"fold/markdown-fold.js"
#	"fold/indent-fold.js"

#	"hint/show-hint.js"
#	"hint/anyword-hint.js"
#	"hint/css-hint.js"
#	"hint/html-hint.js"
#	"hint/javascript-hint.js"
#	"hint/python-hint.js"
#	"hint/sql-hint.js"
#	"hint/xml-hint.js"

	"selection/active-line.js"
	"selection/mark-selection.js"

#	"scroll/simplescrollbars.js"

#	"search/match-highlighter.js"
#	"search/search.js"
#	"search/searchcursor.js"
]

addonPaths = for addon in addons
	"bower_components/codemirror/addon/#{addon}"

modePaths = [
	"bower_components/codemirror/mode/markdown/markdown.js"
]

errorHandler = (e) -> console.log e.message

gulp.task "scripts", ->
	gulp.src [
		"bower_components/alight/alight.js"
		"bower_components/marked/marked.min.js"
		"bower_components/codemirror/lib/codemirror.js"
	].concat(addonPaths).concat(modePaths)
		.pipe concat "script.js"
		.pipe uglify()
		.pipe gulp.dest "src/built_temp"

gulp.task "coffee", ->
	try
		compiled = gulp.src "src/coffee/*"
			.pipe coffee().on "error", errorHandler

		if not debug
			compiled.pipe uglify().on "error", errorHandler

		compiled.pipe gulp.dest "src/built_temp/"
	catch e
		return


gulp.task "less", ->
	try
		if debug
			gulp.src "src/less/marqdown.less"
				.pipe less(ieCompat: false).on "error", errorHandler
				.pipe gulp.dest "src/built_temp/"

		else
			gulp.src "src/less/marqdown.less"
				.pipe less(compress: !debug, ieCompat: false).on "error", errorHandler
				.pipe uncss({
						html: ["dist/marqdown.html"]
						ignore: [/\.CodeMirror-\w+/].concat("h1,h2,h3,h4,h5,h6".split(","))
					}).on "error", errorHandler
				.pipe csso().on "error", errorHandler
				.pipe gulp.dest "src/built_temp/"
	catch e
		return


template = ->
	try
		gulp.src "src/template/marqdown.jade"
			.pipe jade(locals: {debug: debug}).on "error", errorHandler
			.pipe gulp.dest "dist/"
	catch e
		return

gulp.task "coffee-template", [ "coffee" ], ->
	template()
gulp.task "less-template", [ "less" ], ->
	template()
gulp.task "template", ->
	template()

gulp.task "default", ["scripts", "coffee", "less" ], ->
	template()
	gulp.watch ["src/coffee/*.*"], ["coffee-template"]
	gulp.watch ["src/less/*.*"], ["less-template"]
	gulp.watch ["src/template/*.*"], ["template"]
	gulp.watch ["README.md"], ["template"]