alight.debug.scan      = false
alight.debug.directive = false
alight.debug.parser    = false
alight.debug.watch     = false
alight.debug.watchText = false


alight.directives.al.codemirror = (scope, elem, exp) ->
	ls = window.localStorage
	options = scope.$getValue exp || {}
	initValue = ls['marqdown.lastSession'] || elem.innerHTML
	if initValue
		options.codeMirror.placeholder = elem.innerHTML
		options.codeMirror.value = initValue
		options.source = initValue
		# reset innerHTML of the element to
		# force the editor initialization value
		# if there was a last session
		elem.innerHTML = initValue

	if elem.tagName is "TEXTAREA"
		cm = CodeMirror.fromTextArea elem, options.codeMirror
	else
		cm = CodeMirror elem, options.codeMirror

	# load history if there is some history in localstorage
	if ls['marqdown.history'] and ls['marqdown.history'] isnt ""
		cm.clearHistory()
		cm.setHistory(JSON.parse(ls['marqdown.history']))

	scope.$scan()

	updatingContent = false

	scope.$watch exp + ".source", (value) ->
		return if updatingContent
		updatingContent = true
		cm.setValue(value)
		updatingContent = false

	cm.on "change", ->
		return if updatingContent
		updatingContent = true
		currentValue = cm.getValue()
		scope.$setValue exp + ".source", currentValue
		ls['marqdown.lastSession'] = currentValue if typeof currentValue is "string"
		ls['marqdown.history'] = JSON.stringify cm.getHistory()
		scope.$scan -> updatingContent = false

	scrolling = false

	scope.$watch exp + ".scrollOffset", (value) ->
		return if scrolling
		scrolling = true
		scrollOffset = cm.getScrollInfo()
		absolute = value * (scrollOffset.height - scrollOffset.clientHeight + 1)
		cm.scrollTo(null, absolute)
		alight.nextTick -> scrolling = false

	cm.on "scroll", ->
		return if scrolling
		scrolling = true
		scrollOffset = cm.getScrollInfo()
		relativeScrollOffset = (scrollOffset.height - scrollOffset.clientHeight + 1)
		percent = (scrollOffset.top / relativeScrollOffset).toFixed(3)
		scope.$setValue exp + ".scrollOffset", percent
		scope.$scan -> scrolling = false


alight.directives.al.markdown = (scope, elem, exp) ->
	scope.$watch exp, (value) ->
		elem.innerHTML = marked value or ""
	, { readOnly: true }


alight.directives.al.syncscroll = (scope, elem, exp) ->
	self =
		changing: false
		onDom: ->
			alight.f$.on elem, 'scroll', self.updateModel
			scope.$watch '$destroy', self.offDom
		offDom: ->
			alight.f$.off elem, 'scroll', self.updateModel
		updateModel: ->
			self.changing = true
			relativeScrollOffset = (elem.scrollHeight - elem.clientHeight + 1)
			percent = (elem.scrollTop / relativeScrollOffset).toFixed(3)
			scope.$setValue exp, percent
			scope.$scan ->
				self.changing = false
		watchModel: ->
			scope.$watch exp, self.updateDom,
				readOnly: true
		updateDom: (value) ->
			if self.changing
				return
			value ?= 0
			elem.scrollTop = value * (elem.scrollHeight - elem.clientHeight + 1)
		start: ->
			self.onDom()
			self.watchModel()
