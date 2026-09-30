/-
Not accepting outcomes that depend on assuming the existence of things that
you can't grab a hold of and show somebody

If you postulate that an object exists without proof, but in a way
that can't be disproved, you have a new axiom.

Axioms of ordinary mathematicians don't apply to this.

If you allow non-constructive proofs, you won't be able to get
executable code from proof cases.
-/

/-
True or false, given any proposition P, it's true that either P or not P is true.
- True, but only non-constructively
- Introduction rule of proofs of disjunctions, except with P or not P
- How to prove arbitrary disjunction P or Q? -> Need proof of P (or.inr) or a proof of Q (or.inl)
-- P or not P is a special case of P or ¬P (proof of P or proof of ¬P)
-- If you don't have either, can't prove the disjunction
- In constructive logic, need to know both P or ¬P is true, but need a proof of either
-- Constructive logic: To judge a proposition to be true, need an explanation of why it is true
- In prop/classical logic, it is just booleans, so you interpret as true/false with no other possibilities
-- Can only be boolean true or boolean false
- In constructive logic, can not know either way (middle ambiguous situation that you can be in)

In constructive logic (and predicate logic), also need to account for "exists":
- In predicate logic, have:
-- True
-- False
-- P, Q, R, etc. (not propositional variables in boolean sense)
-- And, Or, Not (combinators)
-- Implies →
-- ⇔ (bi implication)
-- For all (∀)
-- Exists (∃x Px), some object satisfies some proposition P
  - Choice problem: to make construct go through, has to be true that if there is an infinite collection of sets
    there is a set that you can construct from one non-empty element chosen from each set
  -- Not always an algorithm for choosing from one of each set
  -- Need axiom of choice (assume that it's true)
-
-/

-- Warm up exercise
theorem noContradiction {P : Prop} : ¬(P ∧ ¬P) :=
  fun PandNotP =>
    let p : P := PandNotP.left
    let np : ¬P := PandNotP.right
    np p

/-
- Top level connective is negation (¬)
- Elimination rules for that connective:
-- Ex: → : assumes P, returns Q:
    applies function to something
- Figure out what introduction and elimination rules pertain to that
  connective
- In this case, need to prove a negation
  - Assume that it is true, assume assumption leads to contradiction
  - Allows you conclude that it's false, which leads to negation being true
- Use *Proof by negation*
  - Assume P, leads to conclusion that derives false, then prove not P
  - Derive contradiction, assume not P is false, then negate to prove true
  - Assume the premise (P and ¬P), and show that leads to a contradiction
- Also
  - pandnotp is a pair of proofs of type P and ¬P
  - Can extract elements from left and right
  - Need a proof of false; apply np to p (term is applied false)
  - np is a function, since it is a proof of a negation
    - Assume what you are trying to negate, derive a contradiction, then
      assume negation of proposition is true
- Proof by negation always used to prove negation (¬P)
-/


/-
*Proof by contradiction

- Want to prove P by assuming ¬P, in which you derive a contradiction
  - Show ¬P implies false; proves ¬(¬P)
  - Proof by negation that is embedded in proof by contradiction
    - Every proof by contradiction includes a proof by negation
- *Negation*: To prove ¬P, assume P, show contradiction, conclude ¬P
- *Contradiction*: to prove P, assume ¬P, show contradiction, conclude ¬(¬P)
  - Instance of proof by negation
  - When you try to prove ¬¬P:
    - In classical logic, it is always P
    - However, ¬¬P → P is not always constructively valid
      - Need to show ¬(P → False), or *(P → False) → False*
      - No proof of P or ¬P in this context, so no way to finish proof
- Negation elimination ¬¬P → P is not true constructively

Doesn't give proof of P, so not constructively valid
- How does this show that proof by contradiction won't work
- Shows ¬P is false, but no proof of P to extract
-/

example {P : Prop} {em : ∀ (X : Prop), X ∨ ¬X}  : ¬¬P → P :=
  fun nnp =>
    match em P with
    | Or.inl p => p
    | Or.inr notP => False.elim (nnp notP)

theorem deMorganNotOr (P Q : Prop) : ¬(P ∨ Q) → (¬P ∧ ¬Q) :=
  fun notPorQ => -- Assume proof of left side
    And.intro -- Apply to 2 subgroups/subgoals
      (fun p => notPorQ (Or.inl p))
      -- Proof of ¬P: function to false, assume proof of P and derive proof of false
      -- Apply ¬(P ∨ Q) to ¬P, as ¬(P ∨ Q) can give you a proof of false; enough to get a proof of P
      -- Need something to feed function, then look around to get a proof of P
      -- Top-down type-guided refinement; apply function to argument
        -- In this case, apply to the left side of And
      (fun q => notPorQ (Or.inr q)) -- Proof of ¬Q: function to false, assume proof of Q and derive proof of false

theorem deMorganAndNot (P Q : Prop) : (¬P ∧ ¬Q) → ¬(P ∨ Q) :=
  fun notPandNotQ =>
    fun porq =>
      match porq with
        | Or.inl p => notPandNotQ.left p --Constructed with proof of p; p contradicts ¬p
        | Or.inr q => notPandNotQ.right q  --Constructed with proof of q; q contradicts ¬q
/-
Use proof of or to show that, no matter which way proof was constructed,
conclusion follows.  In other words, need an answer in both cases.

Do case analysis to show that it follows in each case ("match").
- In either case, get contradictions and proofs of false
- Introducing left side of or statement; use function of not p to prove that given p has to be false (left side of or statement has to be false)
-/

theorem deMorganNotorIff (P Q : Prop) : ¬(P ∨ Q) ↔ (¬P ∧ ¬Q) :=
  Iff.intro (deMorganNotOr P Q) (deMorganAndNot P Q)

/-
Equivalence ( ↔ )
- Prove P → Q and Q → P

Intro:
- Iff.intro (proof of forward imp and backwards imp, then will type check as proof of bi-implication)
- If we know expressions are equivalent, can replace one expression with another expression
  - Can be more optimal
  - Optimizations are justified by proofs (leave equivalent result)

In this case:
- Assume two particular arguments as propositions
- Left side: P → Q
- Right side: Q → P
-/


-- Embed into lean file a construction that produces type error without getting type error
-- Way of showing piece of code that doesn't work
#guard_msgs in
example (P Q : Prop) : ¬(P ∧ Q) → (¬P ∨ ¬Q) :=
  fun notPandQ =>
    Or.inl (fun p => notPandQ (And.intro p _))

/-
-- Get stuck, since knowing both are not true doesn't tell which one is false
-- Can't prove that any particular one is false; not enough information to derive proof that
   one of them is false
-- Don't have enough info on left to construct proof on right
-- Classically, this is true
-- Often useful to add additional condition on the left to make proof go through
  -- This will weaken condition on the left
-/

/-
To make it go through, for any proposition x, can have, for free, a proof of x or ¬x
- Proof of an OR, so you can do a case analysis
- em: No matter what proposition you give, it will either by true or false, not matter what you get
  - Takes any prop X, and gets a proof of X or ¬X for free (don't need a proof of either, since it is an assumption)
  - Known as the *Law of Exclusive Middle*; any proposition is literally only true or only false
    - Removes possibility of not knowing the answer
    - Makes double negation valid
-/

def neg (a : Prop) : Prop := a → False

-- HW:
example (P Q : Prop) {em : ∀ (X : Prop), X ∨ ¬X} : ¬(P ∧ Q) → (¬P ∨ ¬Q) :=
  fun NotPAndQ =>
    let PorNotP := em P
    let QorNotQ := em Q

/-
    Or.inl (fun h => NotPAndQ (And.intro
      (match PorNotP with
        | Or.inl p => p
        | Or.inr notP => False.elim (notP h)
      )
      (match QorNotQ with
      | Or.inl q => q
      | Or.inr notQ => False.elim (notQ h)
      )
    ))
-/


  Or.inl (fun h => match PorNotP with
    | Or.inl p => match QorNotQ with
      | Or.inl q => NotPAndQ (And.intro p q)
      | Or.inr notQ => False.elim (NotPAndQ (And.intro p q))
    | Or.inr notP => match QorNotQ with
      | Or.inl q => False.elim (NotPAndQ (And.intro h q))
      | Or.inr notQ => False.elim (NotPAndQ (And.intro h notQ))
  )




theorem proofByContradictionFromExcludedMiddle : (∀ P : Prop, P ∨ ¬P) → (∀ P : Prop, ¬¬P → P) :=
  fun em =>
    fun P =>
      fun notNotP =>
        match em P with
        | Or.inl p => p
        | Or.inr notP => False.elim (notNotP notP)
-- Want to conclude P from ¬¬P, valid with axiom of excluded middle
-- Allows reduction to be valid
