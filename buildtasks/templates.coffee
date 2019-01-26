module.exports = (gulp, options) ->
	pug  = require "gulp-pug"
	lzstr = require "lz-string"
	fs    = require "fs"


	gulp.task "templates:prebuild-body", [ "scripts:libs", "scripts", "styles" ], ->
		gulp.src "src/template/body.jade"
			.pipe pug(locals: {debug: options.debug})
			.pipe gulp.dest "src/built_temp/"


	gulp.task "templates:prebuild", [ "templates:prebuild-body" ], ->
		gulp.src "src/template/marqdown.jade"
			.pipe pug(locals: {debug: options.debug})
			.pipe gulp.dest "src/built_temp/"


	gulp.task "templates:body", [ "styles:postprocess" ], ->
		gulp.src "src/template/body.jade"
			.pipe pug(locals: {debug: options.debug})
			.pipe gulp.dest "src/built_temp/"


	gulp.task "templates:compress", [ "templates:body" ], ->
		if options.compressBody
			data = fs.readFileSync("src/built_temp/body.html", "utf8")
			compressed = lzstr.compressToBase64 data
			script = """<script type="text/javascript">"""
			script += (fs.readFileSync("node_modules/lz-string/libs/lz-string.min.js", "utf8")).slice(0,-1)
			script += """;document.write(LZString.decompressFromBase64(\"#{compressed}\"));</script>"""
			fs.writeFileSync("src/built_temp/body.html", script, "utf8")


	gulp.task "templates", [ "templates:compress" ], ->
		gulp.src "src/template/marqdown.jade"
			.pipe pug(locals: {debug: options.debug})
			.pipe gulp.dest "dist/"
