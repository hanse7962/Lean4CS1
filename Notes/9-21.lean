/-
Math theory embedding
- Shallow embedding vs deep embedding
-- Shallow: Syntax -> Type
    Ex: And α \b, prove \a and \
-/

namespace PropLogic

/- Not just literal true/false, but also has variables
- If x is Prop, and y is Prop, then x AND y is Prop
-/
inductive Variable where
| Xvar
| Yvar
| Zvar

/-
Variable expression in propositional logic
- Not true or false (yet), since we haven't bound value to variable

Is proposition satisfiable? (is there a binding of boolean value that makes it true?)
- Yes, just make it mean Boolean true

If you have an expression X and ¬X, that is not satisfiable
- (no expression that makes X and ¬X true)
- Need to assign values to boolean expressions
-/

/-
How to associate var with corresponding boolean?
- Define a new Var eval (usually called an interpretation)
- Function from Var → Bool
-/

open Variable

def varInterp : Type := Variable → Bool

-- How many such functions exist for this example?
-- 8; 8 possible combinations of X, Y, and Z
def i1 : varInterp :=
  fun (v : Variable) =>
    match v with
      | Xvar => true
      | Yvar => true
      | Zvar => true

def i2 : varInterp :=
  fun (v : Variable) =>
    match v with
      | Xvar => false
      | Yvar => true
      | Zvar => true

-- Propositional/Prop logic in Lean:
inductive PropLogic where
| T
| F
| And (p1 p2 : PropLogic) : PropLogic -- Gives term of the same type
| Or (p1 p2 : PropLogic) : PropLogic
| Not (p1 : PropLogic) : PropLogic
-- | implies (p1 p2 : PropLogic) : PropLogic
| Var (v : Variable) : PropLogic -- Term of type PropLogic


-- Deep embedding of language into lean
open PropLogic
-- When you have variant type, always need to do case analysis

def X := Var Xvar
def Y := Var Yvar
def Z := Var Zvar

def eval : PropLogic → varInterp → Bool
  | T, _ => true
  | F, _ => false
  | (PropLogic.And p1 p2), i => (eval p1 i) && (eval p2 i)
  | (PropLogic.Or p1 p2), i => (eval p1 i) || (eval p2 i) -- Maps to Boolean OR function
  | (PropLogic.Not p1), i => !(eval p1 i)
  -- Unless we have interpretation function to return value, can't return value
  -- Need to pass interpretation as an argument
  | PropLogic.Var v, i => i v -- Name of function (i), name of value (v)
  --| _ => false -- Defaults *all undefined terms* to false; can use *any name that's not defined*
-- When lean does case analysis, checks cases from top to bottom in order
-- If variable is previously undefined, can be used to match anything.

-- Notations
/-
- One thing to write out the operators in words (abstract syntax)
  - Abstract syntax: what a compiler turns source code into
  - Ex: P && Q; application of function to compute conjunction of functions
- Most people prefer concrete syntax
  - Instead of having operators appear prefixed before operands, may prefer
    binary operation be denoted by symbol (ex &&)
- Start by defining abstract syntax, but eventually, add standard
  notations for that particular mathematical theory
-/

def e1 := F
def e2 := T
def e3 := PropLogic.And e1 e2
-- ^ example of abstract syntax; captures operation, but have to write it out

/-
Adding notations:

Ex: ¬ X ∧ Y
-When introducing infix operators, need to be careful, since order of operators
 is ambiguous
  - In other words, need to know order of operations
  - Ex: ¬ X ∧ Y ∨ Z === ((¬ X) ∧ Y) ∨ Z
  - Give each operator a precedence value (ex: and has higher precedence than or)
- Associativity determines order that they are evaluated with the same precedence
  - i.e. left associate or right associative

Token: ∧
Precedence
Associativity
Infixr: Group to right (refuses implicit grouping)
Infixl: Same as above, but to the left

⊤ ⊥ -> Highest precedence
-/

-- literal expression example
scoped notation:max "⊤" => PropLogic.T
scoped notation:min "⊥" => PropLogic.F
scoped infixr:35 "∧" => PropLogic.And
scoped infixr:30 " ∨ " => PropLogic.Or
-- Not supported in C/C++
-- When X is true or Y is true, or when X is false
-- T → T is true
  -- Looks like the identity function
  -- Mirrors notion that T → T
-- F → T is true
-- T → F is false
  -- If you are given a val of type true, need to return value
  -- of type Empty
  -- No value of type Empty to return, so function definition cannot be finished
  -- Can't derive a value of type Empty from a value of Type true
-- To show that it's false
  -- Take any proof/value that assumes it's given a val of type Empty, then returns value
  -- of type Empty

-- F → F is true
  -- Define function from empty → empty
  -- Write function with formal param (not going to get a value of type empty)
  -- To prove empty → empty, if given empty, return empty
  -- Mirroring reasoning that false implies false; just apply introduction rule
    -- Within scope of assumption return that type of value
  -- Can write a function from empty → Nat, but can't use it
    -- Never have a proof where you can use it

-- If given a proof of false, can return a proof of false
-- If the premise is true, can construct proof of conclusion
-- Proving F → T: given a proof of false (doesn't exist), then ignores it and returns true
-- Ignored assumed proof of false, and return true
--   Assume proof is impossible; inconsistent assumption
--   "absurd"/"no match" keywords
--   No case analysis needed for false, since there are no constructors
-- False is an empty type
--  All of the logical constructs (T, F) are just programs, so they
--  have representations in functional programming language
-- Propositional types live in same language and logical types
--  If you have a type in prop that has a proposition, should only have
--  at least one proof
-- Can relate computational types to logical types
scoped infixr:25 " ⇒ " => PropLogic.Imp

-- Biconditional: infix, not infixr, so it will not self-associate
scoped infix:20 " ⇔ " => PropLogic.Iff

-- Showing F → F is true
def e2e : Empty → Empty
| e => e-- Name bound to first arg; can never be called, since can never be applied to type empty

-- Prop is not computational; asks for function value
-- No constructors, so can return type itself
def fimpf : False → False
| f => f

-- If you define your own computational type (empty type)
-- no way to build values

-- To prove that type is empty:
-- Build func from MyEmpty to Empty
 -- Shows it is uninhabited, since if there were a val of Type Empty, can't build function (need to return val of type empty)
inductive MyEmpty : Type where
-- | mk --If inhabited, not empty

-- Can't finish function, since you don't have a val of type Empty to return, and can't build one
-- Non-existence of function of this type tells you that it is inhabited (not false)
-- Existence of a function of this type it really is Empty (needs to be a total function)
  -- Shows MyEmpty is not empty

def me2e : MyEmpty → Empty
| m => nomatch m
-- nomatch : Tells lean that there are no
/-
Assume you are given a parameter of formal param type, match on m for case analysis,
but since there are no cases, it is a total function.

Tells you that MyEmpty is uninhabited.
-/

-- Encodes proposition, rather than set of data structures
inductive MyFalse : Prop where
-- | mk --If uncommented, MyFalse is inhabited and not False

-- Show that there is a function from total function to uninhabited type
-- Given proof of MyFalse coming in, return proof of false
-- Non-existence of function of that type tells you that MyFalse is inhabited

-- Since it's a proposition, should use the "theorem" keyword instead of the "def" keyword
  -- Functionally equivalent
-- The way that you show a proposition is false, need to show that type is uninhabited
-- Shows that there are no constructors/inhabited types
theorem mf2f : MyFalse → False
| m => nomatch m


/-
Proof by negation/proof by contradiction

If you want a proof that not P is true, show that P is uninhabited
- Need to exhibit that there is a function from P to uninhabited type, which
  only exists if P is uninhabited
-/

/-
Type: Computational types
Prop: Logical Types

- (T) Empty → (P) False (no data values)
- (T) Unit → (P) void (One value type)
-
-/

-- If you want to show that prop type is false, need to show that there is afunction from empty type to false
-- Want to do this no matter what your type is, show that there is a function from your function to false

-- Example of negation: polymorphic function
-- For any prop type P
-- Shallow embedding of not operator
  -- Desugared to mean P → F
  -- Proof of ¬P to mean P → F
-- Takes proposition of argument, then returns false
-- Takes any proposition of type
  -- MyFalse is prop, so it is defined
  -- Question of whether it is inhabited
def neg (p : Prop) : Prop := p → False
/-
Takes proposition, then proof of emptiness of a
-/

#check MyFalse

#check Not

/-
Need a function from MyFalse to false
- neg MyFalse is defined to be a value of type that to false
- MyFalse → False, need proof of this
  - Shows that myFalse is uninhabited, no proof terms, so false
- Standard embedding of logical negation into functional programming language
-/
example : neg MyFalse
| m => nomatch m

-- Concrete notation: neg MyFalse
-- Need a function of Type MyFalse → False
example : ¬MyFalse
| m => nomatch m
-- ^ Assumes it is given proof of MyFalse

inductive TypeA : Type where
| mk

inductive TypeB : Prop where

#check (@PropLogic.And) -- Takes two props and returns greater proposition
-- Not possible with type Type
example : ¬TypeB
| m => nomatch m

/-
- And does not do any eval; just a syntax combinator
- Returns a third type which is a conjunction of first two combinatinos
- If you want a proof that And P Q is true, need a constructor to build And P Q
  - To construct proof that P and Q is true, need proof of P and proof of Q
  - Takes proof of first prop and second prop, packs them into pair of proofs, then returns type of conjunction
-/

-- True proposition; type that lives in type universe
-- 1 constructor: one proof of proposition
inductive KevinIsFromCville : Prop where
| driversLicense -- Proof constructor; constant value

-- Prove KevinIsFromCville
-- Value of this type, so proof of proposition
example : KevinIsFromCville := KevinIsFromCville.driversLicense

inductive JorgIsFromToronto : Prop where
| driversLicense
| utilityBill
| healthCard

example : KevinIsFromCville ∧ JorgIsFromToronto :=
And.intro
  KevinIsFromCville.driversLicense
  JorgIsFromToronto.healthCard

-- In lean, any proof will do as long as it type checks
-- Fundamental difference is that two values of type Type are different
  -- In Prop, all proofs consider all values to be equally good
  -- Is there one or is there not one?  Define all terms of type prop to be indistinguishable

-- Terms are not equal in this type
inductive Cat : Type where
| siamese
| tabby

-- ≠ : Not <prop> equals; equivalent to ¬ (a = b)
example : ¬ (Cat.tabby = Cat.siamese)
-- Want it to imply false, and negation of it is true
| m => nomatch m
-- m = proof that tabby = siamese
-- At this point, checks constructors of proofs of equality
  -- They are literally different terms; use ik.refl
  -- No way to pass both values into constructor of proofs of equality, since they only take one arg

-- Proof that Prop constructor types are equal
-- Use introduction rule
example :
JorgIsFromToronto.driversLicense = JorgIsFromToronto.utilityBill :=
rfl
-- shows both terms are equal
-- If types are in Type, constructors are not equal
-- If in prop, all proof values are equally good and all judged to be equal
-- Proofs are irrelevant to computations; only care about whether proofs are true are not
-- Type universes are non-cumulative

-- HW: look up DeMorgan's Laws, and prove them in Lean in predicate logic
  -- How negation distributes over AND and OR
  -- If ¬ P ∨ Q, equivalent to F ∨ F, which means at least one of them is false
  -- Not all of DeMorgan's Laws are valid in this logic
