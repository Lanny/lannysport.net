#!/usr/bin/env python
import re

"""
Pandoc filter to prettyify written fractions.
"""

from pandocfilters import toJSONFilter, Plain

sup_map = [
    '\u2070', '\u00B9', '\u00B2', '\u00B3', '\u2074', '\u2075', '\u2076',
    '\u2077', '\u2078', '\u2079',
]

common_map = {
    (1,2): chr(189),
    (1,3): chr(8531),
    (2,3): chr(8532),
    (1,4): chr(188),
    (3,4): chr(190),
}

def sub(dstr):
    dstr = str(dstr)
    return ''.join([chr(8320 + int(i)) for i in dstr])

def sup(dstr):
    dstr = str(dstr)
    return ''.join(sup_map[int(i)] for i in dstr)

def fractionalize(unformatted_str):
    left, right = [int(i) for i in re.match(r'(\d+)/(\d+)', unformatted_str).groups()]
    pair = (left, right)

    if pair in common_map:
        return common_map[pair]

    return '%s\u2044%s' % (sup(left), sub(right))

def preffyify_fractions(key, value, format, meta):
    if key == 'Plain':
        modified_value = value[:]
        for tidx, token in enumerate(modified_value):
            if token['t'] != 'Str':
                continue

            content = token['c']
            split = re.split(r'(\d+/\d+)', content)
            if len(split) > 1:
                for idx, part in enumerate(split):
                    if idx % 2:
                        split[idx] = fractionalize(part)

                token['c'] = ''.join(split)

        return Plain(modified_value)

if __name__ == "__main__":
    toJSONFilter(preffyify_fractions)
