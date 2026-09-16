/- @@@
# Inference Rules and Derivations
@@@ -/

/- @@@
## Introduction Rules
The term introduction rule refers to the means for
constructing, or introducing into the discourse, a
value of a given type, or a proof of a proposition.
Here are examples of construction/introduction
rules in very simple programming examples.
@@@ -/

/- @@@
The introduction rules for Nat, as for any inductive
type, are simply given by its constructors.

``` inductive Nat : Type where
| zero            : Nat
| succ (n : Nat)  : Nat
```
@@@ -/


def n : Nat := Nat.zero     -- Nat.intro_zero
def b : Bool := Bool.true   -- Bool.intro_true

def nb : Nat × Bool :=      -- × means Prod Nat Bool
  Prod.mk n b               -- Prod.intro

def nb' : Nat × Bool :=      -- × means Prod Nat Bool
  (                          -- Prod.mk Prod intro
    Nat.zero,                -- Nat.intro_zero
    Bool.false               -- Bool intro false
  )

/- @@@
## Elimination Rules
Every single type has its own elimination rules,
but they all serve the same purpose: to enable one
to define total functions from values of any type.
The elimination rules for a product type are just
the two projection functions, for pulling the first
and second values out of a given ordered pair value
of such a type.
@@@ -/

-- Given a Nat-Bool pair, return the Nat component
def NB2Nat : (Nat × Bool) → Nat :=
  fun (p : Nat × Bool)  =>   -- → introduction
   Prod.fst p


/- @@@
To understand why this is true one must understand the
product type, *Prod*, itself. Remember you can use check
then right click and Go To Definition to see definitions
in Lean.

```lean
structure Prod (α : Type u) (β : Type v) where
  mk ::  (fst : α) (snd : β)
```
@@@ -/

/- @@@
*Prod* has × as infix notation. Its single introduction
rule is  *Prod.mk* with notation *⟨_, _⟩*. Its two elimination
rules are projection of the first and second elements of any
pair by the functions *Prod.fst* and *Prod.snd* applied to it.
@@@ -/

/- @@@
## Conjecture: Prod (×) is commutative.

This informal statement is intended to assert that if
you have *any* pair of types, call them α and β, there
is a total function, call it *swap*, that converts *any*
ordered pair, *p = (a, b)* of type *α × β* into a pair,
*(b, a)* of type *(β × α)*.
@@@ -/

/- @@@
Moreover, there is an essential correctness condition
for any implementation of such a function: namely that
for any (a : α), (b : β), *swap (swap (a, b)) = (a, b)*.
In other words, `swap` applied twice is the *identity*
function for product

To gain deeper intuition it certainly helps to start
with simple concrete examples. So let's assume for now
that *α = Nat* and *β = Bool* and we'll just hardwire
these choices in our first examples.

To begin, let's prove, by simply programming, that
there is way, from *any* pair *(n, b) : Nat × Bool*
to derive a pair, *(b, n)* of type *Bool × Nat*. A
derivation of this form is just a *total function* of
type *(Nat × Bool) → (Bool × Nat)*.
@@@ -/

-- specification
def swap_nat_bool : (Nat × Bool) → (Bool × Nat)
-- implementation
:= fun nb =>               -- → introduction
    let n := nb.1         -- × elimination left/1
    let b := nb.2         -- × elimination right/2
    (b, n)

/- @@@
Here's a more concise way to write it. To the left
of the `=>` we destructure the argument (just as in
javascript and other such languages). As usual this
operation binds names to subparts of the argument. On
the right, we assemble them (intro) in the result.
@@@ -/

-- Specification
def swap_nat_bool' : (Nat × Bool) → (Bool × Nat)
:= fun (n, b) => (b, n)

#eval swap_nat_bool (3, true)

/- @@@
The notion of swapping the elements of any ordered
pair is entirely sensible. It's general. It applies
not only to Nat-Bool pairs but to pairs of values of
any type.

We can express this in English by saying, if *α* and
*β* are any types, with *(a, b)* is any pair of values
of the product type, *α × β*, there is a way from that
to derive the pair *(b, a)* of type *(β × α).* Call it
*swap*.

We can translate this English description directly
using the *forall (∀)* construct from basic predicate
logic.
@@@ -/

-- Specification
def swap'' :
  ∀                 -- forall ..., for any ..., for every ...
    (α : Type u)    -- for any type α
    (β : Type v),   -- for any type β
    α × β → β × α   -- from any α-β pair, derive a β-α
-- Implementation
:= fun _ _ (a, b) => (b, a)

-- Let's clean it up. First implicit arguments
def swap' :
  ∀                 -- forall ..., for any ..., for every ...
    {α : Type u}    -- for any type α
    {β : Type v},   -- for any type β
    α × β → β × α   -- from any α-β pair, derive a β-α
-- Now we omit explicit α and β arguments; they're inferred
:= fun (a, b) => (b, a)

#eval swap'' Nat Bool (0, false)
#eval swap' (0, false)

-- Declare α and β together, bind both of them early, ∀ implicit
def swap {α β : Type u} : α × β → β × α := fun (a, b) => (b, a)

#eval swap (0, false)
#eval swap ("No", "Way")

-- works but Lean can't print function values
-- #eval swap (@swap Nat Bool, @swap' Bool Nat)

/- @@@
Finally, a correctness condition: swap is involutive!
What that means is that applying it to any pair then
applying it to the result returns the original input.
@@@ -/

theorem swap_comm {α β : Type u} (x : α) (y : β) :
  Eq (swap (swap (x, y))) (x, y) := Eq.refl (x, y)

-- The Lean term, *(swap_comm 0 true)*, typechecks
-- as a proof of swap (swap (0, true))) = (0, true)
#check (swap_comm 0 true)

/- @@@
The generalized function is the proof of the ∀, and
as the proof is itself a function, you can apply it
to specific arguments as usual. Ah ha! We thus have
the concept of ∀ introduction: define a function. And
the ∀ elimination rule is applying it. The result is
called *specialization*.

Here, for example, we've applyied the ngeneral theorem,
swap_comm, to the special case argments, 0 and true, in
this expression, *(swap_comm 0 true)*, to obtain a proof
that swap applied twice to the specific pair, (0, true),
works as expected and returns that very same value.
@@@ -/

/- @@@
The polymorphic equality type
@@@ -/

#check Eq

/- @@@
inductive Eq : α → α → Prop where
  | refl (a : α) : Eq a a
@@@ -/

#check Eq 3 4

-- def swap {α β : Type u} : α × β → β × α := fun (a, b) => (b, a)
-- fun (a, b) => (b, a) with x for a and y for b
-- (y, x)

/- @@@
And now for some actual mathematical logic. Let's prove
that *logical And is commutative.* Let's start by proving
a particular conjuction, *And (7 > 0) (7 ≤ 10)*, usually
written with infix notation as *(7 > 0) ∧ (7 ≤ 10).* We'll
then show if this is true so is *(7 ≤ 10) ∧ (7 > 0).*
@@@ -/


/- @@@
Here's the first proof. The type we're proving here is a
proposition, not a computational type, and Lean prefers
that you use *theorem* instead of *def*. Try it.
@@@ -/
def andExample : (7 > 0) ∧ (7 ≤ 10) :=
  And.intro         -- introduction rule
    (by decide)     -- decision procedure proof of 7 > 0
    (by decide)     -- decision procedure proof of 7 ≤ 10


-- For this special case we can prove that *And commutes*
-- The astute student will see right away that this is swap!
theorem impExample : (7 > 0) ∧ (7 ≤ 10) → (7 ≤ 10) ∧ (7 > 0) :=
  fun conj =>       -- → introduction
    (
      And.intro     -- And introduction analogous to × introduction
        conj.2      -- And.elim_2/right
        conj.1      -- And.elim_1/left
    )

-- Now we can generalize to arbitrary propositions, *P* and *Q*
theorem impEx2'' {P Q : Prop} : P ∧ Q → Q ∧ P :=
  fun pq =>         -- → introduction
    And.intro       -- And introduction
      pq.right      -- And.elim_right
      pq.left       -- And.elim_left

-- As Prod.mk has notation (_,_), And.intro uses ⟨_, _⟩
theorem impEx2' {P Q : Prop} : P ∧ Q → Q ∧ P :=
  fun ⟨ p, q ⟩  =>  ⟨ q, p ⟩

-- Just another way to write it (more notation), preferred.
-- Using case analysis and destructuring notation (drops :=)
theorem impEx2 {P Q : Prop} : P ∧ Q → Q ∧ P
  | ⟨ p, q ⟩  =>  ⟨ q, p ⟩

-- Yay, we have a simple and general proof ∧ commutes
-- Now we can apply our general theorem to any special case
-- It's just going to be function application; let's set it up

-- define abbreviations for the following propositions
abbrev sGtZ : Prop := 7 > 0
abbrev sLe10 : Prop := 7 ≤ 10

-- invoke decision procedures to obtain proofs of each
theorem sGtZ_pf : sGtZ := (by decide)
theorem sLe10_pf : sLe10 := (by decide)

-- Assemble proof of conjunction using And.intro
theorem a_conj_pf : sGtZ ∧ sLe10 := ⟨ sGtZ_pf, sLe10_pf ⟩

-- Unclear? Go look at the definition of And!

/- @@@
structure And (a b : Prop) : Prop where
  intro :: (left : a) (right : b)
@@@ -/

-- Look at the type of And (infix notation is ∧)
#check And

-- The introduction rule applied
#check And.intro sGtZ_pf sLe10_pf
-- ⟨sGtZ_pf, sLe10_pf⟩ : sGtZ ∧ sLe10
-- read the colon as *is a proof of*

-- Elimination rules examples (structure field names as elim rules)
#check And.left a_conj_pf     -- Like Prod.fst
#check a_conj_pf.left         -- Dot notation
#check And.right a_conj_pf    -- Like Prod.fst
#check a_conj_pf.right        -- Dot notation


/- @@@
The term, Curry-Howard Correspondence, names the
recognition that the *inference rules* of deductive
*reasoning* in predicate logic (here higher-order and
dependently typed) have mirror images as dependently
typed pure functional *programms*.

You've just seen a good example. `Prod` and `And` are
Curry-Howard twins. So are the commutativity of `And`
and the swappability of `Prod`. Your preparation for
next class includes illustrating the same duality for
the flippability of `Sum` and the commutative of `Or`.
@@@ -/


/- @@@
## Expected Preparation for Next Class

Recall that `Sum α β` or (`α ⊕ β`) is the type of term
that holds either a value (a : α) or a value (b : β).
Any term of this type is of exlusively one of these forms.
To have a term of this type proves that *at least one* of
the summand types is inhabited. Think about that to be
sure you see it clearly. A value of a product type, by
contrast, is proof that *both* multiplicand types are.
@@@ -/

/- @@@
Here's the computational Sum type builder.

```lean
inductive Sum (α : Type u) (β : Type v) where
  | inl (val : α) : Sum α β
  | inr (val : β) : Sum α β
```
@@@ -/

-- all inhabited, with mk as default constructor
structure Rice
structure Potato
structure Fish
structure Chicken

def choiceChicken : Chicken ⊕ Fish := Sum.inl Chicken.mk
def choiceFish : Chicken ⊕ Fish := Sum.inr Fish.mk

-- Elimination is by case analysis

def proteinToString : Chicken ⊕ Fish → String
| Sum.inl _ => "Chicken"
| Sum.inr _ => "Fish"


-- PROVE: Chicken ⊕ Fish → Fish ⊕ Chicken
-- STATE AND PROVE: ⊕ is commutative in general

/- @@@
PROVE that someone who ordered "Fish, and either
Rice or Potato" should be satisfied to be served
"Rice or Potato, and Fish. Clearly, it's true: you
just have to turn the plate a little! To prove it
it would do to show there's a function that applied
to a whole *meal, "Fish, and either Rice or Potato"
derives and returns "Rice or Potato, and Fish." Ok,
that's easy. Boring. We've already done that!
@@@-/

example : Fish × (Rice ⊕ Potato) → (Rice ⊕ Potato) × Fish
| (f, rorp) => (rorp, f)

/- @@@
That's just commutativity of × again. Let push `Or` to the
front now. Should a person who ordered Fish and either potato
or rice be happy they're served either Fish and Rice, or Fish
and Potato?
@@@ -/

-- Replace the sorry with the right content
example :
  Fish × (Rice ⊕ Potato) →
  Fish × Rice ⊕ Fish × Potato
| (f, rorp) => sorry


-- Can you convert in either direction?
example :
  (Fish × (Rice ⊕ Potato) → Fish × Rice ⊕ Fish × Potato) ×
  (Fish × Rice ⊕ Fish × Potato) → (Fish × (Rice ⊕ Potato))
| _ => sorry


/- @@@
## The Curry-Howard Twin of ⊕ is ∨

Here is Lean's `Or` (∨) type (here specifically
propostion) builder. It's not itself a type because
it takes arguments. When fully reduced, it's a type.
To fully reduce it apply it to two arguments, each
itself a proposition. What you're specifying here in
essence is part of the *syntax* of predicate logic.
It's meaning is in the introduction and elimination
rules: in the constructors and elimination methods.

```
inductive Or (a b : Prop) : Prop where
  | inl (h : a) : Or a b
  | inr (h : b) : Or a b
```

Infix notation for the type, Or P Q, is the usual P ∨ Q.
@@@ -/



-- PROVE: `Or` (∨) is commutative
-- Assume a proof of either P or Q
-- Derive a proof of Q ∨ P

example {P Q : Prop} : P ∨ Q → Q ∨ P
| Or.inl p => Or.inr p
| Or.inr q => Or.inl q


-- PROVE: P ∨ Q ∧ R → P ∧ Q ∨ P ∧ R -- ∧ has higher prec.
-- PROVE P ∨ Q ∨ R → (P ∨ Q) ∨ R
