/-
Constructs in language of predicate logic have
corresponding implementations in programming type theory

Pred Logic:
- ∧, ∨, ¬, →, ↔
- Language of propositions in predicate logic is defined
  inductively (can build bigger things out of smaller things
  of the same kind/logical connectives)
  - To prove And, prove both
  - To prove OR, prove one
  - To prove NOT, not clear
  - etc.

Type Theory
- Infinitude of different types you can define
  - User-defined
  - Inductive, different constructors, etc.
- Curry-Howard construction:
  - Each pred logic type corresponds to a type in type theory
  - Not isomorphic (doesn't go both ways, some types are not
    covered by pred logic)
  - Ex: AND
    Prod AND

Embedding/implementing language of predicate logic
- Building/implementing predicate logic with reasoning principles
- Defining/implementing it using shallow embedding of language of pred
  logic into lean
    - *Shallow embedding*: Each construct on left gets represented as lean type
      (Language constructs as types/type builders)
    - End up with abstract mathematical theory (high order constructive
      predicate logic embedded into type nature of lean)
- Formalization of predicate logic; do the same sort of thing
  in topology
- Ex: Vector embeddings: define right types, embed them into lean
- Here, programming abstract mathematical language itself, along
  with meanings
  - Other languages don't have propositional capabilities to do this

Logical conjunction as type:
- Can read most expressions as logic or programs
- Proof of ↔ is function going in both directions
  - Always a derivation from one to another that lets you go
    back and forth

Propositional logic is just boolean algebra

Deep Embedding:
- Expressions in language are not mapped to different types of
  objects in lean; all captured as different constructors in lean
  (formalizing syntax of language)


-/

/-
Not just literal true/false, but also has variables
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

def e1 := F
def e2 := T
def e3 := PropLogic.And e1 e2
-- X, Y, and Z are variable expressions
def e4 := PropLogic.And X Y

-- Do you always need to write spec beforehand?
--- Delta reduction: when you use name of term, delta reduction substitutes type
--- If you say def, it is a new type
--- def varInterp accepts it as a new type definition

-- Semantics of language (turns syntax into corresponding meanings in semantic domain (domain of bool algebra))
#eval eval e1 i1
#eval eval e2 i1
#eval eval e3 i1
-- If evaluated under different interpretation, may return a different value
#eval eval e4 i1
#eval eval e4 i2

/-
What does it mean for X and Y to be satisfiable?
- Can find configuration of variables that it evaluates to true.
- Here, would only need to find up to 8.
- Decision procedure (eval expression under all 8 interpretations.  If any come out true, it is
  satisfiable.  If all come out true, it is valid.  If all come out false, it is unsatisfiable.
Examples:
- X is satisfiable (can be true).
- X or ¬X is valid (any value of x evals expression to true)
- P and ¬P is unsatisfiable (no value of P evals expression to true)
-/

/-
^ Use operational semantic (takes a term in language and evals it to meaning)

In C++, can't know that any arbitrary C++ program will terminate or output anything (i.e. not total function)
Cannot write operational semantic in lean that outputs function and outputs answer.

In Lean, can define simple function that takes any term of PropLogic and returns
value of that type.

How to compute truth value of p1 and p2, where p1 and p2 are either t or f?
- Recursively eval p1 and p2 (get true/false)
- Evaluate boolean function that corresponds to syntax (in this case, and)
- Entire embedding of syntax and semantics of prop logic into lean
-/

-- Def of syntactically correct terms; any term you build of
-- this type is syntactically correct

-- If you map semantics from C code and x86 code, they are semantically equivalent
-- (first semantically correct C compiler)

-- Can define computational semantics into lean; needed for trustworthy compilation train
-- If you need to write code for a domain for an application regulated by FAA, and you
-- want to convince regulators that system is safe, you can say that you
-- used the proof compiler to verify it

-- There is a C compiler here in Lean

/-
Lean includes a totality checker to ensure that all terms are
included.  If you have a case that isn't covered, Lean will output error.

If you have 5 mil lines of Lean code, and you add a case
to lean def, every single place in Lean code will light up
and will output errors.
- Solution is to go in and add construct.
-/

/-
All of the above is a deep embedding: all of the terms in logic
are of one type.

This is typically what you'll see when building type language in Lean.
- Once you introduce while loops, all bets are off as to whether program terminates.
- Need to move from computational evaluation to logical reasoning about programs.
-- Need to reason about whether program terminates; write propositions about programs, then
   terminate them.
-/

-- --------------

/-
Products are commutative.

And object of α × β is an ordered pair of (α, β)
- (α × β) → (β × α)

If Prod Logic is AND, Curry Howard of logical twin is ×
- Ex: Nat × Bool
  - (0, false)
  - (1, true)
  - etc.
- Nat ∧ Bool (predicate logic expression combined as type)
  - ⟨ p : P, q : Q ⟩
  - Nat × Bool → Bool × Nat
  - If proof P and Q is pair of proofs, proof of Q and P can be derived
  - from proof of P and Q
    - P ∧ Q → Q ∧ P
- Build proof of AND by building proof of both
  - Use by reaching into it and pulling out contents

AND (∧) ⇔ Prop ×

To prove X OR Y is true, need to show at least one is true
- Want its meaning to be true if there's a proof of X or proof of Y

SUM x + y ⇔ OR
  | inl (x : X)
  | inr (y : Y)
-/

-- Contains types of α or β
-- Introduction rule
inductive SumExample (α : Type u)(β : Type v) where
  | inl (val : α) : SumExample α β
  | inr (val : β) : SumExample α β

-- Define 4 types
  -- all inhabited -> default constructor mk is used by all structures
structure Rice
structure Potato
structure Fish
structure Chicken

def choiceChicken : Chicken ⊕ Fish := Sum.inl Chicken.mk
def choiceFish : Chicken ⊕ Fish := Sum.inr Fish.mk

-- Elimination rule: Case analysis
def meatToString : Chicken ⊕ Fish → String
  | Sum.inl _ => "Chicken"
  | Sum.inr _ => "Fish"

-- Elim rule for obj of multiple constructors: need to provide an answer for all constructor cases
-- So you know you get to final result without input cases.

-- Can you return an object of type Fish or Chicken?
-- return inr Chicken

-- HW:
-- Prove sum is commutative (swap order)
-- Show exactly same thing for OR

example :
 Fish × (Rice ⊕ Potato) →
 Fish × Rice ⊕ Fish × Potato
 | (f, rorp) => sorry
