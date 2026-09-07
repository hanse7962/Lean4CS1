#!/usr/bin/env python3
"""Render src/og-cover.png, the link-preview image, from the built cover page.

Facebook and the rest read Open Graph tags; without an og:image they fall back to
the page <title>, which for the cover is the word "Cover".  This composes the
cover plate on a 1200x630 canvas using the cover's own CSS, so the preview shows
the actual title page and follows it when it changes.

Run with `make og` after editing src/cover.md.  Needs `mdbook build` first.
"""
import http.server, pathlib, re, shutil, socket, socketserver, sys, threading

SRC, OUT = pathlib.Path("book/cover.html"), pathlib.Path("src/og-cover.png")
STAGE = pathlib.Path("/tmp/og-card")


def compose():
    src = SRC.read_text()
    style = re.search(r"<style>\s*\n(\.cover\s*\{.*?)</style>", src, re.S).group(1)
    plate = re.search(r'(<div class="cover-plate">.*?</div>\s*\n\s*</div>)', src, re.S).group(1)
    plate = plate.rsplit("</div>", 1)[0]
    plate = re.sub(r'\s*<div class="cover-status">.*?</div>', "", plate, flags=re.S)
    STAGE.mkdir(exist_ok=True)
    shutil.copytree("book/fonts", STAGE / "fonts", dirs_exist_ok=True)
    for f in (STAGE / "fonts").iterdir():
        if f.suffix == ".css":
            shutil.copy(f, STAGE / "fonts" / "fonts.css")
    (STAGE / "card.html").write_text(f"""<!DOCTYPE html>
<html lang="en"><head><meta charset="utf-8"><title>og</title>
<link rel="stylesheet" href="fonts/fonts.css"><style>
:root {{ --quote-bg:#f6f8fa; --quote-border:#d9dde7; --links:#3547a8; --bg:#fff; --fg:#14161d;
  --mono-font:"IBM Plex Mono",monospace; }}
html,body {{ margin:0; padding:0; width:1200px; height:630px; overflow:hidden;
  background:#fff; color:var(--fg); font-family:"Open Sans","Segoe UI",system-ui,sans-serif; }}
body {{ display:flex; align-items:center; justify-content:center; }}
{style}
.cover-plate {{ width:auto; max-width:1030px; padding:2.1rem 3.1rem; }}
</style></head><body>
{plate}
</body></html>""")


def main():
    if not SRC.exists():
        sys.exit("error: book/cover.html not found -- run `make build` first")
    compose()
    try:
        from playwright.sync_api import sync_playwright
    except ImportError:
        sys.exit("error: playwright not installed.\n"
                 "  pip install playwright && python3 -m playwright install --with-deps chromium")
    s = socket.socket(); s.bind(("127.0.0.1", 0)); port = s.getsockname()[1]; s.close()

    class H(http.server.SimpleHTTPRequestHandler):
        def __init__(self, *a, **k): super().__init__(*a, directory=str(STAGE), **k)
        def log_message(self, *a): pass

    httpd = socketserver.TCPServer(("127.0.0.1", port), H)
    threading.Thread(target=httpd.serve_forever, daemon=True).start()
    try:
        with sync_playwright() as p:
            b = p.chromium.launch(args=["--no-sandbox"])
            pg = b.new_page(viewport={"width": 1200, "height": 630}, device_scale_factor=2)
            pg.goto(f"http://127.0.0.1:{port}/card.html", wait_until="networkidle")
            pg.wait_for_timeout(400)
            pg.screenshot(path=str(OUT))
            b.close()
    finally:
        httpd.shutdown()
    print(f"  wrote {OUT} ({OUT.stat().st_size // 1024} KB)")


if __name__ == "__main__":
    main()
