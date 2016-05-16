module.exports = (gulp, options) ->
	coffee = require "gulp-coffee"
	ifElse = require "gulp-if-else"
	uglify = require "gulp-uglify"
	concat = require "gulp-concat"
	lint   = require "gulp-coffeelint"

	addons = [
#		"comment/comment.js"
#		"comment/continuecomment.js"

		"display/placeholder.js"

		"edit/closebrackets.js"
#		"edit/closetag.js"
		"edit/continuelist.js"
		"edit/matchbrackets.js"
#		"edit/matchtags.js"
#		"edit/trailingspace.js"

#		"fold/foldcode.js"
#		"fold/foldgutter.js"
#		"fold/brace-fold.js"
#		"fold/xml-fold.js"
#		"fold/comment-fold.js"
		"fold/markdown-fold.js"
#		"fold/indent-fold.js"

#		"hint/show-hint.js"
#		"hint/anyword-hint.js"
#		"hint/css-hint.js"
#		"hint/html-hint.js"
#		"hint/javascript-hint.js"
#		"hint/python-hint.js"
#		"hint/sql-hint.js"
#		"hint/xml-hint.js"

		"runmode/runmode.js"

		"selection/active-line.js"
		"selection/mark-selection.js"

#		"scroll/simplescrollbars.js"

#		"search/match-highlighter.js"
#		"search/search.js"
#		"search/searchcursor.js"
	]

	addonPaths = for addon in addons
		"bower_components/codemirror/addon/#{addon}"

	modes = [
		"markdown"
		"clike"
		"coffeescript"
		"css"
		"htmlmixed"
		"javascript"
		"perl"
		"php"
		"python"
		"sql"
		"xml"
	]

	modePaths = for mode in modes
		"bower_components/codemirror/mode/#{mode}/#{mode}.js"


	gulp.task "scripts:libs", ->
		sourceFiles = [
			"bower_components/codemirror/lib/codemirror.js"
			"bower_components/marked/marked.min.js"
			"bower_components/alight/alight.js"
		].concat(addonPaths).concat(modePaths)
		gulp.src sourceFiles
			.pipe concat "script.js"
			.pipe ifElse(!options.debug, uglify)
			.pipe gulp.dest "src/built_temp"


	gulp.task "scripts:lint", ->
		gulp.src "src/coffee/*"
			.pipe lint()
			.pipe lint.reporter()

	gulp.task "scripts:coffee", ->
		gulp.src "src/coffee/*"
			.pipe coffee()
			.pipe ifElse(!options.debug, uglify)
			.pipe gulp.dest "src/built_temp/"


	gulp.task "scripts", ["scripts:lint", "scripts:coffee"]
