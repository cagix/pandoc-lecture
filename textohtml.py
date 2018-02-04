#!/usr/bin/env python

# Author: Carsten Gips <carsten.gips@fh-bielefeld.de>
# Copyright: (c) 2016 Carsten Gips
# License: MIT


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

trans = [{'class': 'blueArrow', 're': re.compile('\\\\blueArrow'), 'cont': "=>", 'key': 'Str'}]
cboxStart = re.compile('\\\\cboxbegin')
cboxEnd   = re.compile('\\\\cboxend')

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



if __name__ == "__main__":
    toJSONFilter(textohtml)

