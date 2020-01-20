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

	constructor: () ->

		@preparePortableDownload()

		marked.setOptions(
			gfm: true
			tables: true
			breaks: true
			pedantic: false
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

		document.querySelector('#copyrightYear').innerHTML = (new Date()).getUTCFullYear()

		elem = document.querySelector('#source-container textarea')
		@preview = document.querySelector('#preview')
		@previewContainer = document.querySelector('#preview-container')
		ls = window.localStorage
		options = @data
		initValue = ls['marqdown.lastSession'] || elem.innerHTML
		if initValue
			options.codeMirror.placeholder = elem.innerHTML
			options.codeMirror.value = initValue
			# reset innerHTML of the element to
			# force the editor initialization value
			# if there was a last session
			elem.innerHTML = initValue
			@data.source = initValue
			@preview.innerHTML = marked initValue

		@cm = cm = CodeMirror.fromTextArea elem, options.codeMirror

		# load history if there is some history in localstorage
		if ls['marqdown.history'] and ls['marqdown.history'] isnt ""
			cm.clearHistory()
			cm.setHistory(JSON.parse(ls['marqdown.history']))

		@registerEventHandlers()


	registerEventHandlers: () =>
		listener = (elem, event, handler) -> document.querySelector(elem).addEventListener(event, handler)
		listener '#download-portable', 'focus', @onDownloadPortable
		listener '#download-markdown', 'focus', @onDownloadMarkdown
		listener '#download-html', 'focus', @onDownloadHTML
		listener '#upload-markdown input', 'change', @onUploadMarkdown

		@cm.on "change", =>
			currentValue = @cm.getValue()
			ls = window.localStorage
			ls['marqdown.lastSession'] = currentValue if typeof currentValue is "string"
			ls['marqdown.history'] = JSON.stringify @cm.getHistory()
			@data.source = currentValue
			@preview.innerHTML = marked currentValue or ""

		debounce = null
		@cm.on "scroll", =>
			window.cancelAnimationFrame(debounce) if debounce
			debounce = window.requestAnimationFrame () =>
				scrollOffset = @cm.getScrollInfo()
				relativeScrollOffset = (scrollOffset.height - scrollOffset.clientHeight + 1)
				percent = (scrollOffset.top / relativeScrollOffset).toFixed(3)
				@previewContainer.scrollTop = percent * (@previewContainer.scrollHeight - @previewContainer.clientHeight + 1)

		listener '#preview-container', 'scroll', (event) =>
			window.cancelAnimationFrame(debounce) if debounce
			debounce = window.requestAnimationFrame () =>
				elem = event.target
				relativeScrollOffset = (elem.scrollHeight - elem.clientHeight + 1)
				percent = (elem.scrollTop / relativeScrollOffset).toFixed(3)
				scrollOffset = @cm.getScrollInfo()
				absolute = percent * (scrollOffset.height - scrollOffset.clientHeight + 1)
				@cm.scrollTo(null, absolute)


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


	preparePortableDownload: =>
		doc = document.cloneNode(true)
		doc.querySelector('#app').remove()
		html = "<!DOCTYPE html>" + doc.documentElement.outerHTML
		@data.portableDownload = html


	onDownloadPortable: (event) =>
		if event.target.nodeName isnt "A"
			return
		if event.target.hash isnt "#download-portable"
			return
		event.target.href = "data:text/html;charset=utf-8," + encodeURIComponent(@data.portableDownload)
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
					"text/markdown"
					"application/xml"
					"application/markdown"
				]
					throw new Error("Not supported file type")

				reader = new FileReader()
				reader.readAsText(file, "UTF-8")
				reader.onerror = (e) -> throw new Error("Error reading file.")
				reader.onload  = (e) =>
					@cm.setValue e.target.result
		catch e
			alert e


	onDownloadMarkdown: (event) =>
		encoded = encodeURIComponent(@data.source)
		event.target.href = "data:application/markdown;charset=utf-8," + encoded



new MarqDown()
