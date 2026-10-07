/-
Quantifiers
∀ (x : T), Px
∃ (x : T), Px

P : Property that consumes one or more propositions; shows that it
    has one or more of those propositions

Can have a predicate "is from charlottesville" that takes 1 person as argument,
but can further generalize it to "x is from y"

- Person P is from state S
- Predicate over 2 args: (P x y)
  - Proposition that you have to reason about
  - Px -> Proposition that expresses property
    - In the programming language, a property is a type
    - Given x, can return a proof of Px

P:T → Prop
- Takes T as arg, returns Prop (may or may not have a proof)
  - If proof, holds for T
  - If no proof, does not hold for T

For ∀, true if it returns a value for every return value
- Same as: (x:T) -> Px
  - Type is a proposition about a particular dog, number, person, etc.

Ex: in a world of people; want to write prop that everyone likes someone

Everyone:
- Person: Type
- Likes: Predicate (takes 2 args)
  - Args: Person → Person → Prop
  - Prop at end about those 2 people
- ∀ (x: Person), ∃ (y: Person) (Likes x y)
  - "Everyone likes someone"
- ∃ (y: Person), ∀ (x: Person) (Likes y x)
  - "Someone likes everyone"

Each proposition formalizes a structure
(Use arrows to represent source liking destination)
- "Everyone likes someone" → There must be at least one outgoing arrow from every person
  - Arrows can point to themselves
- "Someone likes everyone" → At least one point must have an outgoing arrow to every other point

"Everyone likes someone else":
∀ (x: Person), ∃ (y: Person) (Likes x y) ∧ (x ≠ y)]
  - No reflexive arrows

If the set is empty, the prop starting with ∀ is true
- Quantifying over empty set
  - Quantification over empty set is trivially proven
If the set is empty, the prop starting with ∃ is false
- Asserts that there is *at least one instance*

Can be a proposition or a specification
- Can test worlds against propositions
- Can also build a world that satisfies a proposition
  - Developer constructs and delivers system; models proposition

"There exists a natural number that is perfect and odd"
- "Perfect" → Prime factors add up to the number
  - Ex: 6 (3, 2, 1), 28 (1, 2, 4, 7, 14), etc.
- One of the oldest open problems in mathematics
  - Goes to notion of "what does it mean to exist"
  - Might be able to construct in classical mathematics, but in constructive
    logic, you must find one and depict a proof of it
  - Wouldn't be able to do a proof of it
    - Assume it's given perfect prime number, then derive the conclusion

Formalizing proof of ∃x, Px:
- Provide an example/witness of type T and proof of type Pw:
  <(w:T), (pf:Pw)>
  - Witness and proof that witness has property you care about
- Where is dependent typing being used?
  - Each type depends on value
  - For every w, there is a different type Pw
    - Type → Prop → Prop about this specific w
- Exists: There exists a friendly dog
  <Iris, Friendly Iris>
-/

inductive Dog : Type where
| Fido
| Iris
| Sergeant

open Dog

-- Defines abstract Friendly property
inductive Friendly : Dog -> Prop where
| irisFriendly : Friendly Iris -- Proof of proposition that you get to get proposition of that type
| fidoFriendly : Friendly Fido

-- Defines abstract Furry property
inductive Furry : Dog -> Prop where
| irisFurry : Furry Iris
| sergeantFurry : Furry Sergeant

-- Takes a named argument and returns a proposition
def Suitable (d : Dog) : Prop := (Friendly d ∧ Furry d)

example : Friendly Iris ∧ Furry Iris :=
  ⟨ Friendly.irisFriendly, Furry.irisFurry ⟩
-- ⟨ ⟩ → Will automatically apply notion of any constructor type
-- In this case, And.intro applied to both proofs

-- Plug in parameter to Suitable to prove it
example : Suitable Iris :=
  And.intro Friendly.irisFriendly Furry.irisFurry

#check (Suitable)
#check (Friendly)
#check (Furry)

/-
No proof that Sergeant is friendly, so no proof that
∀ Dogs are Friendly
-/

-- Have to express the error that is has to produce
/-#guard_msgs in
example : ∀ (d: Dog), Friendly d :=
  fun d =>
    match d with
    | Iris => Friendly.irisFriendly
    | Fido => Friendly.fidoFriendly
    | Sergeant => _
-/

-- *Proving ¬∀ Dog is friendly → Proof by negation
-- Prove there is a total function from Dog to Friendly, then negate it

/-
Will use another proof strategy: For All Elimination
- Elimination: way of using a proof
- If you have a proof that "every dog is friendly", shape is a function
  - Assume you are given an arbitrary object; no matter what you are given,
  you get the function
- Assume all dogs are friendly; if you apply to any dog, have a function that
you can apply to any dog D to give a proof that D is friendly
  - In this case, Sergeant has no such proof, so feeding in Sergeant will not
    return a proof
  - Thus, the universal function is not total and subsequently false
-/

example : ¬(∀ (d: Dog), Friendly d) :=
  fun allDogsFriendly => -- Function of Dog to proof of Proposition (Friendly)
    let sf := allDogsFriendly Sergeant  -- Proof that Sergeant is Friendly
    nomatch sf  -- No such proof, so apply a case analysis to proof
                -- Performing empty set/false elimination

--*Is there a Friendly Dog?

-- Top level quantifiers is ∃
-- Use witness and proof of witness
example : ∃ (d: Dog), Friendly d :=
-- Want a proof that Iris is Friendly
  Exists.intro
    Iris -- Witness
    Friendly.irisFriendly -- Proof of witness
    -- "Friendly Iris" is type, proof is "Friendly.irisFriendly"

/-
Proof of an existential proposition is a *dependent pair*
- Type of second value depends on type of first value
- Has its own notation ⟨ ⟩
-/

-- Equivalent to above
example : ∃ (d: Dog), Friendly d :=
⟨ Iris, Friendly.irisFriendly ⟩

-- Proof that if exists dog is both friendly and furry (suitable), then a friendly dog exists
def simpf : Prop :=
  (∃ d, Suitable d) →
  (∃ d, Friendly d)

-- Formalization of Exists Proof in Lean
-- Polymorphic: can have proposition of any type at all
-- Explicit argument to existential proposition builder
inductive MyExists {α : Sort u} (p : α → Prop) : Prop where
| intro (w : α) (h : p w) : MyExists p
-- w is witness
-- h is hypothesis of proof of hypothesis that w satisfies p

-- You cannot get data back out of a proof of existence
  -- When we apply Exists.elim, there is an assumption that there is
  -- a dog x along with a proof Px
  -- Erases the witness in the process

example : simpf :=
  fun pfs =>
    _


-- "There exists a number n such that n + 1 = 4"
-- 3 is the only valid witness; if you plug in 3, it is a proof based on reflexive equality (rfl)
example : ∃ n : Nat, n + 1 = 4 := ⟨3, rfl⟩

-- "There is some number n that is greater than 3"
example : ∃ n : Nat, n > 3 := ⟨4, Nat.le.refl⟩

-- Nested propositions
-- What are the pairs of objects that satify predicate?
example : ∃ a : Nat, ∃ b : Nat, a + b = 5 := ⟨2, 3, rfl⟩

/-
Most mathematicians assume set theory, not type theory
- Set theory: With axiom of choice and some other things; standard axiom for practical math

We are in the world of type theory
- If we want to represent a set, we need a way to represent sets of things
- Here, we represent set of pairs; what pairs are in the set of pairs that satisfy proposition?
  - ⟨0, 5⟩, ⟨1, 4⟩, etc.
- A predicate can be used to represent a binary proposition, or a set of ordered pairs
  - Can use propositions like this to represent a set of objects

To represent intersection of 2 sets, it is the conjunction of the propositions that
specify original sets
- i.e. ∧ connector

Embed language of set theory and theory of relations

*Reflexive relation*:
Set of pairs specified by predicate with 2 args such that
every element is related to itself
- Ex: Specify relation called "Likes" as predicate; returns relation of itself
- Translate proposition into predicate of itself
-/

/-
*Getting the witness back out

Take apart proof to get out pieces, but get less out than what you put in
-/

#check @Exists.elim

/-
Predicate on objects
- α → Value
- R : Property
- S: Proposition
- Proof that exists alpha that satisfies property R

k is top-level connective
- If every α object has property R, then S is true
- Assume there is some object x for which R is true
- If every such x has property R, then we can conclude that S is true

h guarantees that you have at least one object that satisfies the proposition
- ∀x is trivially true since h assures there is at least one x with property R

Assumed values of all arg types
- α is not useful
- R is just ambient predicate; nothing to do with it
- S is prop, not much we can do with it
- k is an assumption of the implication being true/valid
  - If every α has property R, then it is true
  - k is a function; if you have an object you can apply it to, you could use itz
- h gives you object of type α with property R

We can deduce that there is some object w of type α, and it must have property R
- We can use logical inference to add 2 elements to context
  - w of type α
  - Proof of it
- When we have object of type α, we can feed it into k to obtain a proof of S
  - Won't tell value, but will say that the value exists
  - When we unpack h, we get both a witness and a proof about that witness
    - Allows us to use proof of Rx to feed into function

- After applying Exists.elim onto h and k, we get what we need
-/

example
  {α : Type}
  (R : α → Prop)
  (S : Prop)
  (h : ∃ x : α, R x)
  (k : ∀ x : α, R x → S) : S :=
  Exists.elim h k
