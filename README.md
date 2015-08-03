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
	- one single standalone html file, no further dependencies
	- [download it](#download-portable) to an usb drive and run it from there
	- No network connection required
	- no data is stored or transferred, so your data are private
	- less than 230kB due to hard compression
- Importing of existing Markdown files
- File download of Markdown and generated and prettyfied HTML
- Synchronous Scrolling for long files
- Partial support for mobile devices, that's the reason why the editor is above the preview

## FAQ

###### How to do the right markup for ....?
This application uses the [marked](https://github.com/chjj/marked) library to convert markdown to html.
It utilises the markup syntax from [github flavored markdown](https://help.github.com/articles/github-flavored-markdown/) where you also will find some [basic examples](https://help.github.com/articles/markdown-basics/).
If you need the full reference, visit [John Gruber's site](https://daringfireball.net/projects/markdown/).
Syntax highlighting for code blocks is not implemented.

###### Why is the input editor on the right side?
Typically people who read from left to right look to the left side first.
So it lets you focus on the result, not on your code.

###### Why is browser XY not supported?
This application implements modern web technologies.
Older browsers which cannot run this app are loosers.
Recommendation: use a newer browser.

###### Can you please implement feature XY?
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

Thanks to the developers of the following software:
- [Bootstrap](http://getbootstrap.com/)
- [Bootswatch](http://bootswatch.com/)
- [Angular Light](http://angularlight.org/)
- [CodeMirror](http://codemirror.net/)
- [marked](https://github.com/chjj/marked)
- [Coffee-Script](http://coffeescript.org/)
- [LessCSS](http://lesscss.org/)
- [UnCSS](https://github.com/giakki/uncss)
- [gulp](http://gulpjs.com/)
- [lz-string](https://github.com/pieroxy/lz-string)
- [Ubuntu Font Family](https://www.google.com/fonts#UsePlace:use/Collection:Ubuntu)

## Changelog

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