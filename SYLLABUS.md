# CS6501-010 · Software Logic · Fall 2026

### Intellectual Control, Assurance, and Accountability in the Era of Agentic Software Engineering and Autoformalized Mathematics

- **Instructor:** Kevin Sullivan · <sullivan@virginia.edu>
- **Department:** Computer Science, University of Virginia
- **Meetings:** Mondays & Wednesdays, 11:00 AM – 12:15 PM · Rice 508 — 28 sessions
- **Office hours:** Tuesdays, 1:00 – 3:00 PM · Rice 508
- **Course book (living):** <https://kevinsullivan.github.io/Lean4CS1> · source: <https://github.com/kevinsullivan/Lean4CS1>

> This syllabus is subject to change. Any such changes will be pre-announced and documented
> here.

---

## Course Description

Software development is being transformed by AI in at least two big ways. First, AI is
automating the production of a great deal of imperative code. Second, combined with the
breakout success of proof assistants for formalization of abstract mathematical statements
and proofs, AI promises far greater practicality and utility of formal specification and
proof construction in routine industrial software production.

However big challenges remain. Even with formal and machine-checked specifications, the
rate at which generative AIs can produce specifications and proofs, now mixed together
with ordinary programming types and functions and effects, means that one's constructions
can easily escape one's intellectual control, even when it's all formalized and proven.

The problem with loss of intellectual control is that it's antithetical to good faith acceptance of
accountability for harmful failures that were, or could and should have been, foreseen and averted.
The social equation is you-are-accountable implies you-are-less-likely-to-fail implies
I-can-trust-you-more and act accordingly. That trust is what a user pays for: assurances that the
product is fit for use in all agreed respects, and the freedom to ignore the complexity behind them
because someone else has taken care of it. The same reasoning underpins a legal system in which
real people are punished. (At least that's the theory.) And trust of that kind is crucial to the
success of a system and of the society around it.

This course will emphasize the development of formal specification architectures as a
vital practice for both guiding generative AIs to produce useful results and to maintain
the intellectual control necessary for human beings to be held accountable for the harmful
failures their systems produce.

Durable intellectual control depends on abstract software specification and proofs rooted in the
generalized mathematics of the application domain, stating that theory precisely, and certifying
separate computable implementations against it. It is also required for the sustained quality of
evolving, long-lived software systems.

What formal methods give the developer is justified confidence that they can actually uphold the
assurances their users are paying for and then relying upon. That confidence rests on two distinct
objects of trust: the validity of the statements of the formal theory itself and verification of
the proof certificates that connect implementation to the abstract theories they are required to
implement in some form. Lean 4 provides a practical language in which theories, implementations,
and proofs can coexist, but it does not eliminate either obligation: one must understand the
mathematics being formalized, and one must understand the trusted proof-checking base on which that
confidence depends.

This is a course for graduate students in computer science. The course has two main threads: learning to think and express concepts formally in Lean 4, and learning deep and abiding principles of intellectual control over software through readings of seminal papers leading up to the present moment.

---

## Mathematical Thread: Two Parts

The mathematical thread in this course is in two parts.

- **Part I — Certified Computation (the FP book).** A functional-programming foundation, taught
  through the Curry–Howard correspondence, in which specifications are types. Students learn to read
  and write specifications as types, to derive terms that inhabit them, and to check their claims
  with the compiler. Part I does not assess proof construction. The proofs it contains are provided
  for students to read. When done, you will have a solid foundation in modern functional programming structure for an easy transition into logical specification and proof construction in Part II.
- **Part II — Proof Construction and Mathematical Abstractions.** Part II builds on the Part I foundations and asks students to
  produce proofs of their own. The objects of study carry over (data, specifications, recursion,
  higher-order functions, sets, relations, type classes), reoriented from `Type` to `Prop`. Part II
  follows the discipline general theory → separate computable realization → certified bridge, and
  works toward the endpoint the semester is designed around: institutions and the satisfaction
  condition.

Lean is used from Week 1 onward. Part II changes the kind of work students do in Lean; it does not
introduce Lean.

---

## Paper Reading Thread

The technical work on formal reasoning in a programming
language such as Lean 4 will be complemented by readings and
discussions of seminal papers throughout the semester.

---

## Grading

Course grades will be based on two components, weighted equally.

| Component                           | Weight |
| ----------------------------------- | ------ |
| Participation                       | 50%    |
| Two to three projects — details TBD | 50%    |

Participation means demonstrated preparation for and participation in class, including attendance
and active participation in discussions. You have two “just out” days for the semester: two class
meetings you may miss for any reason, with no explanation needed and no cost to your grade. Beyond
those, habitual absences or inattention will result in losses against full credit, assessed
periodically by the instructor. If you have special circumstances, talk with the instructor to reach
a common understanding.

---

## Materials & Setup

- **Software:** the course runs inside a development container. You install a
  [GitHub account](https://github.com/signup), Git,
  [Docker Desktop](https://www.docker.com/products/docker-desktop/),
  [VS Code](https://code.visualstudio.com/), and the Dev Containers extension. The container supplies
  Lean 4, **Mathlib**, the Lean 4 extension, and mdBook. Give Docker at least 10 GB of memory and
  15 GB of free disk. No purchase required; all tools are free and open-source.
- **Book:** the living course book at <https://kevinsullivan.github.io/Lean4CS1>, with sources at
  <https://github.com/kevinsullivan/Lean4CS1>. Each chapter is a
  literate Lean file, so the rendered prose can be read beside the type-checked source.
- **Setup:** follow [*Setting Up Your Machine*](src/setup.md) in the course book, which is the
  authoritative procedure. Fork the repository, clone your fork, and reopen it in the container.
  Then, inside the container:

```bash
lake exe cache get   # fetch prebuilt Mathlib (several GB; about ten minutes)
lake build           # compile the course sources
make serve           # serve the book; open the address in VS Code's PORTS panel
```

- **Working style:** study the rendered book (right pane) alongside the `.lean` source (left pane)
  with the Lean server running, so you see types and errors as you edit. Exercises are worked
  directly in the `.lean` files.

- **Readings** are publisher-copyrighted and are **linked**, not redistributed. Two closed-access
  papers (Letovsky 1987; Hoare 1972) are cited by DOI and read through the UVA Library.

---

## Schedule (Fall 2026 · Mondays & Wednesdays)

Two tracks run in parallel. **Paper readings** are due weekly. Links to all but two of the papers are provided in the schedule below. The remaining two have no public PDFs available and I will have to refer you to UVa's Library for them. The **Book track, Part I** runs **two chapters per session** (one each on Wed Sep 16 and Mon Sep 28), in order, beginning **Wed Sep 2**; once the book is complete (**Mon Sep 28**) the class proceeds to **Part II** (Proof construction). Class does not meet **Mon Oct 5** (fall reading days) or **Wed Nov 25** (Thanksgiving); but it does meet on **Labor Day (Mon Sep 7)**. 28 sessions total.

|    # | Date                                                                   | Paper readings (Line I — by week)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | Part I book (2 ch/session) → Part II                                                                                                  |
| ---: | ---------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
|      | **▸ Week 1** · course intro & Lean setup                               | *Aug 26 + Aug 31*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |                                                                                                                                       |
|    1 | Wed Aug 26                                                             | *course intro — no paper reading due*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | *course intro · Lean/Mathlib setup — no chapter due*                                                                                  |
|    2 | Mon Aug 31                                                             | *intro — no paper reading due (Paper set 1 due Wed Sep 2 ▸)*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | *course intro · Lean/Mathlib setup — no chapter due*                                                                                  |
|      | **▸ Week 2** · Part I book · 2 ch/session                              | *Sep 02 + Sep 07*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |                                                                                                                                       |
|    3 | Wed Sep 02                                                             | **Paper set 1 — Wk 1: Software as Intellectual Instrument.**<br>— Brooks, [“The Computer ‘Scientist’ as Toolsmith”](https://andymatuschak.org/files/papers/Brooks%20-%201977%20-%20The%20computer%20scientist%20as%20toolsmith.pdf), *Information Processing 77*, 1977, pp. 625–634.<br>— Hutchins, Hollan & Norman, [“Direct Manipulation Interfaces”](https://hci.ucsd.edu/hollan/direct-manip.pdf), *Human–Computer Interaction* 1(4), 1985, pp. 311–338.                                                                                                                                                                                                                                                                             | Algebraic Types — Computation & Logic · Expressions, Types, Values                                                                    |
|    4 | Mon Sep 07 · Labor Day (meets)                                         | **Paper set 2 — Wk 2: Program Understanding.**<br>— Simon, [“The Architecture of Complexity”](https://www2.econ.iastate.edu/tesfatsi/ArchitectureOfComplexity.HSimon1962.pdf), *Proc. Am. Philosophical Society* 106(6), 1962, pp. 467–482.<br>— Letovsky, “Cognitive Processes in Program Comprehension,” *J. Systems and Software* 7(4), 1987, pp. 325–339, [doi:10.1016/0164-1212(87)90032-X](https://doi.org/10.1016/0164-1212%2887%2990032-X) — subscription; UVA Library.<br>— Brooks, [“No Silver Bullet”](https://www.cs.unc.edu/techreports/86-020.pdf), UNC TR86-020, 1986 (also *Computer* 20(4), 1987, pp. 10–19).                                                                                                           | Functions & Specifications · Recursion & Termination                                                                                  |
|      | **▸ Week 3** · Part I book · 2 ch/session                              | *Sep 09 + Sep 14*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |                                                                                                                                       |
|    5 | Wed Sep 09                                                             | **Wk 3: Conceptual Design.**<br>— Jackson, [“Towards a Theory of Conceptual Design for Software”](https://groups.csail.mit.edu/sdg/pubs/2015/concept-essay.pdf), *Onward! 2015*, pp. 282–296.<br>— Perez De Rosso & Jackson, [“Purposes, Concepts, Misfits, and a Redesign of Git”](https://groups.csail.mit.edu/sdg/pubs/2016/gitless-oopsla16.pdf), *OOPSLA 2016*, pp. 292–310.                                                                                                                                                                                                                                                                                                                                                        | Algebraic Datatypes · Lists                                                                                                           |
|    6 | Mon Sep 14                                                             | ↳ *(wk 3 — cont.)*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | Trees & BST Invariants · Polymorphism & Decidability                                                                                  |
|      | **▸ Week 4** · Part I book · 2 ch/session                              | *Sep 16 + Sep 21*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |                                                                                                                                       |
|    7 | Wed Sep 16                                                             | **Wk 4: Modularity & Software Architecture.**<br>— Parnas, [“On the Criteria To Be Used in Decomposing Systems into Modules”](https://dl.acm.org/doi/pdf/10.1145/361598.361623), *CACM* 15(12), 1972, pp. 1053–1058.<br>— Perry & Wolf, [“Foundations for the Study of Software Architecture”](https://users.ece.utexas.edu/~perry/work/papers/swa-sen.pdf), *ACM SIGSOFT SEN* 17(4), 1992, pp. 40–52.<br>— Garlan & Shaw, [“An Introduction to Software Architecture”](https://www.cs.cmu.edu/afs/cs/project/able/ftp/intro_softarch/intro_softarch.pdf), 1993, pp. 1–39.                                                                                                                                                               | Higher-Order Functions                                                                                                                |
|    8 | Mon Sep 21                                                             | ↳ *(wk 4 — cont.)*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | Specifications in Practice · Sets & Relations                                                                                         |
|      | **▸ Week 5** · Part I book · 2 ch/session — **book completes**         | *Sep 23 + Sep 28*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |                                                                                                                                       |
|    9 | Wed Sep 23                                                             | **Wk 5: Specification & the Architecture of Claims.**<br>— Hoare, [“An Axiomatic Basis for Computer Programming”](https://www.cs.cmu.edu/~crary/819-f09/Hoare69.pdf), *CACM* 12(10), 1969, pp. 576–580, 583.<br>— Dijkstra, [“Guarded Commands, Nondeterminacy and Formal Derivation of Programs”](https://www.cs.utexas.edu/~EWD/ewd04xx/EWD472.PDF), *CACM* 18(8), 1975, pp. 453–457.                                                                                                                                                                                                                                                                                                                                                  | Abstract Types · Type Classes & Decidability                                                                                          |
|   10 | Mon Sep 28                                                             | ↳ *(wk 5 — cont.)*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | Curry–Howard ← **Part I book complete**                                                                                               |
|      | **▸ Week 6** · Part II · Lean prog. & proof — *tentative* — **begins** | *Sep 30 + Oct 07* · (reading-day break between sessions)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |                                                                                                                                       |
|   11 | Wed Sep 30                                                             | **Wk 6: Abstraction, Types & Intellectual Compression.**<br>— Liskov & Zilles, [“Programming with Abstract Data Types”](https://gleitzman.com/media/docs/adt-liskov.pdf), 1974, pp. 50–59.<br>— Reynolds, [“Types, Abstraction and Parametric Polymorphism”](https://home.ttic.edu/~dreyer/course/papers/reynolds.pdf), *Information Processing 83*, pp. 513–523.<br>— Wadler, [“Propositions as Types”](https://www.pure.ed.ac.uk/ws/portalfiles/portal/20001186/propositions_as_types.pdf), *CACM* 58(12), 2015, pp. 75–84.                                                                                                                                                                                                            | ⟶ **Part II begins** (all Part II topics tentative) ‡ · **Relations** — abstract theory `A→B→Prop`: id, converse, composition, orders |
|   12 | Wed Oct 07 · post-reading-day                                          | ↳ *(wk 6 — cont.)*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | ‡ Relations — computable: finite relations as pair-lists; decidable membership                                                        |
|      | **▸ Week 7** · Part II · Lean prog. & proof — *tentative*              | *Oct 12 + Oct 14*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |                                                                                                                                       |
|   13 | Mon Oct 12                                                             | **Wk 7: Semantics: Making Meaning Explicit.**<br>— Plotkin, [“A Structural Approach to Operational Semantics”](https://homepages.inf.ed.ac.uk/gdp/publications/sos_jlap.pdf), *JLAP* 60–61, 2004, pp. 17–139.<br>— Goguen & Burstall, [“Institutions: Abstract Model Theory for Specification and Programming”](https://dl.acm.org/doi/pdf/10.1145/147508.147524), *JACM* 39(1), 1992, pp. 95–146.                                                                                                                                                                                                                                                                                                                                       | ‡ Relations — **bridge**: executable ops agree extensionally with abstract theory                                                     |
|   14 | Wed Oct 14                                                             | ↳ *(wk 7 — cont.)*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | ‡ **Transition systems** — transition relations; reflexive/transitive closure                                                         |
|      | **▸ Week 8** · Part II · Lean prog. & proof — *tentative*              | *Oct 19 + Oct 21*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |                                                                                                                                       |
|   15 | Mon Oct 19                                                             | **Wk 8: Formal Proof as an Intellectual Tool.**<br>— Leroy, [“Formal Verification of a Realistic Compiler”](https://xavierleroy.org/publi/compcert-CACM.pdf), *CACM* 52(7), 2009, pp. 107–115.<br>— Trusted-base limitation: Lean 4.32.2 kernel soundness fix — [release notes](https://lean-lang.org/doc/reference/latest/releases/v4.32.2/), [issue #14576](https://github.com/leanprover/lean4/issues/14576).                                                                                                                                                                                                                                                                                                                         | ‡ Transition systems — computable: finite-state graph + reachability search                                                           |
|   16 | Wed Oct 21                                                             | ↳ *(wk 8 — cont.)*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | ‡ Transition systems — **bridge**: computed reachability iff abstract; invariant soundness                                            |
|      | **▸ Week 9** · Part II · Lean prog. & proof — *tentative*              | *Oct 26 + Oct 28*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |                                                                                                                                       |
|   17 | Mon Oct 26                                                             | **Wk 9: Construction by Meaning-Preserving Transformation.**<br>— Meertens, [“Algorithmics—Towards Programming as a Mathematical Activity”](https://www.kestrel.edu/people/meertens/publications/papers/Algorithmics.pdf), 1986, pp. 289–334.<br>— Backus, [“Can Programming Be Liberated from the von Neumann Style?”](https://dl.acm.org/doi/pdf/10.1145/359576.359579), *CACM* 21(8), 1978, pp. 613–641.                                                                                                                                                                                                                                                                                                                              | ‡ **Relational algebra** — extensional operators + laws                                                                               |
|   18 | Wed Oct 28                                                             | ↳ *(wk 9 — cont.)*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | ‡ Relational algebra — computable: finite tables; select/project/join/union/diff/rename                                               |
|      | **▸ Week 10** · Part II · Lean prog. & proof — *tentative*             | *Nov 02 + Nov 04*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |                                                                                                                                       |
|   19 | Mon Nov 02                                                             | **Wk 10: Behavior, State, Time & Invariants.**<br>— Clarke, Emerson & Sistla, [“Automatic Verification of Finite-State Concurrent Systems…”](https://dl.acm.org/doi/pdf/10.1145/5397.5399), *TOPLAS* 8(2), 1986, pp. 244–263.<br>— Lamport, [“Time, Clocks, and the Ordering of Events in a Distributed System”](https://www.cs.cornell.edu/courses/cs614/2002sp/Clocks.Lamport.1.pdf), *CACM* 21(7), 1978, pp. 558–565.                                                                                                                                                                                                                                                                                                                 | ‡ Relational algebra — **bridge**: each operator denotes its abstract counterpart                                                     |
|   20 | Wed Nov 04                                                             | ↳ *(wk 10 — cont.)*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | ‡ **Inductive relational algebra** — query syntax + compositional denotation                                                          |
|      | **▸ Week 11** · Part II · Lean prog. & proof — *tentative*             | *Nov 09 + Nov 11*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |                                                                                                                                       |
|   21 | Mon Nov 09                                                             | **Wk 11: Representation, Refinement & Substitutability.**<br>— Hoare, “Proof of Correctness of Data Representations,” *Acta Informatica* 1(4), 1972, pp. 271–281, [doi:10.1007/BF00289507](https://doi.org/10.1007/BF00289507) — subscription; UVA Library.<br>— Liskov & Wing, [“A Behavioral Notion of Subtyping”](https://www.cs.cmu.edu/~wing/publications/LiskovWing94.pdf), *TOPLAS* 16(6), 1994, pp. 1811–1841.                                                                                                                                                                                                                                                                                                                   | ‡ Inductive rel. algebra — computable: evaluator/compiler over finite relations                                                       |
|   22 | Wed Nov 11                                                             | ↳ *(wk 11 — cont.)*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | ‡ Inductive rel. algebra — **bridge**: evaluation preserves denotation (structural)                                                   |
|      | **▸ Week 12** · Part II · Lean prog. & proof — *tentative*             | *Nov 16 + Nov 18*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |                                                                                                                                       |
|   23 | Mon Nov 16                                                             | **Wk 12: Evidence, Autoformalization & the Economics of Proof.**<br>— Claessen & Hughes, [“QuickCheck: A Lightweight Tool for Random Testing of Haskell Programs”](http://www.eecs.northwestern.edu/~robby/courses/395-495-2009-fall/quick.pdf), *ICFP 2000*, pp. 268–279.<br>— Wu et al., [“Autoformalization with Large Language Models”](https://papers.nips.cc/paper_files/paper/2022/file/d0c6bc641a56bebee9d985b937307367-Paper-Conference.pdf), *NeurIPS 2022*.                                                                                                                                                                                                                                                                   | ‡ **Categories** — objects, morphisms, identity, composition, functoriality                                                           |
|   24 | Wed Nov 18                                                             | ↳ *(wk 12 — cont.)*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | ‡ Signatures, sentences, models, interpretations, satisfaction                                                                        |
|      | **▸ Week 13** · Part II · Lean prog. & proof — *tentative*             | *Nov 23 + Nov 30* · (Thanksgiving break between sessions)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |                                                                                                                                       |
|   25 | Mon Nov 23                                                             | **Wk 13: Trust & Machine-Generated Verified Construction.**<br>— Necula, [“Proof-Carrying Code”](https://dl.acm.org/doi/pdf/10.1145/263699.263712), *POPL 1997*, pp. 106–119.<br>— Thompson, [“Reflections on Trusting Trust”](https://web.mit.edu/6.857/OldStuff/Fall03/ref/Thompson-ReflectionsOnTrustingTrust.pdf), *CACM* 27(8), 1984, pp. 761–763.<br>— Saltzer, Reed & Clark, [“End-to-End Arguments in System Design”](https://www.cs.cmu.edu/afs/cs.cmu.edu/academic/class/15712-s12/www/papers/saltzer84.pdf), *TOCS* 2(4), 1984, pp. 277–288.<br>— Aggarwal, Parno & Welleck, [“AlphaVerus: Bootstrapping Formally Verified Code Generation…”](https://proceedings.mlr.press/v267/aggarwal25a.html), *ICML 2025*, pp. 587–615. | ‡ Concrete categories/finite models; executable satisfaction; **bridge** (functor laws; exec ⟺ abstract)                              |
|   26 | Mon Nov 30 · post-Thanksgiving                                         | ↳ *(wk 13 — cont.)*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | ‡ **Institutions** — signature category; sentence & model functors; indexed satisfaction                                              |
|      | **▸ Week 14** · Part II · Lean prog. & proof — *tentative*             | *Dec 02 + Dec 07*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |                                                                                                                                       |
|   27 | Wed Dec 02                                                             | **Wk 14: Understanding Change, Evolution & Accountability.**<br>— Sillito, Murphy & De Volder, [“Questions Programmers Ask During Software Evolution Tasks”](https://citeseerx.ist.psu.edu/document?doi=3dda5d9a5e4eb27760e8a4a381a1057ce0ba7d65&repid=rep1&type=pdf), *FSE 2006*, pp. 23–34.<br>— Lehman, [“Programs, Life Cycles, and Laws of Software Evolution”](https://users.ece.utexas.edu/~perry/education/SE-Intro/lehman.pdf), *Proc. IEEE* 68(9), 1980, pp. 1060–1076.<br>— Parnas, [“Software Aging”](https://plg.uwaterloo.ca/~migod/846/papers/parnas-SwAging.pdf), *ICSE 1994*, pp. 279–287.                                                                                                                              | ‡ Institutions — package the semester's machinery as a concrete executable institution; **satisfaction condition**                    |
|   28 | Mon Dec 07 · last class                                                | ↳ *(wk 14 — cont.)*                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | ‡ **Endpoint** — prove the satisfaction condition; project synthesis & recoverability                                                 |

‡ **Part II topics (sessions 11–28) are tentative.** The per-topic pacing (≈3 sessions each) is
provisional. Part II keeps the discipline general theory → separate computable realization →
certified bridge.

---

## Course Policies

### Academic integrity

The UVa Honor Code additionally governs this course and is incorporated by reference herein.

### Use of Generative AI

You are responsible for mastering the concepts, languages, tools, and methods taught in this class.
You may use generative AI tools and search tools to assist you in doing homework assignments. If you
do, then you must include a statement at the end of your assignment summarizing your use of such
tools.

### Late work

No late work is accepted.

### Recording

You may not electronically record any aspect of this class—audio, visual, or otherwise—without the
express permission of the instructor. Nor may you distribute any authorized recordings of any aspect
of this class to anyone outside of this class. The instructor owns the copyright to all materials
used in this class. If you have needs for special accommodations that require that you record
aspects of this class as documented by SDAC then you have permission to make recordings to that
extent for your own use only.

### Students with disabilities or learning needs

It is our goal to create a learning experience that is as accessible as possible. If you anticipate
any issues related to the format, materials, or requirements of this course, please meet with me
outside of class so we can explore potential options. Students with disabilities may also wish to
work with the Student Disability Access Center (SDAC) to discuss a range of options to removing
barriers in this course, including official accommodations. We have an SDAC advisor, Courtney
MacMasters, located in Engineering. You may email her at <cmacmasters@virginia.edu> to schedule an
appointment. For general questions please visit the SDAC website:
<https://sdac.studenthealth.virginia.edu>. If you have been approved for accommodations through
SDAC, you may contact Prof. Sullivan to develop an implementation plan together.

### Religious accommodations

It is the University's long-standing policy and practice to reasonably accommodate students so that
they do not experience an adverse academic consequence when sincerely held religious beliefs or
observances or other highly important personal matters conflict with academic requirements.

Students who wish to request academic accommodation for such matters should submit their request to
Prof. Sullivan by email as far in advance as possible. Students who have questions or concerns about
such academic accommodations may contact the University's Office for Equal Opportunity and Civil
Rights (EOCR) at <UVAEOCR@virginia.edu> or 434-924-3200.

### Harassment, Discrimination, and Interpersonal Violence

The University of Virginia is dedicated to providing a safe and equitable learning environment for
all students. If you or someone you know has been affected by power-based personal violence, more
information can be found on the UVA Sexual Violence website that describes reporting options and
resources available — <https://www.virginia.edu/sexualviolence>.

The same resources and options for individuals who experience sexual misconduct are available for
discrimination, harassment, and retaliation. UVA prohibits discrimination and harassment based on
age, color, disability, family medical or genetic information, gender identity or expression,
marital status, military status, national or ethnic origin, political affiliation, pregnancy
(including childbirth and related conditions), race, religion, sex, sexual orientation, or veteran
status. UVA policy also prohibits retaliation for reporting such behavior.

If you witness or are aware of someone who has experienced prohibited conduct, you are encouraged to
submit a report to Just Report It (<https://justreportit.virginia.edu>) or contact EOCR, the office
of Equal Opportunity and Civil Rights.

If you would prefer to disclose such conduct to a confidential resource where what you share is not
reported to the University, you can turn to Counseling & Psychological Services ("CAPS") and Women's
Center Counseling Staff and Confidential Advocates (for students of all genders).

I care about you and your well-being and am ready to provide support and resources as I can. As a
faculty member, I am a responsible employee, which means that I am required by University policy and
by federal law to report certain kinds of conduct that you report to me to the University's Title IX
Coordinator. The Title IX Coordinator's job is to ensure that the reporting student receives the
resources and support that they need, while also determining whether further action is necessary to
ensure survivor safety and the safety of the University community.

### Support for your career development

Engaging in your career development is an important part of your student experience. For example,
presenting at research conferences, attending interviews for jobs or internships, or participating
in extern/shadowing experience are important steps on your path. I wish to encourage and support you
in activities related to your career development. To that end, please notify me by email as far in
advance as possible to arrange for accommodations.

### Student support team

You have many resources available to you when you experience academic or personal stresses. In
addition to your professor, the School of Engineering and Applied Science has staff members located
in Thornton Hall who you can contact to help manage academic or personal challenges. Please do not
wait until the end of the semester to ask for help!

**Learning**

- Director of Student Success (search underway)
- Courtney MacMasters, Accessibility Specialist

**Health and Wellbeing**

- Elizabeth Ramirez-Weaver, CAPS counselor
- Katie Fowler, CAPS counselor

You may schedule time with the CAPS counselors through Student Health
(<https://www.studenthealth.virginia.edu/getting-started-caps>). When scheduling, be sure to specify
that you are an Engineering student. You are also urged to use TimelyCare for either scheduled or
on-demand 24/7 mental health care.

**Community and Identity**

The Center for Diversity in Engineering (CDE) is a student space dedicated to advocating for
underrepresented groups in STEM. It exists to connect students with the academic, financial, health,
and community resources they need to thrive both at UVA and in the world. The CDE includes an open
study area, event space, and staff members on site. Through this space, we affirm and empower
equitable participation toward intercultural fluency and provide the resources necessary for
students to be successful during their academic journey and future career.
