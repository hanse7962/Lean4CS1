(() => {
    const darkThemes = ['ayu', 'navy', 'coal'];

    const html = document.documentElement;
    const isDark = () => darkThemes.some(theme => html.classList.contains(theme));

    let wasDark = isDark();
    mermaid.initialize({ startOnLoad: true, theme: wasDark ? 'dark' : 'default' });

    // Mermaid bakes the theme into each diagram when it renders it, so the
    // simplest way to restyle the diagrams after a theme change is to reload.
    //
    // Watch the theme class mdBook sets on <html> rather than binding to the
    // theme buttons: their element ids are not stable across mdBook releases
    // (0.5 renamed id="ayu" to id="mdbook-theme-ayu", which left this script
    // throwing on every page), while the class is what actually selects the
    // theme.  Watching it also covers the "Auto" theme and an OS-level
    // light/dark switch, neither of which is a click on a known button.
    new MutationObserver(() => {
        if (isDark() === wasDark) return;   // e.g. the sidebar was toggled
        wasDark = !wasDark;
        window.location.reload();
    }).observe(html, { attributes: true, attributeFilter: ['class'] });
})();
