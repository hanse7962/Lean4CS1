#!/usr/bin/env python3
"""mdBook preprocessor: replace @GIT_COMMIT@ with the commit being built.

src/cover.md carries the literal token @GIT_COMMIT@ so that no commit has to
contain its own hash.  Substituting here rather than in the built HTML means it
happens on every build mdBook runs -- including each `mdbook serve` rebuild,
which rewrites book/cover.html and so would undo any post-build edit.

Set BOOK_COMMIT to override what is stamped.  CI does: its convert and NFC
steps rewrite tracked Markdown, so the working tree is dirty by this point and
an otherwise clean build of a pushed commit would be labelled "-dirty".
"""
import json
import os
import subprocess
import sys

PLACEHOLDER = '@GIT_COMMIT@'


def git(*args):
    return subprocess.run(['git', *args], capture_output=True, text=True)


def commit_label():
    override = os.environ.get('BOOK_COMMIT', '').strip()
    if override:
        return override
    head = git('rev-parse', '--short', 'HEAD')
    if head.returncode != 0:
        return 'unknown'
    # The commit only.  A "-dirty" suffix does not belong on a title page: it
    # says nothing a reader can use and appears whenever the author has an
    # unsaved edit open.
    return head.stdout.strip()


def stamp(items, label):
    """Replace the token throughout the book, returning how many chapters hit."""
    hits = 0
    for item in items:
        chapter = item.get('Chapter') if isinstance(item, dict) else None
        if chapter is None:                       # Separator, PartTitle
            continue
        content = chapter.get('content', '')
        if PLACEHOLDER in content:
            chapter['content'] = content.replace(PLACEHOLDER, label)
            hits += 1
        hits += stamp(chapter.get('sub_items', []), label)
    return hits


def main():
    if len(sys.argv) > 1 and sys.argv[1] == 'supports':
        return 0
    _context, book = json.load(sys.stdin)
    # mdBook 0.5 renamed this key from "sections" to "items"; accept either so
    # a version bump cannot silently turn this preprocessor into a no-op.
    items = book.get('items', book.get('sections', []))
    if not stamp(items, commit_label()):
        print(f'Warning: stamp preprocessor found no {PLACEHOLDER} to replace',
              file=sys.stderr)
    json.dump(book, sys.stdout)
    return 0


if __name__ == '__main__':
    sys.exit(main())
