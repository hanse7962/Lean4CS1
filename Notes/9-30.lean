
/-
- Assume we have a proof of P and Not P
- Use negation introduction, then show the conclusion
- Apply proof of Not P to proof of P
- Just programming with propositions or types
-/
example (P : Prop) : ¬(P ∧ ¬P) :=
    fun (pnp : P ∧ ¬P) =>
        pnp.right pnp.left

/-
p : P
np : ¬P
np : P → False

(P ∧ ¬P) always returns false

sorry => Accept proposition as axiom no matter what
- If you assert false statement, then say sorry, lean accepts it as a
  true statement
- Don't want to accept false axioms into logic
- Use sorry as a placeholder for a proof you want to apply later
-/

/-
Predicate Logic (Shallow embedding)
- True -> 1 proof
- False -> 0 proofs
- And -> Polymorphic (two types) (P Q)
- Or
- Not -> Negation; Polymorphic; One var; function → False
- Iff
- For All (∀) -> Given any X, return a proof of Y (if X is true, Y is true)
  - Proof of implication is function; if premise is true, then there is a proof of it
  - If premise is false, then false elimination lets you push whole thing through anyway
  - Reasoning about For All is the same as reasoning about implication
    - For All is a notation
- Exists (∃x, Px) -> Exists some X with property P
- functions (fun) -> Assumptions
  - Predicates turn out to be special functions
- Bring Your own interpretation -> To show proposition is valid, need to show
  that it is valid for any interpretation that you bring whatsoever
  - Only way to do that is by proofs
  - Just show symbolically that the logic works
-/

/-
*Predicates
Think of properties of objects; how do you express in computational logic?

- Ex: Data type "Dog" with 5 constructors:

Dog
| Fido
| Iris

Properties of "Dog" (some have it, some don't):
| Friendly
| Furry

Ex (propositions (state of affairs in some world)):
- Fido is Friendly
- Fido is Not Furry
---
- Iris is Friendly

^ Assertions that particular objects have particular properties

To represent "Fido is Friendly", can represent as propositions:

inductive FidoFriendly : Prop where
| mk

inductive FidoNotFurry : Prop where -- Leave blank since proposition has no proofs

-- Proofs are data values of types
inductive IrisFriendly : Prop where
| mk

Can live in Prop (logical reasoning)

Since Friendly applies to both dog constructors, there are duplicate propositions
- Can just make it a predicate as a proposition with a placeholder
- Property is "Friendly", pertains to "Dog"
- "Friendly" is parameterized (proposition with blank in it)
  - Fill in blank by applying parameterized property to it
- Ex (hint): increment function is parameterized by Nat
  - Represent predicates as functions that take the argument that fill in placeholders, then
    return proposition at the end of the day
  - Dogs have predicate of being friendly; represent as function
    - abstract out the part that varies (dog name)
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
-- Don't give proof for Sergeant; can use nomatch to eliminate on that
 -- Need to open namespace to get "Iris" instead of "Dog.Iris"
-- Proposition is predicate with placeholders

-- Defines abstract Furry property
inductive Furry : Dog -> Prop where
| irisFurry : Furry Iris
| sergeantFurry : Furry Sergeant

-- Would be able to prove proposition:
-- Iris is friendly and Furry

-- Friendly is a predicate/property
-- Programming languages are deterministic
  -- Can formalize properties in all fields
-- If both friendly and furry, it is house friendly/suitable
example : Friendly Iris ∧ Furry Iris := _

-- To be applicable to any dog (D), need D to be friendly and furry
-- Don't have a name for the dog; have to give the dog a name to define the downstream return Type
-- Type of return value depends on type of dog you get


-- Takes a named argument and returns a proposition
def Suitable (d : Dog) : Prop := (Friendly d ∧ Furry d)
-- Scope of d just extends to the beginning of the function
    -- Invisible outside of scope
-- If you move arg from right of colon to left of colon, global for entire construction
-- Function takes a Dog and returns a proposition
  -- Scope of d now extends to the right side of the proposition

-- Other forms; all equivalent
def Suitable' : Dog → Prop :=
    fun d => -- Need to reintroduce function argument; define some property of dogs
        (Friendly d ∧ Furry d)
-- When you see elim to prop, you are dealing with a predicate

example : Suitable Iris :=
    And.intro
        Friendly.irisFriendly
        Furry.irisFurry
    -- Can use And.com will give you proof in other order

/-
*Quantified expressions in predicate logic

*∀(x : X), Px
- For any object x, x has property P
- Select/assume an arbitrary X, show that x has property
- Type of return value needs to be a proposition
- Proof is just a function
  - X → P
- Notion of dependent types
  - Want to assume x has property P
- For all and function types are the same in lean

*∃(x : X), Px


In both cases, P is a property of x
 Px -> Prop
  - When you bind a variable name, it holds all the way across
  - x is a type of X
- #check P -> function from objects of type (X → Prop)
  - P is a predicate
-/

-- Write from Dog to the Type of proofs that Dog has particular property
#check Suitable
#check (Suitable)
#check (Friendly)
#check (Furry)

-- Pick any dog, dog is friendly
#check (∀ (d : Dog), Friendly d)
#check ∀ (d : Dog), Friendly d
-- Function is a dependent type and a function type from Dog → Friendly d → Bool
-- If you give any type d, return type is Friendly d, and value of that type is a proof of that proposition
  -- Is there a proof of it?  No, but can prove negation

-- For any Dog d, can return Friendly d
example : ∀ (d : Dog), Friendly d :=
    fun d =>
        match d with
        | Iris => Friendly.irisFriendly
        | Fido => Friendly.fidoFriendly
        | Sergeant => _ --No proof that Sergeant is friendly, so can't make proof go through
-- ^ Proof cannot be proven true

-- There exists a dog that is not friendly
example : ¬ (∀ (d : Dog), Friendly d) :=
    fun allDogsFriendly =>
        let sf := allDogsFriendly Sergeant -- Gets proof of Friendly Sergeant (doesn't exist)
        nomatch sf -- No constructor that can possibly account for proof
-- Universal specialization: elimination rule for ∀
  -- Apply to particular to get particular for that object

example : (∃ (d : Dog), Friendly d) :=
    Exists.intro
        Fido -- Particular (dog)
        Friendly.fidoFriendly -- Proof about that Particular (dog)
-- Witness: Constructor satisfies property
  -- Pair: Particular and Proof for that Particular
    -- Ex: Fido and Proof that Fido is Friendly

/-
Exists elim rule
-/
