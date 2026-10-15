/-
1 more embedding of formal language of Lean

In this case, embedding arithmetic (assume we have "Nat" data type):
- Literals expressions
  - Increment (x++)
  - Add (x + y)
      - Ex: increment x y times
  - Multiply (x * y)
    - Iterated addition
  - Exponentiation (x ^ y)
    - Iterated multiplication
  - Tetration ((x ^ x) y times)
    - Iterated exponentiation
- Infix notation (ex: 3 + 4 reduces to 7)

Need a lot of recursion to compute results for arbitrarily large numbers
- Recursion and induction in lean are eventually compiled down to recursors/induction principles

Defined:
- Syntax type (forms and expressions)
- Evaluation expression

Elimination rules are how you use the values of a given type
- Ex: If parameter is a bool, have to do case analysis
  - Recursor says that you have a function for each bool val if you have a branch for each case
  - You have to give code that computes the desired answer in two different cases
- Recursors are the foundation for defining total functions from inductive data types to
  other data types
  - All other stuff is just notation
  - Only works if they give result for *all possible cases*
- Elimination rules for function types -> apply
  - Functions are not inductively defined
- 'match' and 'def' are notations for what is compiled into recursor

Because of some incompleteness in current implementation of Lean, it won't
always compile a call to recursor into compiled code in lean.
- In these cases, you can't use eval
- Can use #reduce to directly parse it
-/

-- *Empty / False : no constructors
/-
- Recursor needs no ways for computing a result whatsoever
-/

example : Empty → String := λ e => nomatch e
-- λ is a function that takes an arg e such that you don't need to consider any cases
-- i.e. λ ≃ fun

-- Principle returns regardless of return type
--Assume you have empty type, then eliminate since there are no cases
example (α : Type u) : Empty → α := fun e => nomatch e

/-
Eliminations are just applications of recursors
- Programming patterns work exactly the same as reasoning patterns
-/

-- Prints definition of automatically Lean computed recursor for empty type
#check @Empty.rec
/- @@@
Empty.rec :
  (motive : Empty → Sort u_1) →   -- given a function on non-existent values
  (t : Empty) →                   -- and given any such value in particular
  motive t                        -- the function will compute an answer
@@@ -/

/-
- Accept arg of type empty, then returns the result
- Apply Empty.rec to a String
  - Just the way that you communicate to recursor what type it outputs to
- No answer ever gets produced
  - No cases with Empty passed as arg, so can't apply it anyway
-/
def e2s : Empty → String :=
  fun e =>
    Empty.rec
      (fun _ => String)
      e
-- Will return a '(fun _ => String)' back
-- Empty → String is necessary to communicate output of function

-- For Curry-Howard correspondence:
--  - No proofs of false

-- nomatch is notation for Empty.rec (fun _ => Nat) e
def fromEmpty (e : Empty) : Nat :=
  nomatch e

-- False elimination; gives recursor for false
theorem fromFalse (h : False) : 3 = 4 :=
  nomatch h

-- *Unit / True : one constructor, no data
-- Would expect recursor to require answer for that one case

#check @PUnit.rec
#check @True.rec

/- @@@
@PUnit.rec :
  {motive : PUnit → Sort u_1} →
  motive PUnit.unit →
  (t : PUnit) →
  motive t
@@@ -/
/-
Unit is a version of PUnit

Function from Unit to some type:
- Whenever you want a function from any other type,
need a function from unit to that type
- Need a way of computing the answer for that one case
-/

/-
Defining function fromUnit to String
- Apply recursor, give answer for one case, apply to u, then get answer for that case
- noncomputable is there since Lean does not compile it into executable code
-/
noncomputable def fromUnit (u : Unit) : String :=
  PUnit.rec "only this" u
  -- u is required, since applies the string/answer to unit (single value)
  -- When you apply the function to ()/void/unit, you get back the string

#reduce fromUnit ()

-- Ordinary notation for function definition, which is compiled into application of recursor
noncomputable def fromUnit' (_u : Unit) : String :=
  "this is the only"

--*Bool : Two values

/- @@@
@Bool.rec :
  {motive : Bool → Sort u_1} →
  motive false →
  motive true →
  (t : Bool) →
  motive t
@@@ -/

/-
- Curly braces → don't have to provide value explicitly; get back as return result
- Want answer back for both false and true; if you provide both, you get answer back
- If you have inductive constructor, you will have 3 cases instead of 2
  - Recursor tells you how many cases you need to provide computations for
-/

/-
- Give answer for false (first case)
- Give answer for true (second case)
- Provide b, then return value
-/
noncomputable def describe (b : Bool) : String :=
  Bool.rec "false" "true" b

-- By moving bool arg from left to right, you bind a name using pattern matching
def describe' : Bool → String
| true => "true"
| false => "false"
-- ^ this is how you should typically write it, but compiled down, it is equivalent
-- to the previous example

-- Neither bool constructor carries any additional data
-- When arg of constructor is same type as defined type, then it is truly recursive

--*Nat : recursive constructor
/-
One constructor carries additional data (value of type Nat)
- Successor of given nat is of type Nat
- Increment given value to get next Nat up
-/

/-
Takes a Nat, then returns a Nat
- If given 0, returns 0
- If given n' + 1 for non-zero arg, then sum of all numbers from 0 to n' is
  successor of n' + 1 + sum of all numbers from 0 to n'

For induction on Nat, how do you know that you can return the right answer for any Nat,
no matter how big it is?
- Cannot do case analysis for 1 nat at a time
- Inductive type lists ways that you can build a type of type Nat
  - Zero or Successor of Nat
  - Successor term represents bigger Nat
- If you have a proof for n', you can get a proof for n' + 1 by writing a step function
  - "sumUp n'" is the step function
  - Add n, then assume you have the proof for n - 1
- Have an incoming arg, do pattern matching
  - If you just wrote n, you wouldn't be able to extract smaller number that
    bigger number is built from
  - If we get 3, we can extract the 2
-/
def sumUp : Nat → Nat
  | Nat.zero => 0
  | Nat.succ n' => n' + 1 + (sumUp n')
  -- | Nat.succ n' => (n' + 1) + sumUp n'
  -- Passing functions applied to input value
  -- When you put a function call in front of input, Lean cannot tell that it is a structure of recursion
    -- Not programmed to think about how subtraction works
  -- Ex: if you pass 1, it is the same as Nat.succ 0, so n' would be 0
    -- Binding a name n' to the piece of the original argument
    -- When you do sumUp on n', that would be 0, so that would return 0

#eval sumUp 1
#check @Nat.rec

-- Compiles to a recursor call
def fac : Nat → Nat
| 0 => 1 -- Equivalent to Nat.zero
| (n' + 1) => (n' + 1) * (fac n') --Equivalent to Nat.succ

#eval fac 5

/- @@@
Deals with 2 cases: zero and succ
- If it is true for n - 1, it is true for n

@Nat.rec :
  {motive : Nat → Sort u_1} →
  motive Nat.zero → -- Computes answer for 0
  ((n' : Nat) → motive n' → motive n'.succ) →
    - If given any natural number n',
      and an answer for that natural number,
      and answer for that, return answer for successor
    - Induction is the key principle; induction axioms for values
      of particular data type
  (t : Nat) →
  motive t
@@@ -/

-- Can implement factorial with Nat.rec
-- 1 => base case
-- (fun n ih => n + 1 * ih) => step function
  -- (n + 1 * ih) => Answer for n + 1
-- Gets compiled down into call for recursor
def fac' (n : Nat) : Nat :=
  Nat.rec 1 (fun n ih => (n + 1) * ih) n

-- Lean allows compilation for recursor code for nat only

#eval fac' 0
#eval fac' 5


-- *String: Carries data and a proof
/-
String is empty or character followed by smaller string
- For performance reasons, Lean defines it as an *array of characters*
-/

/- @@@
@String.rec :
  {motive : String → Sort u_1} →
  ((toByteArray : ByteArray) → -- 1 case, since there is only one constructor
    (isValidUTF8 : toByteArray.IsValidUTF8) →
    motive { toByteArray := toByteArray, isValidUTF8 := isValidUTF8 }) →
  (t : String) →
  motive t
@@@ -/
noncomputable def byteLength (s : String) : Nat :=
  String.rec (fun toByteArray _ => toByteArray.size) s

#reduce byteLength "hello"
#reduce byteLength ""

/-
The elimination rules that we have discussed for proofs or values
of inductively defined propositions/types (And.left, Prod.left/right, etc.)
are boiled down to recursors.

Have to have induction principles in logic to define total functions for input domains
into outputs.
-/

--*Defining arithmetic into Lean
namespace Arith

inductive ArithExpr where
| lit (n : Nat) -- lit 7 would be an arithemtic expression
| plus (n m : Nat) -- Prefix notation
| plusExpr (n m : ArithExpr) -- Prefix notation

-- Overloading: need a type class
  -- A type, from which the value can be associated with a type of that Type class
  -- Ex: Add type class with an instance for Nat, different instance for Matrix, different instance for float
  -- Define plus as operator that takes any type operator whatsoever, as long as there is a type instance for plus
  -- Can look into type instance and run function for Nats

open ArithExpr

-- Expressions using syntax
def a1 := lit 1
def a7 := lit 7
def alit : ArithExpr := lit 7

def p12 := plus 1 2
def p48 := plus 4 8
def a1Pa7 := plusExpr a1 a7 -- Need to define an eval expression for ArithExpr

#eval alit
#eval (a1Pa7)

-- Operational semantics (function that gives analysis result for program in language)
  -- Nat is the semantic domain
  -- Given any term, returns semantic meaning, which, for us, will be natural number

def arithEval : ArithExpr → Nat
| lit n => n --Return piece of data that it carries
| plus a b => a + b
| plusExpr a b => (arithEval a) + (arithEval b)

def arithEval' (t : ArithExpr) : Nat :=
  match t with -- Need to pattern match with named value
    | lit n => n --Return piece of data that it carries
    | plus a b => a + b
    | plusExpr e1 e2 => (arithEval e1) + (arithEval e2)
      -- Equivalent to Nat.add (arithEval e1) (arithEval e2)

-- Equivalent to (7 + (7 + 9))
def p1 : ArithExpr := plusExpr (lit 7) (plusExpr (lit 7) (lit 9))

#eval arithEval p1

end Arith

-- Variables:
-- Define a second function that takes any variable, gives value (interpretation)
-- Need function you can call to get value of any variable
  -- Will apply function to any variable expression

-- HW: Add Mult/Times and Exponential
