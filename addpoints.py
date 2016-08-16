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

from pandocfilters import toJSONFilter, Str, Space, Header, RawInline
import re

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
            
            field = meta.get("points", {})
            if field:
                if "MetaInlines" in field["t"]:
                    field["c"] = [Str(str(points)),]
                elif "MetaString" in field["t"]:
                    field["c"] = Str(str(points))  
                 
        return Header(level, [ident,classes,keyvals], content)    


if __name__ == "__main__":
    toJSONFilter(addpoints)
    
