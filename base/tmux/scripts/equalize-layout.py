#!/usr/bin/env python3
"""Equalize tmux pane sizes along one axis without changing the layout structure.

Walks the current window's layout tree and, for every split node whose
orientation matches the requested axis, redistributes its children to equal
sizes. Subtrees inside resized children are scaled proportionally so the
overall structure is preserved.

Usage: equalize-layout.py {x|y}
  y  redistribute heights of vertically-stacked groups (`[]` nodes)
  x  redistribute widths of horizontally-arranged groups (`{}` nodes)
"""

import re
import subprocess
import sys


NODE_RE = re.compile(r"(\d+)x(\d+),(\d+),(\d+)")
PANE_RE = re.compile(r",(\d+)")


def parse_layout(s):
    _, body = s.split(",", 1)
    node, end = parse_node(body, 0)
    if end != len(body):
        raise ValueError(f"trailing input: {body[end:]!r}")
    return node


def parse_node(s, i):
    m = NODE_RE.match(s, i)
    if not m:
        raise ValueError(f"expected WxH,X,Y at {i}: {s[i : i + 20]!r}")
    w, h, x, y = map(int, m.groups())
    i = m.end()

    if i < len(s) and s[i] in "[{":
        bracket = s[i]
        closer = "]" if bracket == "[" else "}"
        i += 1
        children = []
        while True:
            child, i = parse_node(s, i)
            children.append(child)
            if i < len(s) and s[i] == ",":
                i += 1
                continue
            break
        if i >= len(s) or s[i] != closer:
            raise ValueError(f"expected {closer!r} at {i}")
        return ({"type": bracket, "x": x, "y": y, "w": w, "h": h, "children": children}, i + 1)

    pm = PANE_RE.match(s, i)
    if pm:
        return ({"type": "leaf", "x": x, "y": y, "w": w, "h": h, "id": int(pm.group(1))}, pm.end())

    return ({"type": "leaf", "x": x, "y": y, "w": w, "h": h}, i)


def render(node):
    s = f"{node['w']}x{node['h']},{node['x']},{node['y']}"
    if node["type"] == "leaf":
        if "id" in node:
            s += f",{node['id']}"
        return s
    closer = "]" if node["type"] == "[" else "}"
    return s + node["type"] + ",".join(render(c) for c in node["children"]) + closer


def checksum(s):
    csum = 0
    for ch in s:
        csum = ((csum >> 1) | ((csum & 1) << 15)) & 0xFFFF
        csum = (csum + ord(ch)) & 0xFFFF
    return csum


def resize_y(node, new_y, new_h):
    """Set node y/h, scaling all descendants proportionally along the y axis."""
    old_y, old_h = node["y"], node["h"]
    node["y"], node["h"] = new_y, new_h
    if node["type"] == "leaf":
        return
    if node["type"] == "{":
        for c in node["children"]:
            resize_y(c, new_y, new_h)
        return
    n = len(node["children"])
    old_avail = old_h - (n - 1)
    new_avail = new_h - (n - 1)
    sizes = []
    used = 0
    for i, c in enumerate(node["children"]):
        if i < n - 1:
            sz = max(1, round(c["h"] * new_avail / old_avail))
            sizes.append(sz)
            used += sz
        else:
            sizes.append(max(1, new_avail - used))
    cur = new_y
    for c, sz in zip(node["children"], sizes):
        resize_y(c, cur, sz)
        cur += sz + 1


def resize_x(node, new_x, new_w):
    old_x, old_w = node["x"], node["w"]
    node["x"], node["w"] = new_x, new_w
    if node["type"] == "leaf":
        return
    if node["type"] == "[":
        for c in node["children"]:
            resize_x(c, new_x, new_w)
        return
    n = len(node["children"])
    old_avail = old_w - (n - 1)
    new_avail = new_w - (n - 1)
    sizes = []
    used = 0
    for i, c in enumerate(node["children"]):
        if i < n - 1:
            sz = max(1, round(c["w"] * new_avail / old_avail))
            sizes.append(sz)
            used += sz
        else:
            sizes.append(max(1, new_avail - used))
    cur = new_x
    for c, sz in zip(node["children"], sizes):
        resize_x(c, cur, sz)
        cur += sz + 1


def equalize(node, axis):
    if node["type"] == "leaf":
        return

    target = "[" if axis == "y" else "{"
    if node["type"] == target:
        children = node["children"]
        n = len(children)
        if axis == "y":
            avail = node["h"] - (n - 1)
            base, rem = divmod(avail, n)
            cur = node["y"]
            for i, c in enumerate(children):
                sz = base + (1 if i < rem else 0)
                resize_y(c, cur, sz)
                cur += sz + 1
        else:
            avail = node["w"] - (n - 1)
            base, rem = divmod(avail, n)
            cur = node["x"]
            for i, c in enumerate(children):
                sz = base + (1 if i < rem else 0)
                resize_x(c, cur, sz)
                cur += sz + 1

    for c in node["children"]:
        equalize(c, axis)


def main():
    if len(sys.argv) != 2 or sys.argv[1] not in ("x", "y"):
        sys.exit("usage: equalize-layout.py {x|y}")
    axis = sys.argv[1]

    raw = subprocess.check_output(
        ["tmux", "display-message", "-p", "#{window_layout}"], text=True
    ).strip()
    root = parse_layout(raw)
    equalize(root, axis)
    body = render(root)
    new_layout = f"{checksum(body):04x},{body}"
    subprocess.run(["tmux", "select-layout", new_layout], check=True)


if __name__ == "__main__":
    main()
