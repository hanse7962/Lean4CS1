# Existential Quantification
The previous chapter introduced *predicates*: functions from
values to propositions, `P : α → Prop`. A predicate is a family
of propositions, one for each value of α, and it becomes a
definite claim only when applied to a particular value.

Predicates are what the quantifiers quantify over. `∀ x : α, P x`
says that every value of α satisfies P. `∃ x : α, P x` says that
at least one does. This chapter is about the second of these.

Like every connective we have studied, `∃` comes with an
*introduction* rule, telling us how to build a proof, and an
*elimination* rule, telling us how to use one. We take them in
that order, first on a small concrete example, then in general.
## Introduction: Exhibiting a Witness

An existential proof is a pair: a value, and evidence about that
value. We build up to that rule on a concrete example, state it,
and then exercise it in other settings.
### A Concrete Setting

Here is a type with three values and two predicates on it, each
given as an inductive family. Read each constructor as a piece of
evidence: `Friendly` has evidence for Iris and for Fido, and none
for Sargent. `Furry` has evidence for Iris and for Sargent.
```lean
inductive Dog : Type where
| Iris
| Fido
| Sargent

open Dog

inductive Friendly : Dog → Prop where
| irisFriendly : Friendly Iris
| fidoFriendly : Friendly Fido

inductive Furry : Dog → Prop where
| irisFurry : Furry Iris
| sargentFurry : Furry Sargent
```

Iris is both friendly and furry, and we can prove it by pairing
the two pieces of evidence.
```lean
example : Friendly Iris ∧ Furry Iris :=
  -- Remember here ⟨_,_⟩ is shorthand for And.intro
  ⟨ Friendly.irisFriendly, Furry.irisFurry ⟩
  -- Notation usable for any one-constructor type
```

We can name that compound property as a predicate of its own.
These two definitions say the same thing; the first writes the
predicate as an explicit function, the second takes the argument
on the left.
```lean
def Suitable' : Dog → Prop := fun d => (Friendly d ∧ Furry d)

def Suitable (d : Dog) : Prop := (Friendly d ∧ Furry d)

-- Hey, Iris is suitable!
example : Suitable Iris :=
  And.intro Friendly.irisFriendly Furry.irisFurry

#check (Suitable)
#check (Friendly)
#check (Furry)
```

### Where ∀ Fails and ∃ Succeeds

Contrast the two quantifiers on this setting. Is *every* dog
friendly? No: we have no evidence that Sargent is friendly, and
the attempt gets stuck in exactly that case. The two branches we
can fill are filled; the hole shows what is missing.

`#guard_msgs` checks the expected error, so this intentionally
unfinished attempt does not prevent the file from compiling.
```lean
/--
error: don't know how to synthesize placeholder
context:
d : Dog
⊢ Friendly Sargent
-/
#guard_msgs in
example : ∀ (d : Dog), Friendly d :=
  fun d =>
    match d with
    | Iris => Friendly.irisFriendly
    | Fido => Friendly.fidoFriendly
    | Sargent => _
```

In fact the universal claim is refutable. Assume it, apply it to
Sargent, and we obtain a purported proof of `Friendly Sargent`.
No constructor of `Friendly` could have produced such a proof, so
`nomatch` discharges the case and we have our contradiction.
```lean
example : ¬(∀ (d : Dog), Friendly d) :=
  fun allDogsFriendly =>
    let sf := allDogsFriendly Sargent
    nomatch sf
```

The existential claim, by contrast, is easy. Is *some* dog
friendly? Yes, and to show it we name one and supply its evidence.
To prove that something exists, produce it, then show that it
works.
```lean
example : ∃ (d : Dog), Friendly d :=
  Exists.intro Iris Friendly.irisFriendly
```

### The Rule Behind That Proof

That pair of things, a value and a proof about that value, is all
an existential proof ever is. So where does `Exists.intro` come
from? It is just the constructor of an inductive type, like every
introduction rule we have used. Here is Lean's definition of
`Exists`, copied under a new name so that it compiles here without
clashing with the library's.
```lean
inductive MyExists {α : Sort u} (p : α → Prop) : Prop where
| intro (w : α) (h : p w) : MyExists p
```

One type, one constructor, so there is exactly one way to build a
proof. Read the pieces. `MyExists` takes the *predicate* p as a
parameter, not a value, which is what makes it a claim about some
value of α rather than about a particular one. Its constructor
takes two arguments: a *witness* `w : α`, and `h : p w`, evidence
that p holds of that very w. Note that the type of the second
argument depends on the first. That is the introduction rule, and
it is the entire content of an existential proof.

The library's `Exists` is this same type, and its `intro` has
exactly the signature just described.
```lean
#check @Exists
#check @Exists.intro
```

Now match our dog proof against the rule. The predicate is
`Friendly`, so α is `Dog`. We supplied `Iris` for w and
`Friendly.irisFriendly` for h, and Lean checked that the latter
really is a proof of `Friendly Iris`, the predicate applied to the
witness we chose. Had we offered `Sargent` as the witness, the
second argument would have had to be a proof of `Friendly Sargent`,
and we have none to give.

The evidence can be compound, since h is only ever required to
prove `p w`, whatever proposition that turns out to be. To prove
that some dog is suitable, exhibit Iris together with a proof of
the conjunction.
```lean
example : ∃ (d : Dog), Suitable d :=
  Exists.intro Iris (And.intro Friendly.irisFriendly Furry.irisFurry)
```

### The Same Rule, More Examples

Nothing about the rule is special to dogs. Here it is on `Nat`,
where the witness is a number and the evidence is a proof about
that number.
```lean
example : ∃ n : Nat, n = 3 :=
  Exists.intro 3 rfl

example : ∃ n : Nat, n + 1 = 4 := Exists.intro 3 rfl
```

The angle-bracket notation `⟨w, pf⟩` is Lean's *anonymous
constructor*: it means "apply the sole constructor of the expected
type to these arguments." For an existential it means exactly
`Exists.intro w pf`. We used it for `And.intro` above, and it
works here for the same reason: one constructor, so there is
nothing to disambiguate.
```lean
example : ∃ n : Nat, n + 1 = 4 := ⟨3, rfl⟩
example : ∃ n : Nat, n > 3 := ⟨4, Nat.le.refl⟩
```

Nested existentials are nested pairs, and the anonymous
constructor notation nests to match.
```lean
example : ∃ a : Nat, ∃ b : Nat, a + b = 5 := ⟨2, 3, rfl⟩
```

### Which Witness? The Proposition Does Not Say

One last observation, and it is a crucial one. The *proposition*
`∃ n : Nat, n < 10` records only that a witness exists. Two proofs
can use different witnesses and still prove the very same
proposition, and nothing in the proposition tells us which one was
used.
```lean
example : ∃ n : Nat, n < 10 := ⟨0, Nat.zero_lt_succ 9⟩
example : ∃ n : Nat, n < 10 := ⟨9, Nat.le.refl⟩
```

Hold on to that point. It is the reason the elimination rule, the
subject of the next section, comes with a restriction.
## Elimination: Unpack the Witness

To *use* a proof of `∃ x : α, R x`, take it apart. Because there
is only one constructor, a proof must have been built as
`Exists.intro w pf`, so we may pattern match to recover a name
w for the witness and a proof pf of `R w`, then use them to build
whatever we are trying to prove.

Two constraints govern this unpacking. First, w is a *local*
name, bound only inside the branch of the match. Second, and as a
consequence, the goal being proved must be stated without
mentioning w: we are proving one fixed conclusion no matter which
value was hidden inside.

Here is the general rule, stated and proved by matching. Read the
second hypothesis as "whatever the witness turns out to be, it
lets us conclude S."
```lean
example {α : Type} (R : α → Prop) (S : Prop) :
    (∃ x : α, R x) → (∀ x : α, R x → S) → S :=
  fun existsRx =>
    fun useWitness =>
      match existsRx with
      | Exists.intro w pf => useWitness w pf
```

The same rule is packaged in the standard library as
`Exists.elim`, so this pattern need not be rewritten each time.
```lean
#check @Exists.elim

example {α : Type} (R : α → Prop) (S : Prop)
    (h : ∃ x : α, R x) (k : ∀ x : α, R x → S) : S :=
  Exists.elim h k
```

Anonymous constructor notation works in patterns, too, which makes
`fun ⟨w, pf⟩ => ...` the idiomatic way to eliminate an existential
in term mode. In the next example we weaken what we know about the
witness: we keep the same witness and upgrade its evidence.
```lean
example {α : Type} (P Q : α → Prop) (imp : ∀ x : α, P x → Q x) :
    (∃ x : α, P x) → (∃ x : α, Q x) :=
  fun ⟨w, pw⟩ => ⟨w, imp w pw⟩
```

Patterns nest, so a conjunction inside an existential can be
unpacked in the same binder. Here we eliminate an existential and
then immediately introduce a new one, reusing the witness we were
handed.
```lean
example {α : Type} (P Q : α → Prop) :
    (∃ x : α, P x ∧ Q x) → (∃ x : α, Q x ∧ P x) :=
  fun ⟨w, pw, qw⟩ => ⟨w, qw, pw⟩
```

Existentials and negation combine as expected. A witness that
*fails* a predicate refutes the claim that the predicate holds
universally: unpack the counterexample, apply the universal claim
to that witness, and hand the result to the negation. The
refutation of `∀ (d : Dog), Friendly d` above was this rule,
specialized to Sargent.
```lean
example {α : Type} (P : α → Prop) :
    (∃ x : α, ¬P x) → ¬(∀ x : α, P x) :=
  fun ⟨w, notPw⟩ =>
    fun allP => notPw (allP w)
```

## The Boundary: A Witness Is Not Data

Finally, the boundary. The witness genuinely cannot escape the
match. `Exists` lives in `Prop`, so a proof of an existential may
be taken apart to build another *proof*, but not to compute a
*value*. The following is rejected by Lean, and the error is worth
reading: `recursor Exists.casesOn can only eliminate into Prop`.
We were asking proof-level evidence to yield data. It is left
commented out because its full error text includes metavariable
numbers that shift between Lean versions.
```lean
/-
example : (∃ n : Nat, n > 3) → Nat :=
  fun ⟨w, _⟩ => w
-/
```

This is the same phenomenon we met with classical negation
elimination. `∃` is a logical claim of existence. When we want a
witness *as data*, usable in later computation, we need a value in
`Type`, such as a `Subtype` or a dependent pair `Σ`, rather than a
proof in `Prop`.
## Nonconstructive Existence

Everything above introduced an existential by exhibiting a
witness. Classically, we can also prove existence *by
contradiction*, without constructing anything: assume that no
such x exists, derive False, and conclude that one does. This is
our earlier double-negation elimination with `∃ x, R x`
substituted for P. See `E05_ClassicalVsConstructive.lean` for an
introduction to `open Classical` and the `em` it provides.
```lean
open Classical

example {α : Type} (R : α → Prop) :
    (¬(∃ x : α, R x) → False) → ∃ x : α, R x :=
  fun notNotExists =>
    match em (∃ x : α, R x) with
    | Or.inl existsRx => existsRx
    | Or.inr notExists => False.elim (notNotExists notExists)
```

Read what this proof does and does not deliver. It establishes
the proposition `∃ x : α, R x`. It names no witness, and there is
nothing in it to run. The next section makes that cost concrete.
### A Concrete Case: Is There an Odd Perfect Number?

Before any Lean, here is the question.

Call a positive number *perfect* if it is the sum of its proper
divisors, meaning its divisors other than itself. 6 is perfect:
its proper divisors are 1, 2, and 3, and 1 + 2 + 3 = 6. So is 28,
since 1 + 2 + 4 + 7 + 14 = 28. Perfect numbers appear in Euclid's
*Elements*, so people have been studying them for a very long time.

Every perfect number anyone has ever found is even. Nobody has
produced an odd one, and nobody has proved that none exists. This
is not for lack of effort: it is known that an odd perfect number,
if there is one, must be greater than 10^2200, and must satisfy a
long list of further constraints. The question

  Is there an odd perfect number?

is one of the oldest unresolved questions in mathematics.

Hold that question in mind. It is an existential claim, so this
chapter has given us two ways to try to settle it. We can exhibit
a witness, or we can go classical. Watch what each one delivers.
First, the part that is ordinary programming. Summing the proper
divisors of a number is a computation. Every proper divisor of n
is smaller than n, so it suffices to scan the numbers below n.
Don't worry about the programming of this function for now.
```lean
def sumProperDivisors (n : Nat) : Nat :=
  (List.range n).foldl
    (fun acc d => if d > 0 && n % d == 0 then acc + d else acc) 0

def isPerfect (n : Nat) : Bool := n > 0 && sumProperDivisors n == n
```

These are total functions, and we can run them. Lean prints the
results below, and `#guard_msgs` checks that they are what we
claim they are.
```lean
#eval sumProperDivisors 28

/-- info: true -/
#guard_msgs in
#eval isPerfect 28
```

Searching a *bounded* range is also ordinary programming. Here
are all the perfect numbers below ten thousand. This is a real
mathematical result about a finite range, and the code that
produced it is the evidence: we can rerun it, and we can read it
to see what it checked.
```lean
/-- info: [6, 28, 496, 8128] -/
#guard_msgs in
#eval (List.range 10000).filter isPerfect
```

Look at that output: 6, 28, 496, 8128. Every one of them is even.
That is the observation that makes the open question interesting,
and we just computed it ourselves.

Testing whether a *given* number is an odd perfect number is
equally ordinary. 28 is perfect but even, so it fails.
```lean
def isOddPerfect (n : Nat) : Bool := n % 2 == 1 && isPerfect n

/-- info: false -/
#guard_msgs in
#eval isOddPerfect 28
```

So far nothing is in doubt. Each function above carries executable
content, and every answer we got came out of running it.

Now state the open question as a proposition. It is exactly an
existential: not a claim about any particular n, nor about any
finite range of them, but the claim that some n works.
```lean
def SomeOddPerfect : Prop := ∃ n, isOddPerfect n = true
```

To prove this the way the introduction rule asks, we would write
`⟨w, pf⟩` for some specific numeral w, together with a proof that
`isOddPerfect w = true`. Nobody can fill in that w. A witness
would settle a question that has stood for centuries, and if one
exists it has more than 2200 digits.

Now watch how cheap the classical route is. A single application
of excluded middle settles the disjunction, right now, with no
search and no witness whatsoever.
```lean
theorem oddPerfectOrNot : SomeOddPerfect ∨ ¬SomeOddPerfect :=
  em SomeOddPerfect
```

That is a complete proof, and Lean checks it. Read carefully what
we have and what we do not have. We have a proof that the question
has an answer. We do not have the answer. No n comes out of
`oddPerfectOrNot`, and there is nothing in it to run. A question
that has resisted mathematicians for centuries was not settled
here; only the claim that it has *some* answer was, and that claim
was free.

The gap turns into a compiler error the moment we try to *use* the
answer in a program. Recall the `open Classical` above, which
brings `Classical.propDecidable` into scope. That makes every
proposition count as `Decidable`, so the `if` below typechecks:
Lean accepts it as a well-formed program that branches on whether
an odd perfect number exists. Then code generation runs, and fails.
The error names exactly what is missing.
```lean
/--
error: failed to compile definition, consider marking it as 'noncomputable' because it depends on 'propDecidable', which is 'noncomputable'
-/
#guard_msgs in
def oddPerfectAnswer : String :=
  if SomeOddPerfect then "one exists" else "none exists"
```

We are allowed to keep the definition if we mark it
`noncomputable`, because that marking is an honest declaration
that no code will be produced for it. The definition is then
accepted, and `#eval` still cannot run it.
```lean
noncomputable def oddPerfectAnswer' : String :=
  if SomeOddPerfect then "one exists" else "none exists"

/--
error: failed to compile definition, consider marking it as 'noncomputable' because it depends on 'oddPerfectAnswer'', which is 'noncomputable'
-/
#guard_msgs in
#eval oddPerfectAnswer'
```

Compare the two halves of this example. `isPerfect` and the
bounded filter are constructions: they carry executable content,
and we extracted real answers from them. `oddPerfectAnswer` is a
proof dressed up as a program. The constructive reading of `∃`
demands a witness and would have given us the answer along with
the proof. Classical logic gave us the proposition "this question
has an answer" for free, and gave us no way to compute it. That is
the price of nonconstructive existence, paid in code.

One caution about what this example does and does not show. For
this one fixed question, some constant program is correct: either
"one exists" or "none exists" is the right answer, and we simply
do not know which. So what failed here is *extraction*. The
classical proof does not hand us a program, even though a correct
program exists.

### Another Example: The Halting Problem

The stronger claim is about `em` read uniformly, as the machine
`∀ P : Prop, P ∨ ¬P` that answers for *every* P. No such machine
can have executable code. To see why, specialize it to
propositions of the form `∃ n, f n = true` for an arbitrary
`f : Nat → Bool`, which is the shape of `SomeOddPerfect`. A
program implementing that case would decide whether an arbitrary
computation ever succeeds, and that is the halting problem, which
is known to be undecidable. So the absence of code behind `em` is
not a gap in Lean's implementation that a better compiler might
close. It is a theorem about computation.
### A Provocation: Banach–Tarski

The Banach–Tarski theorem (1924) says that a solid ball in
three-dimensional space can be partitioned into finitely many
sets, then those sets moved by rotations and translations to
form two disjoint balls, each the same size as the original.
The usual proof uses the axiom of choice. The pieces cannot all
have ordinary volume: nonmeasurable sets are involved. This is
a theorem about sets of points, not a physical recipe for cutting
up a ball and doubling its material.
See [Banach and Tarski's original paper](https://pldml.icm.edu.pl/pldml/element/bwmeta1.element.bwnjournal-article-fmv6i1p27bwm)
and [Terence Tao's explanation](https://www.math.ucla.edu/~tao/resource/general/121.1.00s/tarski.html).

It vividly illustrates the constructive objection: what counts
as evidence that these pieces exist if we cannot construct them
in the required sense? A constructivist does not have to accept
the classical proof as a constructive existence proof. The issue
is the justification of existence, not merely that the conclusion
is surprising. Excluded middle alone should not be confused with
the choice principle used in the Banach–Tarski argument.

Historically, this did not launch constructive mathematics:
Brouwer's foundational work dates to 1907–1908, before this
theorem. Use Banach–Tarski as an illustration of the demand for
construction that motivated constructive approaches, rather than
as their historical cause. Heyting later formalized intuitionistic
(constructive) logic. See [the history of intuitionistic logic](https://plato.stanford.edu/entries/intuitionistic-logic-development/).

<div class="issue-box">📝 <a href="https://github.com/kevinsullivan/Lean4CS1/issues/new">Report an issue</a> with this section</div>

