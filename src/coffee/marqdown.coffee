class MarqDown

	# static function to change headline style with hotkeys
	@cmHeadline: (cm, headline) ->
		cursor = cm.getCursor("from")
		line = cm.getLine(cursor.line)
		startPos = {line: cursor.line, ch: 0}
		endPos = {line: cursor.line, ch: line.match(/^(?:#|>)*\s*/)[0].length}
		cm.replaceRange(headline, startPos, endPos)

	data: {
		codeMirror: {
			mode: "markdown"
			theme: "marqdown"
			lineNumbers: true
			lineWrapping: true
			styleActiveLine: true
			foldGutter: true
			gutters: ["CodeMirror-linenumbers", "CodeMirror-foldgutter"]
			matchBrackets: true
			autoCloseBrackets: true
			extraKeys: {
				"Enter": "newlineAndIndentContinueMarkdownList"
				"Ctrl-1": (cm) -> MarqDown.cmHeadline(cm, "# ")
				"Ctrl-2": (cm) -> MarqDown.cmHeadline(cm, "## ")
				"Ctrl-3": (cm) -> MarqDown.cmHeadline(cm, "### ")
				"Ctrl-4": (cm) -> MarqDown.cmHeadline(cm, "#### ")
				"Ctrl-5": (cm) -> MarqDown.cmHeadline(cm, "##### ")
				"Ctrl-6": (cm) -> MarqDown.cmHeadline(cm, "###### ")
				"Ctrl-0": (cm) -> MarqDown.cmHeadline(cm, "")
				"Ctrl-Q": (cm) -> MarqDown.cmHeadline(cm, "> ")
				"Ctrl-I": (cm) ->
					sel = cm.getSelection()
					cm.replaceSelection "*" + sel + "*"
				"Ctrl-B": (cm) ->
					sel = cm.getSelection()
					cm.replaceSelection "**" + sel + "**"
				"Ctrl-O": (cm) ->
					sel = cm.getSelection()
					cm.replaceSelection "~~" + sel + "~~"
				"Ctrl-K": (cm) ->
					sel = cm.getSelection()
					cm.replaceSelection "`" + sel + "`", "around"
				"Ctrl-H": (cm) ->
					cursor = cm.getCursor()
					cm.replaceRange("\n---\n\n", {line: cursor.line, ch: 0})
				"Ctrl-L": (cm) ->
					cursor = cm.getCursor()
					sel = cm.getSelection()
					if sel.match(/^(http|\/\/|ftp|mailto)/)
						cm.replaceSelection "[](#{sel})"
						cm.setCursor {line: cursor.line, ch: cursor.ch + 1}
					else if sel.length > 0
						cm.replaceSelection "[#{sel}]()"
						cm.execCommand "goColumnLeft"
					else
						cm.replaceSelection "[]()"
						cm.setCursor {line: cursor.line, ch: cursor.ch + 1}
			}
		}

		source: ""
		scrollOffset: 0

	}

	copyrightYear: (new Date()).getUTCFullYear()


	constructor: () ->
		marked.setOptions(
			gfm: true
			tables: true
			breaks: true
			pedantic: false
			sanitize: true
			smartLists: true
			smartypants: true
			highlight: (code, lang) ->
				if code and lang
					mode = lang
					mode = "clike" if lang in [
						"c"
						"c++"
						"objectivec"
						"objective-c"
						"c#"
						"csharp"
					]
					mode = "htmlmixed" if lang is "html"
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


	onDownloadPortable: (event) ->
		if event.target.nodeName isnt "A"
			return
		if event.target.hash isnt "#download-portable"
			return
		doc = document.cloneNode(true)
		doc.querySelector('head style').remove()
		doc.querySelector('#app').remove()
		html = "<!doctype html>" + doc.documentElement.outerHTML
		event.target.href = "data:text/html;charset=utf-8," + encodeURIComponent(html)
		event.target.download = "marqdown.html"


	onDownloadHTML: (event) =>
		convertedSource = marked @data.source
		html  = """<html><head><meta charset="utf-8"/></head>"""
		html += """<body>#{convertedSource}</body></html>"""
		encoded = encodeURIComponent("<!doctype html>\n" + @prettyPrintXML(html))
		event.target.href = "data:text/html;charset=utf-8," + encoded


	onUploadMarkdown: (event) =>
		try
			for file in event.target.files
				if file.size > 5 * 1024 * 1024
					throw new Error("Filesize greater than 5MB.")
				if file.type not in [
					"text/plain"
					"text/css"
					"text/html"
					"application/xml"
					"application/markdown"
				]
					throw new Error("Not supported file type")

				reader = new FileReader()
				reader.readAsText(file, "UTF-8")
				reader.onerror = (e) -> throw new Error("Error reading file.")
				reader.onload  = (e) =>
					@data.source = e.target.result
					@$scan()
		catch e
			alert e


	onDownloadMarkdown: (event) =>
		encoded = encodeURIComponent(@data.source)
		event.target.href = "data:application/markdown;charset=utf-8," + encoded



alight.ctrl.marqdown = MarqDown
alight.bootstrap document.getElementById "app"
