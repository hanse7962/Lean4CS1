<style>
.cover {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: calc(100vh - 8rem);
  margin: 0.5rem 0 2rem;
}
.cover-plate {
  width: 100%;
  padding: clamp(2rem, 6vw, 4.5rem) clamp(1.25rem, 5vw, 3.5rem);
  text-align: center;
  border: 1px solid var(--quote-border);
  outline: 1px solid var(--quote-border);
  outline-offset: 6px;
  background: var(--quote-bg);
}
.cover-kicker {
  font-size: 0.78rem;
  font-weight: 600;
  letter-spacing: 0.22em;
  text-transform: uppercase;
  opacity: 0.7;
}
.cover-title {
  font-size: clamp(2.6rem, 9vw, 4.6rem);
  font-weight: 700;
  line-height: 1.02;
  letter-spacing: 0.02em;
  margin: clamp(1.5rem, 5vw, 2.5rem) 0 0;
}
.cover-subtitle {
  font-size: clamp(1.15rem, 4vw, 1.7rem);
  font-weight: 400;
  font-style: italic;
  line-height: 1.25;
  margin-top: 0.7rem;
}
.cover-subtitle-2 {
  font-size: clamp(1.05rem, 3.4vw, 1.4rem);
  font-weight: 400;
  font-style: italic;
  line-height: 1.25;
  margin-top: 0.2rem;
  opacity: 0.9;
}
.cover-rule {
  width: 42%;
  max-width: 14rem;
  height: 1px;
  margin: clamp(1.5rem, 5vw, 2.25rem) auto;
  background: var(--quote-border);
}
.cover-author {
  margin-top: clamp(1.75rem, 5vw, 2.75rem);
  font-size: 1.12rem;
  font-weight: 600;
  letter-spacing: 0.01em;
}
.cover-affiliation {
  margin-top: 0.2rem;
  font-size: 0.95rem;
  opacity: 0.75;
}
.cover-mark {
  margin-top: clamp(1.75rem, 5vw, 2.75rem);
  font-family: var(--mono-font, monospace);
  font-size: 0.82rem;
  opacity: 0.6;
  overflow-wrap: anywhere;
}
.cover-cta {
  display: inline-block;
  margin-top: clamp(1.5rem, 4vw, 2.25rem);
  padding: 0.72em 2em;
  border: 1px solid var(--links);
  border-radius: 3px;
  color: var(--links);
  font-size: 1.02rem;
  font-weight: 600;
  letter-spacing: 0.05em;
  text-decoration: none;
  transition: background 0.15s ease, color 0.15s ease;
}
.cover-cta:hover,
.cover-cta:focus-visible {
  background: var(--links);
  color: var(--bg);
  text-decoration: none;
}
.cover-cta:focus-visible {
  outline: 2px solid var(--links);
  outline-offset: 3px;
}
@media (prefers-reduced-motion: reduce) {
  .cover-cta { transition: none; }
}
.cover-status {
  /* Matches .cover-cta's margin-top so the button is centred between the
     line above it and this one. */
  margin-top: clamp(1.5rem, 4vw, 2.25rem);
  font-size: 0.78rem;
  letter-spacing: 0.16em;
  text-transform: uppercase;
  opacity: 0.6;
}
.cover-commit {
  font-family: var(--mono-font, monospace);
  text-transform: none;
  letter-spacing: 0;
}
</style>

<div class="cover">
  <div class="cover-plate">
    <div class="cover-kicker">University of Virginia</div>
    <div class="cover-title">Software Logic</div>
    <div class="cover-subtitle">Intellectual Control, Assurance, and Accountability</div>
    <div class="cover-subtitle-2">in the Era of Agentic Software Engineering and Autoformalized Mathematics</div>
    <div class="cover-rule"></div>
    <div class="cover-author">Kevin Sullivan</div>
    <div class="cover-affiliation">Department of Computer Science</div>
    <div class="cover-affiliation">CS6501-010 &middot; Fall 2026</div>
    <div class="cover-mark">theorem correct : &forall; n, f n = spec n := by decide</div>
    <div><a class="cover-cta" href="setup.html">Boot!</a></div>
    <div class="cover-status">Semper crescens &middot; Commit <span class="cover-commit">@GIT_COMMIT@</span></div>
  </div>
</div>
