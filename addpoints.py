#!/usr/bin/env python

"""
Pandoc filter to calculate the total number of points in homework sheets. 
This mimics the behaviour of the LaTeX exam class to some extend.

To create questions, we use level 1 or 2 headers (like the `\titledquestion` 
in the exam class). The number of points for a task or question are assigned 
as key-value-pair in the header attributes, where the key would be the string 
"punkte" and the value the number of points (integer value).

Example:

```markdown
# Task A {punkte=42}
Blablabla
```

shall be equivalent to 

```latex
\titledquestion{Task A}[42]
Blablabla
```

when using the exam class.

This filter searches all headers for a "punkte"/int pair. If found, it will
a.  append the string " (<int> Punkte)" to the header,
b.  add the total number of points (so far), and
c.  in case there is a meta field named "points", it will set the total number 
    of points as value for this field

Thus we can use a variable "points" in the pandoc template, which provides 
access to the total number of points for the given homework sheet.
"""

from pandocfilters import walk, Str, Space, Header, RawInline
import re


import codecs
import io
import json
import os
import sys



points = 0

def addpoints(key, value, format, meta):
    global points
    if key == 'Header':
        [level, [ident,classes,keyvals], content] = value
        p = [int(v) for [k,v] in keyvals if k=="punkte"]
        if p:
            p = reduce(lambda x,y: x+y, p)
            points += p
            
            content += [Space(), RawInline("tex", "\\hfill"), Space(), Str("("+str(p)+" Punkte)")]
                    
        return Header(level, [ident,classes,keyvals], content)    


def toJSONFilters(action):
    try:
        input_stream = io.TextIOWrapper(sys.stdin.buffer, encoding='utf-8')
    except AttributeError:
        input_stream = codecs.getreader("utf-8")(sys.stdin)

    doc = json.loads(input_stream.read())
    if len(sys.argv) > 1:
        format = sys.argv[1]
    else:
        format = ""

    altered = walk(doc, action, format, doc[0]['unMeta'])

    global points
    sys.stderr.write(str(altered[0]['unMeta']['points']) + '\n\n')
    altered[0]['unMeta']['points'] = {'t':'MetaInlines', 'c':[Str(str(points)),]}
    
    json.dump(altered, sys.stdout)


if __name__ == "__main__":
    toJSONFilters(addpoints)
    
