gulp = require "gulp"
fs = require "fs"

# config.json defines a configuration for the gulp tasks
options =
	buildDir: "./buildtasks/"
	debug: false
	compressBody: true

for task in fs.readdirSync(options.buildDir)
	taskInstance = require options.buildDir + task
	taskInstance(gulp, options)

gulp.task "pre-build", [ "scripts:libs" ]

# define default task
gulp.task "default", [ "templates" ], ->
	gulp.watch [
		"README.md"
		"src/**"
		"!src/built_temp/**"
	], ["templates"]
