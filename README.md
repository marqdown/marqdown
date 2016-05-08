# marqdown

###### a portable markdown editor with an on-the-fly preview.

|Table of Contents|
|--:|
|[Features](#features)|
|[FAQ](#faq)|
|[Development](#development)|
|[Changelog](#changelog)|
|[License](#license)|

## Features

- Portable Edition
	- One single standalone html file, no further dependencies
	- [Download it](#download-portable) to an usb drive and run it from there
	- No network connection required
	- No data is transferred, so your data are private
	- only ~300kB due to hard compression
	- Syntax highlighting for code blocks
- Importing of existing Markdown files
- File download of Markdown and generated and prettyfied HTML
- Synchronous Scrolling for long files
- Using localStorage to restore last data if you lost your current browser session
- Partial support for mobile devices, that's the reason why the editor is above the preview
- Inline Syntax highlighting for
	- coffeescript
	- markdown
	- css
	- html
	- javascript
	- perl
	- php
	- c, c++, objectivec, objective-c, c#, csharp // also known as 'clike'
	- python
	- sql
	- xml
- Hotkeys
	- **Bold**: CTRL + B
	- *Emphasis*: CTRL + I
	- ~~Strike through~~: CTRL + O
	- H1 to H6: CTRL + 1 to CTRL + 6
	- Convert headline to paragraph: CTRL + 0
	- Insert Link: CTRL + L
	- Insert Code: CTRL + K
	- Insert horizontal rule: CTRL + H
	- Insert blockquote: CTRL + Q

## FAQ

#### How to do the right markup for ....?
This application uses the [marked](https://github.com/chjj/marked) library to convert markdown to html.
It utilises the markup syntax from [github flavored markdown](https://help.github.com/articles/github-flavored-markdown/) where you also will find some [basic examples](https://help.github.com/articles/markdown-basics/).
If you need the full reference, visit [John Gruber's site](https://daringfireball.net/projects/markdown/).

#### Why is the input editor on the right side?
Typically people who read from left to right look to the left side first.
So it lets you focus on the result, not on your code.

#### Why is browser XY not supported?
This application implements modern web technologies.
Older browsers which cannot run this app are loosers.
Recommendation: use a newer browser.

#### Can you please implement feature XY?
~~No!~~ 
Please implement it yourself and send me a pull request.
Pull Requests will only accepted if they adapt current source structure and code style.

## Development

Before install, make sure you have installed bower, npm and gulp globally.

To begin with development, just type
```
npm install
bower install
make
```
in console.

```make``` runs a gulp task that sets up some file watchers so you can just modify the source files
and everything will be compiled together automatically.

The compiled file contains the following resources:
- JavaScript (marked, Angular Light, CodeMirror)
- Compiled and uncss'd CSS
- Embedded Ubuntu Font

Embedded into the application are sources from the following software:
- [Bootstrap](http://getbootstrap.com/) [(MIT-License)](https://github.com/twbs/bootstrap/blob/master/LICENSE)
- [Bootswatch](http://bootswatch.com/) [(MIT-License)](https://github.com/thomaspark/bootswatch/blob/gh-pages/LICENSE)
- [Angular Light](http://angularlight.org/) [(MIT-License)](https://github.com/lega911/angular-light/blob/master/LICENSE)
- [CodeMirror](http://codemirror.net/) [(MIT-License)](https://github.com/codemirror/CodeMirror/blob/master/LICENSE)
- [marked](https://github.com/chjj/marked) [(MIT-License)](https://github.com/chjj/marked/blob/master/LICENSE)
- [lz-string](https://github.com/pieroxy/lz-string) [(WTFPL)](https://github.com/pieroxy/lz-string/blob/master/LICENSE.txt) 
- [Ubuntu Font Family](https://www.google.com/fonts#UsePlace:use/Collection:Ubuntu) [(Ubuntu Font License)](http://font.ubuntu.com/licence/)

Also thanks to the developers of the following software:
- [Coffee-Script](http://coffeescript.org/)
- [LessCSS](http://lesscss.org/)
- [Autoprefixer](https://github.com/postcss/autoprefixer)
- [UnCSS](https://github.com/giakki/uncss)
- [gulp](http://gulpjs.com/)

## Changelog

V1.6.3, 08. May 2016:
- fixed style whitelist for uncss
- using autoprefixer

V1.6.2, 14. Apr 2016:
- added localStorage persistence layer to keep data
- improved horizontal rule hotkey
- fixed style whitelist for uncss

V1.6.1, 10. Apr 2016:
- bugfixes

V1.6.0, 10. Apr 2016:
- added viewport meta tag
- added hotkeys
- bugfixes
- improved documentation

V1.5.0, 08. Apr 2016:
- enabled codemirror bracket highlighting and bracket auto close plugins

V1.4.3, 07. Apr 2016:
- fixed copyright date

V1.4.2, 07. Apr 2016:
- updated all bower and npm dependencies to current versions and fixed bugs

V1.4.1, 22. Aug 2015:
- improved choppy animation in firefox: force to use hardware acceleration using a very small rotation around Y axis

V1.4, 09. Aug 2015:
- fixed animation to be activated only on h1 element
- fixed lost table styles
- added syntax highlighting for several popular languages

V1.3, 09. Aug 2015:
- fixed scrolling bug in webkit
- fixed placeholder
- added prefixes for animation keyframes for older browsers (especially webkit)
- improved font sizes and font weight of headlines
- added license information for embedded sources

V1.2, 03. Aug 2015:
- fixed lost styles on headlines due to uncss

V1.1, 03. Aug 2015:
- Implemented inline compression using [lz-string](https://github.com/pieroxy/lz-string) to compress the whole body tag down to less than 230kB!

V1.0, 02. Aug 2015:
- Initial commit

## License

The MIT License (MIT)

Copyright (c) 2015 Reiner Kempkes

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.