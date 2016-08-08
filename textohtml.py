#!/usr/bin/env python

"""
Pandoc filter to replace certain LaTeX macros with matching HTML tags.

In my beamer slides I use certain macros like `\blueArrow` which produces an 
arrow in deep blue color. This filter translates this TeX macros into the 
corresponding HTML markup. 

Note, that the `html.css` must also be included in the template for proper
rendering.
"""

from pandocfilters import toJSONFilter, attributes, Span, Str, Space, RawInline, Image
import re

trans = [{'class': 'blueArrow', 're': re.compile('\\\\blueArrow'), 'cont': "=>", 'key': 'Str'}, 
         {'class': 'alert', 're': re.compile('\\\\alert\{(.*)\}$'), 'cont': 1, 'key': 'Grp'}, 
         {'class': 'Alert', 're': re.compile('\\\\Alert\{(.*)\}$'), 'cont': 1, 'key': 'Grp'}, 
         {'class': 'code', 're': re.compile('\\\\code\{(.*)\}$'), 'cont': 1, 'key': 'Grp'}, 
         {'class': 'bsp', 're': re.compile('\\\\bsp\{(.*)\}$'), 'cont': 1, 'key': 'Grp'}]
cboxStart = re.compile('\\\\cboxbegin')
cboxEnd   = re.compile('\\\\cboxend')
image     = re.compile('\\\\includegraphics.*?\{(.*)\}$')

def textohtml(key, value, format, meta):
    if key == 'RawInline':
        fmt, s = value
        if fmt == "tex":
            for x in trans:
                m = x['re'].match(s)
                if m:
                    return [Span(attributes({'class': x['class']}), 
                                 [Str( x['cont'] if x['key']=='Str' else m.group(x['cont']) )]),
                            Space()]
            if cboxStart.match(s):
                return RawInline("html", "<span class='cbox'>")
            if cboxEnd.match(s):
                return RawInline("html", "</span>")
            if image.match(s):
                m = image.match(s)
                return Image([Str("description")], [m.group(1),""])

if __name__ == "__main__":
    toJSONFilter(textohtml)
    
