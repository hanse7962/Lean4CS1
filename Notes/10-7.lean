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

-/
