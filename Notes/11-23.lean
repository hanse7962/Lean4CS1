import Mathlib.Order.BooleanAlgebra.Set
/-
Vacuous Proof: Somewhere in proof, there is a critical lemma that is false, but
causes everything else to go through.
- As humans who are accountable for failures, you have to understand what some of
the failure modes are
- Think about how to modularize proofs so that pieces are comprehensible
  - Can't be 43 million lines of spaghetti code
  - Not good at modularity, architecture, and separation of concerns
- Goal is to understand the big picture, understand the principles, how it works,
what the major issues are, etc.

## Set Theory
For at least 125 longer, since people like Cantor and others, the axiomatic foundation
of mathematics has been "set theory", not "type theory"

Set theory:
- Inference rules
- Axioms (info)
  - Needs to be computable
  - Not good for building proof assistants
  - Type theory, with its own set of axioms, is a better foundation for building
  an expressive theory for computational analysis and proof checking
  - Incredibly minimal
- Axioms (definitions)
  - Dependent functions
  - Quotient types
- Libraries built on top

Dependent-type theory
- Up to this point, "if n is a nat, you can have a downstream type that depends on
that Nat"
  - Can talk about Lists of length N
- Generalizes to "contexts"
  - In infoview, the stuff above turnstyle is context
  - Context gets built-up one element at a time
  - For each argument you process, you add that to context
    - Can depend on value already in context
    - Have telescoping contexts that are nested one inside each other
  - In contrast to non-dependently typed languages, gives you expressiveness that you
  need to represent a huge variety of propositions and dependently typed and typed
  checked objects
- If you define a type class for a group, can let α be Nat, then let a be a value of
type Nat

Set Theory:
- What many mathematicians have used for centuries; incredibly important
  - Almost any formal specification in last hundred years will assume set theory
  - Collection of formal specification languages that had basis in set theory
  - Added additional functionality, but the only thing you could do practically was
  syntax check them
    - Syntax of languages looked like APL
- Famous early programming language, since you could be very concise about implementations
of algorithms, but couldn't really get past first 10 characters of program easily
- Question: How to formalize set theory to make it useful, but also machine readable and
checkable in type theory?
  - Can shallow embed set theory into type theory
- Will represent sets as *"membership predicates"*
  - To represent the set {1, 2, 3}, set theory has an operation called "membership"
  (ε)
  - Ex: 4 ∈ {1, 2, 3} → False (4 is not a member of the set)
    - Can generalize from explicit parameter to formal parameter
    - fun x => x ∈ {1, 2, 3}
-/

def M :=
  fun x => x = 1 ∨ x = 2 ∨ x = 3

/-
-- M 3 -> substitute 3 for x, so it returns a proposition
  -- Enters 3 + 1, which gets reduced
  -- Substitute actual parameter for formal parameter
  -- When you apply generalized function to actual function, substitute 3 for x,
  -- and you get 3 ∈ {1, 2, 3}

When we have a function from value to proposition, you have a predicate.
- In this case, we have a membership predicate, which asserts that the value is in
the set
- How do we represent a set {1, 2, 3}?
  - We will represent it as its membership predicate, which you can then apply to a value
  to assert that the value is in the set.
  - Nat → Prop => {1, 2, 3}
    - Function from values to proposition
    - Could use x == 1 or x == 2 or x == 3
    - Predicate that takes an X, then yields the above propositions
    - Apply the function to 5 (takes 5 as argument), gives False
  - Would use Or.inr to prove 2 = 2 or 2 = 1
- To represent the set {3, 4, 5} as a predicate, use:
  - fun x => x = 3 ∨ x = 4 ∨ x = 5
  - No "exists" here; for this set, x is a member of this set if x == <value>
  - To prove that 2 is in the set, apply the predicate x = 1 or x = 2 or x = 3 to 2
    - Get 2 = 1 or 2 = 2 or 2 = 3
    - With {}, always results in a proposition that is a disjunction of terms
- To represent the set of all even natural numbers:
  - n mod 2 = 0 => predicate
    - Feed in n, then get back proposition
  - fun n => n % 2 = 0
- If you want to represent the set of natural numbers that are not zero
  - fun x => ¬(x = 0)
-/

def EvenNum :=
  fun n => n % 2 = 0

def NotZero :=
  fun x => ¬(x = 0)

/-
Will represent a set of α's as a predicate on terms of type α

Apply a predicate to a value for which there is or isn't a proof
- If there is a proof, value is satisfied and it is in the set
- If not, then the value is not in the set

To represent Set:
- Would have array/list/etc., would need to handle duplicates and ordering
- One of the key axioms of type theory is the notion of a *quotient*
  - *Quotient* => If you represent sets as lists, you will need to compare 2 lists,
  but you will have to ignore both ordering and duplicates
  - In type theory, the real type you are interested in is the type of lists, mod, and
  duplicates
    - You consider all lists to be equivalent if they have the same if they have the
    same members or if they have duplicates
  - With this computable representation of sets, you have to apply the predicate to
  a value, get the proposition, then prove it
    - Have to do something by hand, which is not like asking Java whether a value is
    in a set
  - Cannot represent entire set of natural numbers
    - Computable representations are very limited; can't encode infinite sets unless
    you do it as a computable proposition
    - Ex: set of even numbers can be represented as a predicate
    - Ex: set of all Java programs that terminate → can't write computation that
    answers that question, but can write proposition to track whether program terminates
      - Much richer and uniform manner when you move to abstract reasoning
-/


def Set' (α : Type u) : Type u := α → Prop
/-
Represent set of objects in type α as a predicate from objects of type
α to Prop.

A set 's : Set α' is its membership predicate.
- If s is a predicate on values of type α, how do you write the proposition that
a is in S? -> Write s a
  - 3 ∈ S desugars to S 3
- To show "x ∈ S", define it to be the predicate (S) applied to the value (x)
  - If proposition is false, then you've shown that x is not in S
  - {1, 2, 3} is notation for a special case, where you give an enumeration of the values
    - Known as "display notation"
    - Desugars to x = 1 ∨ x = 2 ∨ x = 3
      - Can use any and all of predicate logic to express membership predicates
      - Ex: x > 0 ∧ x < 4
      - The two propositions are equivalent, so you would need a proof of equivalence
    - Can just show that the propositions are equivalent, can't show that they're equal
    unless you import an axiom
- All standard set theory notion have reductions to corresponding predicate logic.

-/

def P : Nat → Prop := fun x => x = 1 ∨ x = 2

-- 2 == 1 or 2 == 2
-- Or.inr (prove right-hand side, then reflect)
example : P 2 := Or.inr rfl

example : M 3 := Or.inr (Or.inr rfl)

def Small : Set Nat := fun x => x = 3 ∨ x = 5

-- 3 == 3 or 3 == 5
--example : (3 : Nat) ∈ Small := Or.inl rfl



/-
Brace notation:
{1, 2, 3} -> Take empty set {}, then insert 1 (insert 2 {3})
- Iterates insert operation over elements to build up set piece-by-piece
- Building up disjunction turn by turn by turn
-/

theorem mem_insert_iff (x a : α) (s : Set α) :
    x ∈ insert a s ↔ x = a ∨ x ∈ s :=
  Set.mem_insert_iff

theorem mem_singleton_iff (x a : α) :
    x ∈ ({a} : Set α) ↔ x = a :=
  Set.mem_singleton_iff

/-
Tactic Mode:
- "Tactic" -> Library routine that does some of your proving for you
- Huge library of tactics
  - Think about what tactics you have available
- Tactics are little programs that get run that try to figure out something to
move proof along
- Ex: Ring
  - Basic operations are add, multiply, inverse add, identity, no inverse for mul
  - Polynomials are a ring; can add, multiply, additive inverse, etc.
  - Inverse of polynomial are not always polynomials (irrational)
  - Polynomials form a ring, but not a field
- If a polynomial is equal to another polynomial, can call the ring tactic
  - Can reduce any of the polynomial expressions by an algorithm to a normal form
  - If the polynomial on left is equal to polynomial on right, can see if reduced
  forms are equal
- If you have any first order proposition with ands and ors and nots, where clauses
can be arithmetic, boolean, propositions, etc., it can solve it instantly
  - Don't have to build every complicated proof by hand
- If you throw a tactic at a composition in a proposition, it moves it along a little
bit until it can't make any more progress
  - Kind of like a built-in SMT solver (someone wrote it and imported it into
  library)
-/

-- Example Tactic
-- Can substitute expressions one over another
-- simp : looks into library of registered theorems, then see if it can
-- simply expression
  -- Don't have to prove everything by yourself
example (x : Nat) : x ∈ ({1, 2, 3} : Set Nat) ↔ x = 1 ∨ x = 2 ∨ x = 3 := by
  simp only [mem_insert_iff, mem_singleton_iff]

-- Example: decide
-- Either prove a theorem or fail to prove one if there is a registered decision
-- procedure for that kind of proposition.
-- Build decidable equality typeclass for your particular domain
  -- Algo with run and decide

#eval decide ((3 : Nat) ∈ ({1, 2, 3} : Set Nat))

/-
Example: Set.univ
-- Universal set on any type
-- There is also notation for the empty set
  -- f(x) => False
  -- x in the empty set goes to false; no values that satisfies empty set
-/


/-
## Set notation and corresponding notations in predicate logic:

| Set operation | Logical meaning | Notation |
|--------------|----------------|---------|
| `∅` (empty set) | `False` | `∅` |
| `Set.univ` (universal set) | `True` | `Set.univ` |
| `insert a s` (insert) | `x = a ∨ s x` | `insert` |
| `{a}` (singleton) | `x = a` | `{a}` |
| `s ∩ t` (intersection) | `s x ∧ t x` | `∩` |
| `s ∪ t` (union) | `s x ∨ t x` | `∪` |
| `sᶜ` (complement) | `¬ s x` | `ᶜ` |
| `s \ t` (difference) | `s x ∧ ¬ t x` | `\` |
| `s ⊆ t` (subset) | `∀ x, s x → t x` | `⊆` |
| `s ⊇ t` (superset) | `∀ x, t x → s x`, i.e. `t ⊆ s` | `⊇` |
| `s ⊂ t` (strict subset) | `(∀ x, s x → t x) ∧ s ≠ t` | `⊂` |
| `s ⊃ t` (strict superset) | `(∀ x, t x → s x) ∧ s ≠ t` | `⊃` |
| `s = t` (equality) | `∀ x, s x ↔ t x` | `=` |
| `s ×ˢ t` (product) | `fun (a, b) => s a ∧ t b` | `×ˢ` |
| `𝒫 s` (powerset) | `fun x => x ⊆ s` | `𝒫` |

- Equality: Want to show that they're equivalent logically
  - Can import axiom of set extensionality
    - If they are equivalent in values, they are equivalent in sets
- Product: Want to show that input set is the set of all pairs between 2 sets
  - For a value qr to be in the product set, q is in s and r is in t
- Powerset: Contains every possible subset of S
  - If you have a set {1, 2, 3}, you have 8 elements in the new set
  - Adding 1 value to set doubles the size of the new powerset
  - In this case, set {1} is a subset of the powerset
- Binary relation: Subset/elements of the powerset of the product set
  - Empty relation: Empty set of pairs
  - Full relation: Product set itself
  - Doesn't have to be single-valued
- Ex:
  Pets: {Dog, Cat}  Tempers: {Mean, Nice}
  Product Set: {D, M}, {D, N}, {C, M}, {C, N}
  A binary relation from Pets to Tempers is any member of the product set:
    Ex: {(D, N), (C, N)} -> 1 element in power set of product set

Properties of Sets:
- Represent it as a predicate
- If we talk about a property of sets, represent as predicates on predicates
- Properties of sets themselves are represented as predicated
  - Predicate is empty → Function from Set → Prop, where Sets are themselves (something → Prop)
-/
