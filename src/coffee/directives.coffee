alight.debug.scan      = false
alight.debug.directive = false
alight.debug.parser    = false
alight.debug.watch     = false
alight.debug.watchText = false


alight.directives.al.codemirror = (element, exp, scope) ->
	options = scope.$getValue exp || {}
	initValue = element.innerHTML
	if initValue
		options.codeMirror.placeholder = initValue
		options.codeMirror.value = initValue
		options.source = initValue

	if element.tagName is "TEXTAREA"
		cm = CodeMirror.fromTextArea element, options.codeMirror
	else
		cm = CodeMirror element, options.codeMirror

	scope.$scan()

	updatingContent = false

	scope.$watch exp + ".source", (value) ->
		return if updatingContent
		updatingContent = true
		cm.setValue(value)
		updatingContent = false
	, { init: true }

	cm.on "change", ->
		return if updatingContent
		updatingContent = true
		scope.$setValue exp + ".source", cm.getValue()
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
		percent = (scrollOffset.top / (scrollOffset.height - scrollOffset.clientHeight + 1)).toFixed(3)
		scope.$setValue exp + ".scrollOffset", percent
		scope.$scan -> scrolling = false


alight.directives.al.markdown = (element, variable, scope) ->
	scope.$watch variable, (value) ->
		f$.html element, marked value or ""
	,
		readOnly: true
		init: true


alight.directives.al.syncscroll = (element, variable, scope) ->
	self =
		changing: false
		onDom: ->
			alight.f$.on element, 'scroll', self.updateModel
			scope.$watch '$destroy', self.offDom
		offDom: ->
			alight.f$.off element, 'scroll', self.updateModel
		updateModel: ->
			self.changing = true
			percent = (element.scrollTop / (element.scrollHeight - element.clientHeight + 1)).toFixed(3)
			scope.$setValue variable, percent
			scope.$scan ->
				self.changing = false
		watchModel: ->
			scope.$watch variable, self.updateDom,
				readOnly: true
		updateDom: (value) ->
			if self.changing
				return
			value ?= 0
			element.scrollTop = value * (element.scrollHeight - element.clientHeight + 1)
		start: ->
			self.onDom()
			self.watchModel()