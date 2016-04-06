class marqdown

	data: {
		codeMirror: {
			mode: "markdown"
			theme: "marqdown"
			lineNumbers: true
			lineWrapping: true
			styleActiveLine: true
			foldGutter: true
			gutters: ["CodeMirror-linenumbers", "CodeMirror-foldgutter"]
		}

		source: ""
		scrollOffset: 0
	}


	constructor: () ->
		marked.setOptions(
			gfm: true
			tables: true
			breaks: true
			pedantic: true
			sanitize: true
			smartLists: true
			smartypants: true
			highlight: (code, lang) ->
				if code and lang
					mode = lang
					mode = "clike" if lang in ["c", "c++", "objectivec", "objective-c", "c#", "csharp"]
					targetNode = document.createElement "div"
					CodeMirror.runMode code, mode, targetNode
					code = targetNode.innerHTML
				return code
		)


	prettyPrintXML: (xml) ->
		formatted = ""
		reg = /(>)(<)(\/*)/g
		xml = xml.toString().replace(reg, '$1\n$2$3').replace("\r", "\n")
		pad = 0
		nodes = xml.split('\n')
		for n of nodes
			node = nodes[n]
			indent = 0
			if node.match(/.+<\/\w[^>]*>$/)
				indent = 0
			else if node.match(/^<\/\w/)
				if pad != 0
					pad -= 1
			else if node.match(/^<\w[^>]*[^\/]>.*$/)
				indent = 1
			else
				indent = 0
			padding = ""
			i = 0
			while i < pad
				padding += "\t"
				i++
			formatted += padding + node + "\r\n"
			pad += indent
		formatted


	onDownloadPortable: (event) =>
		if event.target.nodeName isnt "A"
			return
		if event.target.hash isnt "#download-portable"
			return
		doc = document.cloneNode(true)
		doc.querySelector('head style').remove()
		doc.querySelector('#page').remove()
		doc.querySelector('#marqdown-styles').remove()
		doc.querySelector('#marqdown-scripts').remove()
		html = "<!DOCTYPE html>" + doc.documentElement.outerHTML
		event.target.href = "data:text/html;charset=utf-8," + encodeURIComponent(html)
		event.target.download = "marqdown.html"


	onDownloadHTML: (event) =>
		convertedSource = marked @data.source
		html = """<html><head><meta charset="utf-8" /></head><body>#{convertedSource}</body></html>"""
		event.target.href = "data:text/html;charset=utf-8," + encodeURIComponent("<\!doctype html>\n" + @prettyPrintXML(html))


	onUploadMarkdown: (event) =>
		try
			for file in event.target.files
				if file.size > 5 * 1024 * 1024
					throw "Filesize greater than 5MB."
				if file.type not in ["text/plain", "text/css", "text/html", "application/xml", "application/markdown"]
					throw "Not supported file type"
				reader = new FileReader()
				reader.readAsText(file, "UTF-8")
				reader.onerror = (e) => throw "Error reading file."
				reader.onload  = (e) =>
					@data.source = e.target.result
					@$scan()
		catch e
			alert e


	onDownloadMarkdown: (event) =>
		event.target.href = "data:application/markdown;charset=utf-8," + encodeURIComponent(@data.source)



alight.ctrl.marqdown = marqdown
alight.bootstrap document.getElementById "app"