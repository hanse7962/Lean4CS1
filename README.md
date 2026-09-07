# CS6501, Fall 2026

A literate Lean 4 curriculum introducing typed functional programming through the lens of the Curry-Howard correspondence. Every file compiles cleanly against Lean 4 / Mathlib, with no `sorry`.

The book presents **Part I** — a complete 14-week curriculum. **Part II shifts to proof construction**, building directly on the foundations Part I establishes.

## Design commitments

**In Part I, students emerge fluent in computational and logical types; proof construction is not an assessment target — that is the subject of Part II.**

- Propositions are types from Week 1.
- `decide` is the primary proof producer for decidable propositions.
- Proofs are shown, increasingly as the course progresses. Where the logical structure is the point they are in term mode, so that structure stays explicit. Part I does not require a student to write one.
- `sorry` never appears.
- Full Mathlib notations are used throughout.

## Full Course structure (14 weeks)

|Unit|Weeks|Theme|
|----|-----|-----|
|1|0–3|Expressions, Functions, Recursion|
|2|4–7|Algebraic Datatypes, Lists, Trees, Decidability|
|3|8–9|Higher-Order Functions, Specifications|
|4|10|Sets and Relations|
|5|11–12|Abstract Types, Type Classes|
|6|14|Curry-Howard|

## Repository layout

```text
FPCourse/          Lean 4 source files for the 14-week Full Course
  T01_ExpressionsFunctionsRecursion/   Unit 1 — Weeks 0–3
  T02_InductiveTypes/             Unit 2 — Weeks 4–7
  T03_HigherOrderAndSpecification/     Unit 3 — Weeks 8–9
  T04_SetsAndRelations/                Unit 4 — Week 10
  T05_AbstractTypesAndTypeClasses/     Unit 5 — Weeks 11–12
  T06_StreamsAndCurryHoward/           Unit 6 — Week 14
scripts/
  convert.py       Literate Lean → Markdown (used by the Makefile and CI)
src/
  SUMMARY.md       mdBook table of contents
  introduction.md  Course overview page
  FPCourse/        Generated Markdown for Full Course
book.toml          mdBook configuration
Makefile           Build automation: make → convert + mdbook build
.github/workflows/
  mdbook.yml       CI/CD: convert, build, deploy to GitHub Pages
```

## Building the Lean sources

Requires Lean 4 and Lake. The first build downloads Mathlib (~several GB) and may take 30–60 minutes.

```bash
lake build
```

`Build completed successfully` means every proof in the curriculum compiles.

## Building the web book

Requires [mdBook](https://rust-lang.github.io/mdBook/) and its preprocessors (`mdbook-toc`, `mdbook-mermaid`).

**Convert Lean sources to Markdown:**

```bash
make convert
```

**Build and serve locally:**

```bash
make serve          # builds and serves; use the address in VS Code's PORTS panel
```

**Full pipeline:**

```bash
make                # or: make all
```

## Continuous deployment

Pushing to `main` triggers `.github/workflows/mdbook.yml`, which installs mdBook and its preprocessors, runs the converter on every `.lean` file, builds the book, and deploys to GitHub Pages.

## Literate format

Prose lives inside `/-! @@@ ... @@@ -/` comment blocks; everything else is treated as Lean code.

```lean
/-! @@@
## Section heading

Explanation in **Markdown**.
@@@ -/

-- This becomes a ```lean code block.
def example : Nat := 42
```

## Course reading links

The Software Logic schedule in `src/SoftwareLogic/index.md` **links** to external copies of
its readings; it does not redistribute them. Reading PDFs are publisher-copyrighted and a
local `Readings/` library is deliberately gitignored. Closed-access readings (Letovsky 1987,
Hoare 1972) are cited by DOI and read through the UVA library.

When a reading link rots, replace it with a copy of the *same* document where possible. If
only a different manifestation is available (preprint, technical report), amend the citation
to name what is actually linked rather than leaving a citation that the linked file does not
match.

Link audit, 2026-08-25:

- **Perry & Wolf (Week 4)** — `www.cs.utexas.edu/~perry/...` 404'd; moved to
  `users.ece.utexas.edu/~perry/work/papers/swa-sen.pdf`. Same document.
- **AlphaVerus (Week 13)** — the PMLR PDF path 404'd, but volume v267 was correct and matches
  the cited pagination (PMLR 267:587-615); only PMLR's asset path changed. Now links the
  landing page `proceedings.mlr.press/v267/aggarwal25a.html`, which is the stable identifier,
  preserving the ICML version of record rather than substituting the arXiv preprint.
- **Brooks, *No Silver Bullet* (Week 2)** — CiteSeerX link dead; now
  `cs.unc.edu/techreports/86-020.pdf`. That file is the September 1986 technical report, not
  the 1987 *Computer* article, so the citation was amended to name TR86-020 with *Computer*
  20(4), 1987, pp. 10-19 given as the "also published as" reference.
- **CiteSeerX has shut down.** It now 301-redirects to a Wayback snapshot
  (`20251230112235`) and serves an incomplete TLS chain (leaf `*.ist.psu.edu` without the
  InCommon intermediate). Browsers recover via AIA fetching; `curl`, `wget` and CI do not.
  The remaining CiteSeerX link — Sillito (Week 14) — still resolves to the correct PDF
  through that redirect and was left unchanged, but it depends on both the redirect and
  Wayback availability. Replace it if a live ACM or author copy is found.
- **`dl.acm.org` links return 403 to scripted requests** (Cloudflare bot protection). They
  load normally in a browser. Not broken; no action needed.

## Assessment forms

Students are assessed on six competencies (no proof production required):

1. **Specification writing** — given a function and English description, write the correct Lean type expressing its specification.
2. **Specification reading** — given a Lean proposition, state in English what it asserts; give a satisfying and a falsifying example.
3. **Type-directed derivation** — given a target type, derive an inhabiting term by type-directed steps and *narrate the derivation*: name each introduction/elimination step, the hypothesis or constructor used, and the goal that remains. The narrated trace is the graded artifact; the term the compiler accepts is its by-product. A companion form gives a target type and asks *which introduction- or elimination-step must come first, and why* — un-fakeable by poking the compiler. The compiler is a confirmer of a predicted step, not a search engine. (See Week 2 §2.6, *Deriving terms from types*.)
4. **Counterexample finding** — given a function and an incorrect specification, find a concrete input that witnesses the mismatch.
5. **Decidability identification** — given a proposition, state whether `decide` closes it, which other term if not, and why.
6. **Type reading (free theorems)** — given a (polymorphic) signature, state what *every* inhabitant must satisfy and what the type forbids, with no term written. The inverse of #3 — reading a type rather than building for it; parametricity makes the strongest of these deterministic. (Reynolds 1983, Wadler 2015; see Week 7 §7.2, *Free theorems*.)
