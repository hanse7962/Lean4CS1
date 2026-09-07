#!/usr/bin/env python3
"""Render the Slack text as HTML for rich-text copy-paste.

Slack applies formatting to a paste only when the clipboard advertises text/html,
which it does when you copy from a rendered page.  Pasting the .txt gives literal
asterisks unless the reader has "Format messages with markup" switched on; copying
from this page gives real bold and real links, with no setting to change.

Generated from lean4-fall-2026.slack.txt so the two cannot drift.
Regenerate with `make slack`.
"""
import html
import pathlib
import re

SRC = pathlib.Path("lean4-fall-2026.slack.txt")
DST = pathlib.Path("lean4-fall-2026-slack.html")  # repo root: NOT published
MARKUP = pathlib.Path("lean4-fall-2026.slack-markup.txt")
BASE = "https://kevinsullivan.github.io/Lean4CS1/lean4-fall-2026-sources.html"


def linkify(s):
    s = html.escape(s)
    s = re.sub(r'\[(\d+)\]', lambda m: f'<a href="{BASE}#s{m.group(1)}">[{m.group(1)}]</a>', s)
    s = re.sub(r'(?<!")(https://\S+)', r'<a href="\1">\1</a>', s)
    return s


def write_markup(lines):
    """Emit the same message in Slack mrkdwn, for readers who have
    Preferences > Advanced > "Format messages with markup" switched on."""
    out = []
    for i, line in enumerate(lines):
        if i == 0:
            out.append(f"*{line}*")
        elif i == 1:
            out.append(f"_{line}_")
        elif line.startswith("• "):
            rest = line[2:]
            name, sep, tail = rest.partition(" — ")
            tail = re.sub(r"\((round open[^)]*|proposed sale|reported, in talks)\)",
                          r"_(\1)_", tail)
            out.append(f"• *{name}*{sep}{tail}" if sep else f"• {rest}")
        elif line.endswith(":") and not line.startswith("http"):
            out.append(f"*{line[:-1]}*")
        elif line.startswith("Market caps retrieved"):
            out.append(f"_{line}_")
        else:
            out.append(line)
    MARKUP.write_text("\n".join(out) + "\n", encoding="utf-8")
    print(f"  wrote {MARKUP} — {sum(l.count('*') for l in out)//2} bold spans")


def main():
    lines = SRC.read_text(encoding="utf-8").splitlines()
    write_markup(lines)
    body, buf = [], []

    def flush():
        """Emit a real <table>.  Slack renders pasted tabular data as a table;
        a <ul> would arrive as a list of long lines, which is what it looked like before."""
        if buf:
            trs = []
            for b in buf:
                name, sep, tail = b.partition(" — ")
                val, sep2, work = tail.partition(" — ")
                if sep and sep2:
                    trs.append(f"    <tr><td><b>{name}</b></td><td>{val}</td><td>{work}</td></tr>")
                else:
                    trs.append(f'    <tr><td colspan="3">{b}</td></tr>')
            body.append(
                "<table>\n  <thead><tr><th>Organization</th><th>Valuation</th>"
                "<th>Lean 4 work</th></tr></thead>\n  <tbody>\n"
                + "\n".join(trs) + "\n  </tbody>\n</table>")
            buf.clear()

    for i, line in enumerate(lines):
        if not line.strip():
            continue
        if line.startswith("• "):
            buf.append(linkify(line[2:]))
        elif i == 0:
            flush(); body.append(f"<h1>{html.escape(line)}</h1>")
        elif line.endswith(":") and not line.startswith("http"):
            flush(); body.append(f"<p><strong>{html.escape(line)}</strong></p>")
        else:
            flush(); body.append(f"<p>{linkify(line)}</p>")
    flush()

    DST.write_text(
        '<!DOCTYPE html>\n<html lang="en">\n<head>\n<meta charset="utf-8">\n'
        '<meta name="viewport" content="width=device-width, initial-scale=1">\n'
        "<title>Lean 4, Fall 2026 — Slack copy</title>\n<style>\n"
        "  body { margin: 0; background: #fff; color: #16181f;\n"
        "    font-family: system-ui, -apple-system, 'Segoe UI', sans-serif; line-height: 1.5; }\n"
        "  main { max-width: 46rem; margin: 0 auto; padding: 2rem 1.25rem 4rem; }\n"
        "  h1 { font-size: 1.5rem; margin: 0 0 .25rem; }\n"
        "  .hint { background: #eef1f8; border-left: 3px solid #3547a8; padding: .75rem 1rem;\n"
        "    font-size: .88rem; margin: 0 0 1.75rem; }\n"
        "  table { border-collapse: collapse; width: 100%; margin: 0 0 1.5rem; font-size: .9rem; }\n"
        "  th, td { border: 1px solid #ccd2e0; padding: .4rem .55rem; text-align: left;\n"
        "    vertical-align: top; }\n"
        "  th { background: #eef1f8; }\n"
        "  a { color: #3547a8; }\n</style>\n</head>\n<body>\n<main>\n"
        '<p class="hint">Select all of the text below this box, copy, and paste into Slack. '
        "Because you are copying from a rendered page, Slack keeps the bold headings and the "
        "clickable source numbers. Do not use paste-as-plain-text.</p>\n"
        + "\n".join(body)
        + "\n</main>\n</body>\n</html>\n", encoding="utf-8")
    n = len(re.findall(r'#s\d+', DST.read_text()))
    print(f"  wrote {DST} — {n} clickable source references")


if __name__ == "__main__":
    main()
