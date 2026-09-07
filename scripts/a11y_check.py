#!/usr/bin/env python3
"""Accessibility gate for the built book.

Runs axe-core against the pages in BUILD_DIR and reports WCAG 2.1 A/AA and
Section 508 violations.

Pages we author must pass, and a violation in one fails the build.  mdBook's
own generated pages are reported but never fail it: their violations come from
the upstream theme (the sidebar toggle carries ARIA attributes not allowed on a
<label>, task-list checkboxes render without labels, scrollable code regions are
not keyboard focusable) and cannot be fixed from this repository.

Usage:  python3 scripts/a11y_check.py [build-dir]
"""
import http.server
import pathlib
import re
import socket
import socketserver
import sys
import threading

AXE = "https://cdnjs.cloudflare.com/ajax/libs/axe-core/4.10.2/axe.min.js"
TAGS = ["wcag2a", "wcag2aa", "wcag21a", "wcag21aa", "section508"]

# Pages authored here, which must stay clean.
GATED = ["/lean4-fall-2026.html", "/lean4-fall-2026-sources.html"]
# A representative sample of mdBook output, reported only.
REPORTED = ["/index.html", "/cover.html", "/setup.html",
            "/SoftwareLogic/index.html", "/accessibility.html",
            "/lean4-industry.html"]


def serve(directory):
    class H(http.server.SimpleHTTPRequestHandler):
        def __init__(self, *a, **k):
            super().__init__(*a, directory=str(directory), **k)

        def log_message(self, *a):
            pass

    s = socket.socket()
    s.bind(("127.0.0.1", 0))
    port = s.getsockname()[1]
    s.close()
    httpd = socketserver.TCPServer(("127.0.0.1", port), H)
    threading.Thread(target=httpd.serve_forever, daemon=True).start()
    return httpd, f"http://127.0.0.1:{port}"


def check_source_invariants():
    """Fail if the Markdown reintroduces a defect the accessibility statement says is gone.

    ACCESSIBILITY.md records that Markdown task lists were replaced with plain bullets,
    because mdBook renders `- [ ]` as <input disabled type="checkbox"> with no accessible
    name (WCAG 4.1.2 Name, Role, Value, Level A).  Nothing stops someone typing `- [ ]`
    again, which would silently make the published statement false, so the build checks
    rather than trusts.
    """
    pattern = re.compile(r"^\s*[-*+]\s+\[[ xX]\]\s", re.M)
    offenders = []
    for md in sorted(pathlib.Path("src").rglob("*.md")):
        for n, line in enumerate(md.read_text(encoding="utf-8").splitlines(), 1):
            if pattern.match(line):
                offenders.append(f"{md}:{n}: {line.strip()[:60]}")
    if offenders:
        print("  task-list syntax found -- mdBook renders these as unlabelled checkboxes:")
        for o in offenders:
            print(f"    {o}")
        print("  Either write them as plain bullets, or update ACCESSIBILITY.md, which"
              "\n  currently states this defect has been remediated.")
    return len(offenders)


def main():
    build = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else "book")
    if not build.is_dir():
        sys.exit(f"error: {build}/ not found -- run `make build` first")
    try:
        from playwright.sync_api import sync_playwright
    except ImportError:
        sys.exit("error: playwright not installed.\n"
                 "  pip install playwright && python3 -m playwright install --with-deps chromium")

    failures = check_source_invariants()
    httpd, base = serve(build)
    try:
        with sync_playwright() as p:
            browser = p.chromium.launch(args=["--no-sandbox"])
            for path, gated in [(p_, True) for p_ in GATED] + [(p_, False) for p_ in REPORTED]:
                if not (build / path.lstrip("/")).exists():
                    print(f"  skip     {path} (not built)")
                    continue
                page = browser.new_page(viewport={"width": 1200, "height": 900})
                page.goto(base + path, wait_until="load", timeout=45000)
                page.add_script_tag(url=AXE)          # loudly fails if unreachable
                violations = page.evaluate(
                    "async (tags) => (await axe.run(document,"
                    " {runOnly:{type:'tag', values:tags}})).violations"
                    ".map(v => ({id:v.id, impact:v.impact, n:v.nodes.length}))", TAGS)
                label = "GATED   " if gated else "reported"
                if not violations:
                    print(f"  {label} {path:40s} clean")
                else:
                    print(f"  {label} {path:40s} {len(violations)} violation type(s)")
                    for v in violations:
                        print(f"           - {v['impact']:8s} {v['id']:32s} x{v['n']}")
                    if gated:
                        failures += len(violations)
                page.close()
            browser.close()
    finally:
        httpd.shutdown()

    if failures:
        print(f"\nFAIL: {failures} accessibility problem(s) in material authored here.")
        return 1
    print("\nOK: every authored page passes WCAG 2.1 AA and Section 508.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
