#!/usr/bin/env python

"""
Pandoc filter to remove lecture notes from beamer slides.

In my beamer slides I use the `\notesbegin` and `\notesend` "commands" to 
declare content, which should not be included in the slide deck but in the 
handout. This filter removes the commands and the content in between.

The begin and end "commands" need to be separated from the text by blank lines
before and after the "command".
"""

from pandocfilters import toJSONFilter
import re

notesStart = re.compile('\\\\notesbegin')
notesEnd   = re.compile('\\\\notesend')

content = False

def texnotes(key, value, format, meta):
    global content
    if key == 'Para' and isinstance(value, list) and len(value) == 1:
        item = value[0]
        if isinstance(item, dict) and 't' in item:
            if item["t"] == 'RawInline':
                fmt, s = item["c"]
                if fmt == "tex":
                    if notesStart.search(s):
                        content = True
                        return []
                    elif notesEnd.search(s):
                        content = False
                        return []
    if content:
        return []

if __name__ == "__main__":
    toJSONFilter(texnotes)
    
