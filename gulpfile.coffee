gulp   = require "gulp"
jade   = require "gulp-jade"
coffee = require "gulp-coffee"
less   = require "gulp-less"
uncss  = require "gulp-uncss"
csso   = require "gulp-csso"
concat = require "gulp-concat"
uglify = require "gulp-uglify"
lzstr  = require "lz-string"
fs     = require "fs"

debug = false
compressBody = true

addons = [
#	"comment/comment.js"
#	"comment/continuecomment.js"

	"display/placeholder.js"

	"edit/closebrackets.js"
#	"edit/closetag.js"
	"edit/continuelist.js"
	"edit/matchbrackets.js"
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

	"runmode/runmode.js"

	"selection/active-line.js"
	"selection/mark-selection.js"

#	"scroll/simplescrollbars.js"

#	"search/match-highlighter.js"
#	"search/search.js"
#	"search/searchcursor.js"
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


errorHandler = (e) ->
	console.log "======= ERROR DESCRIPTION ======"
	console.log e.extract
	console.log e.message
	console.log "======= ERROR DESCRIPTION END ======"
	@emit "end"


gulp.task "scripts", ->
	gulp.src [
		"bower_components/codemirror/lib/codemirror.js"
		"bower_components/marked/marked.min.js"
		"bower_components/alight/alight.js"
	].concat(addonPaths).concat(modePaths)
		.pipe concat "script.js"
		.pipe uglify()
		.pipe gulp.dest "src/built_temp"


gulp.task "coffee", ->
	compiled = gulp.src "src/coffee/*"
		.pipe coffee()
		.on "error", errorHandler

	if not debug
		compiled.pipe uglify()
				.on 'error', errorHandler

	compiled.pipe gulp.dest "src/built_temp/"


gulp.task "less", ->
	if debug
		gulp.src "src/less/marqdown.less"
			.pipe less(ieCompat: false)
			.on "error", errorHandler
			.pipe gulp.dest "src/built_temp/"

	else
		gulp.src "src/less/marqdown.less"
			.pipe less(compress: !debug, ieCompat: false)
			.on "error", errorHandler
			.pipe uncss({
					html: ["dist/marqdown.html"]
					ignore: [/\.CodeMirror-\w+/, /#page-\w+/, /\.cm-s-marqdown.*/, /blockquote/].concat("h1,h2,h3,h4,h5,h6".split(","))
				})
			.on "error", errorHandler
			.pipe csso()
			.on "error", errorHandler
			.pipe gulp.dest "src/built_temp/"



gulp.task "template-body", [ "coffee", "less" ], ->
	gulp.src "src/template/body.jade"
		.pipe jade(locals: {debug: debug})
		.on "error", errorHandler
		.pipe gulp.dest "src/built_temp/"

gulp.task "template-body-compress", [ "template-body" ], ->
	if compressBody
		data = fs.readFileSync("src/built_temp/body.html", "utf8")
		compressed = lzstr.compressToBase64 data
		script = """<script type="text/javascript">"""
		script += (fs.readFileSync("bower_components/lz-string/libs/lz-string.min.js", "utf8")).slice(0,-1)
		script += """;var _marqdown=LZString.decompressFromBase64(\"#{compressed}\");document.write(_marqdown);</script>"""
		fs.writeFileSync("src/built_temp/body.html", script, "utf8")

gulp.task "template", [ "template-body-compress" ], ->
	gulp.src "src/template/marqdown.jade"
		.pipe jade(locals: {debug: debug})
		.on "error", errorHandler
		.pipe gulp.dest "dist/"


gulp.task "default", ["scripts", "template"], ->
	gulp.watch [
		"src/coffee/*.*"
		"src/less/*.*"
		"src/template/*.*"
		"README.md"
	], ["template"]