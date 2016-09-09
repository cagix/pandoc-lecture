#!/usr/bin/env python

# Author: Carsten Gips <carsten.gips@fh-bielefeld.de>
# Copyright: (c) 2016 Carsten Gips
# License: MIT


"""
Pandoc filter to remove lecture notes from beamer slides.

In my beamer slides I use the `\notesbegin` and `\notesend` "commands" to
declare content, which should not be included in the slide deck but in the
handout. This filter removes the commands and the content in between.

The begin and end "commands" need to be separated from the text by blank lines
before and after the "command".

If you don't start a new block (paragraph, bullet point list, ...) in the notes
environment (any inline elements from [pandocfilters](https://github.com/jgm/pandocfilters.git)
should work), the start and end commands need not to appear on their own
paragraph.

Also `\notes` will toggle the notes environment, i.e. open or close notes.


Examples:

```
This should work
----------------

*   Lorem ipsum dolor sit amet, consetetur sadipscing elitr,
*   sed diam nonumy eirmod tempor invidunt ut labore et dolore
    \notesbegin
    HERE IS AN EXTRA NOTE (appearing in the same paragraph)
    \notesend
    continuing same paragraph (bullet point)
*   magna aliquyam erat, sed diam voluptua.

Well, inline code like `int main()` works too :)

\notesbegin

Text between `\notesbegin` and `\notesend` will not appear in slides,
but in the handout (HTML, EPUB, PDF).

You can use here Markdown and/or LaTeX :)


Even sections will work.
------------------------

Told you :)

### Section Level 3

wuppie fluppie

#### Section Level 4

foo bar ...

[www.fh-bielefeld.de](http://www.fh-bielefeld.de)

\notesend

\bsp{Eclipse}
```

```
This probably won't work
------------------------

*   Lorem ipsum dolor sit amet, consetetur sadipscing elitr,
*   sed diam nonumy eirmod tempor invidunt ut labore et dolore
    \notesbegin
    HERE IS AN EXTRA NOTE (appearing in the same paragraph)

    start something new, i.e. a paragraph ... WON'T WORK!
    \notesend
    continuing same paragraph (bullet point)
*   magna aliquyam erat, sed diam voluptua.

```

"""

from pandocfilters import toJSONFilter
import re

notesStart = re.compile('\\\\notesbegin')
notesEnd   = re.compile('\\\\notesend')
notes      = re.compile('\\\\notes')

content = False


def texnotes(key, value, format, meta):
    global content

    if key == 'Para' and isinstance(value, list) and len(value) == 1:
        # handle '\notesbegin' and '\notesbegin' appearing in its own paragraph
        item = value[0]
        if isinstance(item, dict) and 't' in item:
            if item["t"] == 'RawInline':
                return filternotes(item["c"])
    elif key == 'RawInline':
        # handle '\notesbegin' and '\notesbegin' appearing in the same paragraph
        return filternotes(value)

    return returncontent()


def filternotes(value):
    global content

    fmt, s = value
    if fmt == "tex":
        if notesStart.search(s):
            content = True
            return []
        elif notesEnd.search(s):
            content = False
            return []
        elif notes.search(s):
            content = not content
            return []

    return returncontent()


def returncontent():
    global content

    if content:
        return []



if __name__ == "__main__":
    toJSONFilter(texnotes)

