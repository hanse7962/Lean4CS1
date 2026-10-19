/-
Predicate logic:
- Axioms that tell you how to reason logically
- Ex: And.Intro constructs proofs of constructions
  - Or.Intro constructs proofs of disjunctions
- When embedding axioms of predicate logic into lean, embed introduction rules
  as constructors
- Elimination rules tell you how to use proof or value of given kind
  - Ex: prove P implies Q; assume you have proof of P, and from it, derive proof of Q
  - Arise from recursors/induction principles
  - Derive total functions of that type to anything else
  - Ex: formalize And as a data type:

  And (P Q : Prop) : Prop where
  | intro (p : P)(q : Q) : And P Q
  -- leads to P ∧ Q

  foo (pq : P ∧ Q) : Nat :=
  -- Can apply elimination rule to get fields of P ∧ Q

Have to have axioms of induction that let you go from individual cases to reversal,
even over infinite domain.
-/

/-
Language of Arithmetic:

- Think in terms of syntactic domain:
  - Want an expression and interpret its semantic domain (number)
  - Operators/syntactic symbols get turned into functions
    - Lean does not parse order of operations automatically
-/

namespace Arith

inductive ArithExpr where
| lit (n : Nat) -- lit 7 would be an arithemtic expression
| plus (n m : Nat) -- Prefix notation
| plusExpr (n m : ArithExpr) -- Prefix notation
| mult (n m : Nat) -- Multiplication
| multExpr (n m : ArithExpr)


open ArithExpr


/-
Use case analysis to get natural number
- Recursively evaluate expressions to get expressions
-/
def arithEval : ArithExpr → Nat
| lit n => n --Return piece of data that it carries
| plus a b => a + b
| plusExpr a b => (arithEval a) + (arithEval b)
| mult a b => a * b
| multExpr a b => (arithEval a) * (arithEval b)

def e1 : ArithExpr := lit 1
def e7 : ArithExpr := lit 7
def e3 : ArithExpr := plusExpr e1 e7
def e4 : ArithExpr :=
(
  plusExpr
  (lit 6)
  (lit 9)
)

/-
*Type classes and instances
- Mechanisms in Lean that you use to overload operators
  - Ex: Overload plus for natural numbers, integers, reals, rationals, etc.
- In order for plus and times to make sense intuitively, want order of operations
  to remain the same
  - Done with time classes
- A type class is an ordinary object (*structure object*) with *one constructor*
  - One or more *fields*
  - Value oF a structure type will have multiple fields
- An *instance* is a value of that type

-- Ex: Typeclass Add
For any type α, add α
typeclass Add (α : Type) where
| (add α → α → α : function for adding things, parameterized by any type)

- Instance of a type class applies to some type
- Instance of that type class of which you should only have one holds additional data
  pertinent to that type
  - Ex: Adding foo objects, create a new instance of AddFoo (type class for providing addition)
    that instance will have one field
      - Provides implementation for that particular thing
- One instance per type that you want to add

-- Object that carries function for adding Nats
instance AddNat

Keyword for typeclass is *class*

- Lean keeps database of this instance
- Only some types for which plus makes sense
- Have to declare an instance for each type

In Lean, there is a + symbol for natural numbers, one for real numbers
- There will be one typeclass called Add applied to each type (Nat, float, matrix),
  which will go into a database for Lean doing compilation work
- When Lean evaluates expression, it will look for an instance of the Add typeclass
  for performing addition on that type

Heterogeneous multiplication
- Seperate class called Hmul
- Hmul typeclass will have 2 type parameters, not just one
- Expression will be the same
  - Same type will be homogenous multiplication
-/

-- Building our own natural number library

namespace KNat

inductive KNat where
| zero
| succ (n : KNat)
deriving Repr

/-
"deriving Repr"
- When you say that Lean automatically creates typeclass for that type
  and Repr typeclass is for taking type that you have and turn it into string
  that can print during eval
- Synthesize typeclasses for lean during eval
-/

def kzero := KNat.zero
def kone := KNat.succ kzero

-- With induction principles, can define recursive functions on objects

-- Just gave a new name to n.succ (notation for KNat.succ n, or dot notation)
def inc (n : KNat) := n.succ


/-
Case analysis on multiple arguments
- Case analysis on the second argument
- Can either be zero or the successor of something
-/
def add : KNat → KNat → KNat
| a, KNat.zero => a   -- Return the first number
| a, KNat.succ b => inc (add a b)  -- Successor of something that is one smaller
/-
Ex: 7 + 3
- Adding successor of 2
- Always want to recurse on something smaller
  - 7 + (2 + 1)
  - 7 + 3 is the successor of 7 + 2
- Pattern match on 2 arguments
- Case analysis on 2 arguments
- If the second argument is one more than b, return one more than sum of a and b
  - In this case, adding 7 and 2, then incrementing it
  - Recurse on the 3, then add one to each recursion
-/

#reduce add kone kzero  --KNat.zero.succ

-- Don't have this, haven't defined the plus symbol yet (not overloaded yet)
-- When plus sign is applied to 2 Knats, the Knat add gets run
-- #reduce kone + kzero

-- Will need to provide value for field Add which takes 2 KNats and returns KNat
-- If you create instance of KNat, it comes with everything from the typeclass

/-
- Requires 1 value to populate instance field
- Take our function and assign it as value of add field
- When you instantiate this typeclass, you get plus notation
-/
instance : Add KNat where
  add := add

-- Lean now parses plus correctly
-- When evaluating expression, it detects it as add
  -- Checks for heterogeneous first, then checks homogenous
  -- We have homogenous instance, so Lean uses that
#check kone + kone
#eval kone + kone

-- Carries value of zero for KNat
instance : Zero KNat where
  zero := KNat.zero

instance : One KNat where
  one := KNat.succ KNat.zero  -- Equivalent to kone

-- Implementing Mul
def mul : KNat → KNat → KNat
| _a, KNat.zero => KNat.zero
| a, KNat.succ b => add (mul a b) a
-- 7 * 4 = 7 + (7 * 3) = 7 + (7 + (7 * 2))
-- Adding a b times to itself

-- Multiplication instance
instance : Mul KNat where
  mul := mul

def expon : KNat → KNat → KNat
| _, KNat.zero => kone
| a, KNat.succ b => mul (expon a b) a
-- 7 ^ 4 = 7 * (7 ^ 3)

def kthree := KNat.succ (KNat.succ kone)
#eval expon kthree kthree

-- Exponential Instance
instance : Pow KNat KNat where
  pow := expon

#check ((1 + 1) : KNat)
#check ((1 * 1) : KNat)
#eval kthree ^ kthree


-- Overloaded Operators
-- In this case, type α might not have a "+" operator
-- There are only some types where + makes sense
-- Should take arguments as long as there is an implementation of add for that type
def addAnything {α : Type} [Add α]: α → α → α
| a, b => a + b

-- [Add α] → *Type Guard*
  -- Ensures that there is a typeclass instance for that type

-- Applies addAnything to 3 and 4, since there is a typeclass instance for Nat + Nat
#eval addAnything 3 4
-- Works, since we have overloaded addition for that type
#eval addAnything kone kone

-- Will not work, since there is no + operator for strings
#eval addAnything "Hi" "Hello"

/-
Assume you are given object of any type that satisfies properties of group:
  - Zero element, addition, associative, commutative, group is closed under addition, inverses

Will take any type you give as long as it is a group/typeclass instance for that type

Fields of a typeclass can also be proof objects
  - Expect, going forward, that when you have group typeclass instance, it comes with
    proof of the laws of being a group
-/
end KNat
