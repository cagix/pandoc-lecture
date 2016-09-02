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
access to the total number of points for the given homework sheet. If the
variable does not exist in the document, its value won't be set by this filter,
and the template won't show the string "(0 Punkte)" ...

The contents of the headers together with the resp. points will be collected in
a list and written to the meta data field `questions`. This allows to access
the questions from templates.


Note: This filter uses a customized version of the `toJSONFilter` function from
the pandocfilters package since we need to alter the metadata of the document
*after* parsing and modifying the document.
The alternative would be use two runs of the filter and to write the total
number of points to a temporary file in the first run and reading it in the
second run of the filter.
Changing the metadata during the `walk` function (i.e. changing the `meta`
parameter within an action function) doesn't have any impact on the document
itself.
"""

from pandocfilters import walk, Str, Space, Header, RawInline
import re

import codecs
import io
import json
import os
import sys


points = 0
questions = []

def addpoints(key, value, format, meta):
    global points
    if key == 'Header':
        [level, [ident,classes,keyvals], content] = value
        p = [int(v) for [k,v] in keyvals if k=="punkte"]
        if p:
            p = reduce(lambda x,y: x+y, p)
            points += p
            questions.append(content + [Space(), Str("("+str(p)+"P)")])
            content += [Space(), RawInline("tex", "\\hfill"), Space(),
                        Str("("+str(p)), Space(), Str("Punkte)")]

        return Header(level, [ident,classes,keyvals], content)


def setPointsMetadata(document):
    global points

    field = document[0]['unMeta'].get("points", {})
    if field and field["t"]:
        if "MetaInlines" in field["t"]:
            checkPoints(field["c"][0]["c"], points)
            field["c"] = [Str(str(points)),]
        elif "MetaString" in field["t"]:
            checkPoints(field["c"], points)
            field["c"] = str(points)

    return document


def setQuestionMetadata(document):
    global questions

    # add a question meta data field ...
    q = [{"t":"MetaInlines","c":c} for c in questions]
    document[0]['unMeta']["questions"] = {"t":"MetaList","c":q}

    return document


def checkPoints(pstr, points):
    try:
        if int(pstr) != points:
            sys.stderr.write('\n\n' + "Expected " + pstr + " points.\n")
            sys.stderr.write("Found " + str(points) + " points!" + '\n\n\n')
    except ValueError:
        # pstr did not contain a number ... do nothing
        pass


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
    altered = setPointsMetadata(altered)
    altered = setQuestionMetadata(altered)

    json.dump(altered, sys.stdout)


if __name__ == "__main__":
    toJSONFilters(addpoints)


