/-
Hoare Logic: Run commands sequentially to get to new state.
- Whenever statement satisfies prereq, you end up in the corresponding desired state,
and you have a proof of correctness in program.

From this class, if you go read Ben Pearson's book "Software Foundations Online", it
is all about getting you up through Hoare logic.
- First book is logical foundations
- Second book is semantics of imperative code

Separation Logic: Adds the notion of a heap; each command updates state as a consequence
of the previous state

Notion of indexing (ex: indexing into array) -> Hoare Logic

High end of programming language research committee has used book to teach basics
of predicate logic, inductive types, recursion principles, etc.
- Extension of predicate logic
- Big programs are big statement, but can be separated into smaller statements
- Satisfying prereq predicate satisfies postcondition predicate
- If you start in a state where you have a graph G, and graph is acyclic, you will
have an answer where you end up in the same place in memory
-/

/-
GraphFold
- Moving into a world where we can abstract things in interesting ways
  - Notion of generalized fold over trees, options, etc.
  - GraphFold is variant of underlying recursive structure, but very different
- Just because it is formalized and verified doesn't mean that you formalized and verified
the right thing
  - In this case, the AI formalized the GraphFold, left off acyclicity condition, and put
  condition in GUI.
  - Core formalism didn't check whether it was acyclic; acyclic check was put in parser
- Software was verified, but it wasn't valid
  - Going forward, if you give AI high level theorem statement, and tell it to go prove it,
  it can generate 43 lines of code to prove it
    - High level statement of proof is validated
  - All sorts of things that can go wrong
  - Can't afford not to spend considerable effort verifying that "valid" code isn't
  valid
- AI systems are engineered to please
  - Industry has learned to get people addicted to psy-ops
  - AI will never tell you when it doesn't know how to do something
  - Have to think critically when using AI systems
- Distinction between validation and verification is enormous
  - Verification is now not solved, but pretty well in hand
  - Validation is not solved
- If you are interested in philosophical concepts in engineering, read Henry Petrosky's
book on engineering
  - "Design Paradigms"
  - Principle obligation of any engineer is to anticipate and avoid failure that would cause
  unacceptable harm to the public
  - Responsibility of engineers to protect public against avoidable and unacceptable harms
    - Whole culture has been moved off of that system
    - Ex: Failure to account for redundancy
  - Eventually, will come out that they injected vibe-coded systems into massive environment
- When you leave here, you will be asked to do AI stuff if you are developing code
  - Go read Design Paradigms for a history of engineering failures
  - Will have to be a return to commitment to validation of systems for essential
  dependability requirements
- Ability to produce verified components (proof-checked componentry) has to be used
in a way that is responsible and understanding of what can go wrong
- Fred Brooks: "Mythical Man Month"
  - His view was that software engineering, as it stood at the time and even today,
  is an optimistic discipline, but not sufficiently pessimistic to think systematically
  about what can go wrong
    - "No Silver Bullets"
  - Without essential engineering common sense that, if your construction is not valid,
  many things can go wrong
    - Have to take it as an obligation that job as an engineer isn't just to code, but rather
    to recognize and avert/avoid catastrophic failures

- What do you judge to be "an acceptable level of harm"?
  - Social process that led to conclusion that having airplanes run into ground
  because of software is unacceptable
    - Software development regulations were built around development of software that
    catastrophic failures not happen every 10^-9 failures/hour (i.e. more than lifespan
    of fleet of jets)
    - If it does, then it will lose faith, confidence, and trust in jet transport, which
    would be catastrophic to industry
- Notion of unacceptable level of failure that you engineer against the social construct
- Who's deciding?
  - Initially, big social, public process
  - Now, it is decided and embraced by higher-ups and shareholders
  of the respective companies
    - Not the engineers
- Learn a much richer composure of types than ever before
  - Lean lets you encode, into types, great level of depth and abstractness
  - Implementation is basic functional programming

Graph Fold (again):
- Can compute a quantity from a given vertex v as an initial value associated with
vertex + recursive result from all incoming edges
  - Computing some kind of fold sum until you get to end of graph
- Eventually, get very different answers
- If you pick OR as semi-ring, you get a question of whether or not there is a path
from here to there
- If you substitute natural numbers as semi-ring, question of number of paths from here
to there
- If you substitute tropical semi-ring, you get the minimum cost to get from here to
there (shortest path cost, but not the path itself)
- If you use list of natural number weights where append is plus and points are added
parallelized, you get computation where, at each node, you get list of costs to
get there from each incoming edge
  - Remembers where you came from
  - Can tell you the shortest path and remembers it
  - Accumulates spectrum of costs for every possible path to graph
-
-/
