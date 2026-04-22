#!/usr/bin/env python3
"""Claude Code statusline: context usage + cwd."""

import json
import os
import sys

data = json.load(sys.stdin)

workspace = data.get("workspace") or {}
cwd = (workspace.get("project_dir") or data.get("cwd") or "").rstrip("/") or "/"
home = os.path.expanduser("~")
display_cwd = "~" + cwd[len(home):] if cwd == home or cwd.startswith(home + "/") else cwd

ctx = data.get("context_window") or {}
pct = ctx.get("used_percentage")
usage = ctx.get("current_usage") or {}
used = sum(
    usage.get(k) or 0
    for k in ("input_tokens", "cache_creation_input_tokens", "cache_read_input_tokens")
)
total = ctx.get("context_window_size")


def fmt(n):
    if n is None:
        return "?"
    if n >= 1_000_000:
        s = f"{n / 1_000_000:.1f}m"
        return s.replace(".0m", "m")
    if n >= 1_000:
        return f"{n // 1_000}k"
    return str(n)


BLUE = "\x1b[34m"
CYAN = "\x1b[36m"
YELLOW = "\x1b[33m"
RESET = "\x1b[0m"

FOLDER = "\ue5ff"  # nf-md-folder (matches lualine)
MODEL = "\U000f09d1"  # nf-md-robot-happy


def battery(p):
    # Fresh context = full battery; drains as used
    if p < 10:
        return "\uf244"
    if p < 40:
        return "\uf243"
    if p < 60:
        return "\uf242"
    if p < 85:
        return "\uf241"
    return "\uf240"


model_name = (data.get("model") or {}).get("display_name")

parts = []
if model_name:
    parts.append(f"{YELLOW}{MODEL}  {model_name}{RESET}")
if pct is not None and total:
    parts.append(f"{CYAN}{battery(pct)}  {pct:.0f}% ({fmt(used)}/{fmt(total)}){RESET}")
parts.append(f"{BLUE}{FOLDER}  {display_cwd}{RESET}")

sys.stdout.write(" ".join(parts))
