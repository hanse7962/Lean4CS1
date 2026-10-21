/-
With natural language, can't check specifications for specifics

With first exercise, can't negate a Nat value
(It has an inverse, which, when added
to original number, they equal the identity function)

Goal is to implement proper, formal specifications.
- Autoformalizing works at scale now; can write specifications of pieces
of what you want to build

Can't have operational semantics for turing-complete language
- No way to tell when it's an infinite loop
- Figure out what the answer is, then write a proof saying its
the right program
- Computation to reasoning/proofs when you want to show that
program computes result

In arithmetic, have:
- Carrier set (natural numbers in which everything operates)
- Special values (0, 1, etc.)
- Functions (add/multiply/subtract)
-/

namespace KNat

inductive KNat where
| zero
| succ (n : KNat)
deriving Repr

def kzero := KNat.zero
def kone := KNat.succ kzero
def ktwo := KNat.succ kone
def kthree := KNat.succ (KNat.succ kone)

instance : Zero KNat where
  zero := KNat.zero

def inc (n : KNat) := n.succ

-- Decrement: must destructure (pattern match) argument
-- So the argument must be to the right of the colon
def dec : KNat → KNat
| KNat.zero => kzero          -- decrement zero is zero (truncation)
| KNat.succ n' => n'          -- decrement *one more than any n'* is n'


def add : KNat → KNat → KNat
| a, KNat.zero => a
| a, KNat.succ b => inc (add a b)

instance : Add KNat where
  add := add

/-
Use case analysis for zero and successor

- Definitional equality: 7 - 0 = 7 (same value)
- To show 0 - 3 has a particular value, need a proof
    - Distinction between definitional equality (explicit answer) and proof
-/
def sub : KNat → KNat → KNat
| a, KNat.zero => a
-- No way to represent negatives in natural numbers
--| KNat.zero, _b => KNat.zero
-- Reduce both values by 1 recursively until you get a - 0
--| KNat.succ a, KNat.succ b => sub a b
| a, KNat.succ b => dec (sub a b)

#eval sub kthree ktwo

def mul : KNat → KNat → KNat
| _a, KNat.zero => KNat.zero
| a, KNat.succ b => add (mul a b) a

def expon : KNat → KNat → KNat
| _, KNat.zero => kone
| a, KNat.succ b => mul (expon a b) a

def eq : KNat → KNat → Bool
| KNat.zero, KNat.zero => true
| _, KNat.zero => false
| KNat.zero, _ => false
| KNat.succ a, KNat.succ b => eq a b

#eval eq kthree kthree
#eval eq kthree ktwo

def leq : KNat → KNat → Bool
-- a == b; could remove
| KNat.zero, KNat.zero => true
-- a > b
| _, KNat.zero => false
-- a < b
| KNat.zero, _ => true
-- Recursively decrement a and b
| KNat.succ a, KNat.succ b => leq a b

#eval leq kthree ktwo
#eval leq ktwo kthree
#eval leq kone kone

def geq : KNat → KNat → Bool
-- a == b
| KNat.zero, KNat.zero => true
-- a > b
| _, KNat.zero => true
-- a < b
| KNat.zero, _ => false
-- Recursively decrement a and b
| KNat.succ a, KNat.succ b => leq a b

/-
Can reduce greater than to one line (negation of leq)
-/

def gt : KNat → KNat → Bool :=
    fun n m => !leq n m

def lt : KNat → KNat → Bool :=
    fun n m => leq n m && !(eq n m)

-- In effect, depending on compiler optimizations, could be less computationally
-- efficient with case analysis
def geq' : KNat → KNat → Bool :=
    fun n m => !lt n m

def geq'' : KNat → KNat → Bool :=
    fun n m => (!gt n m) || (eq n m)

/-
In propositional logic, have:
- Literals (T F)
- Variables
- Boolean Expressions (not, and, or)

Not able to write "and (x = y)(y > 5)", but should, since
expressions return booleans

Challenge: Take booleans we've just defined, move them into
propositional logic, then import arithmetic module
- What we've just done is outlined a way to extend pure propositional
logic with arithmetic expressions inside terms
    - Evaluations will return fine
    - Can call arithmetic boolean predicates to evaluate in expressions
- Here, you have propositional logic extended with arithmetic expressions
    - Inside parentheses, can put expressions of lists, list substrings, etc.
    - As long as they return bools, can have a sub-language of list algebra

Can determine if there is a solution to a pure propositional logic formula
- Is there a solution to X && Y? → Satisfiability problem
    - "Is there a model of X and Y?" "Is there a binding of X and Y such that expression is true?"

Is there a solution to X < 5 and Y < 7?
- There is more than 1 solution, any combination will be models of
that formula

With bit vectors, can write constraint expressions over bit vectors
that satisfy specification
- As long as you have solvers for arithmetic, lists, and bit vectors,
can add solvers into skeleton that is provided around propositional logic
structure and write complex constraints over interesting data
    - We get a *satisfiability modulo theory (SMT) solver*
    - Great for software testing
- Start with piece of code, and write conditions to get them there

Being np complete → can be reduced to satisfiability
- Worst-case exponential
    - False && .... -> easy to solve
- Heuristic at the end of the day
    - Analyzing structure, figuring out variables

Natural numbers are a well-ordered set (there is a base case)
Integers are not well-ordered (no number that is less than any other integer)
- Thus, recursion will keep going down, so they can't be recursed
- From an induction principle, want a total function for every input
-/
end KNat


/-
## Higher order functions

List of strings: want a corresponding list of all their lengths
- Want a function that takes a list of α's and returns a list of β's
- Take the incoming list
    - Lists are similar to Nats, but can be:
        - Nil
        - Cons (constructed, element at front of list, then smaller list)
            - Takes a single element and a smaller list, then gives list where element is at front
    - Similar to stack (LIFO)
- Ex: multiply all elements together
    - If empty: 1
    - Otherwise, head * product of the rest
- Can write a function that takes the list of elements and binary function
with base case value, then does recursion
    - Problem: If base case is 0 for multiplication, output will be 0
    - If you don't provide the correct base case, it won't work
- If you provide minus as the operator:
    - Might clamp at 0
    - Subtraction is not associative
        - To fold function to work properly, need list of inputs, binary operators
        and special value for base case, also need to ensure element is valid for that operator-
- Think of list as parsed from right to left

For fold to work, need:
- Operator
- Identity (left identity and right identity)
    - 1 * n = n → left identity
    - n * 1 = n → right identity
- Need a proof that whatever value you provide for identity is both
left and right, and you need proof that operator is associative
- When you have all that, you have an algebraic structure/monoid

*Monoid* → set of objects, binary operator (+, *) that is associative, along
with special value that is identity element for that operator
- As you go through textbook in functional programming, need applicative
- Two at least on Nat: additive and multiplicative
- Allows you to take any binary operator and turn it into an n-nary operator (takes any arguments)
- Gives you the license to lift a binary operator to be an n-nary operator
- Completely generic polymorphic object that lets you overload any binary operator
on any type of object as long as the laws are satisfied

Will package up input operator/type of operator, identity, and three proof objects
for fold to work properly in all cases
- Need to provide proof of associativity for operator

List is polymorphic type builder
-/

namespace AbstractAlgebra

def productNat : List Nat → Nat
| List.nil => 1
-- Destructure list (head and tail), then multiply head by product of tail
| List.cons h t => h * productNat t

#eval productNat [2, 3, 4]

/-
Signature is fundamentally broken;
can call in type correct way, but can return wrong answer
-/
def reduce {α} (op : α → α → α)(id : α) : List α → α
| List.nil => id
| List.cons h t => op h (reduce op id t)

#eval reduce (. * .) 1 [2, 3, 4]
#eval reduce (. + .) 1 [2, 3, 4]

-- Solution is to define typeclass Monoid (α)
-- If you package all these up together, can redefine fold
-- so it must take an argument of this type
class Monoid (α : Type u) where
    op : α → α → α
    id :α
    assoc : ∀ a b c, op (op a b) c = op a (op b c)
    idLeft: ∀ a, op id a = a
    idRight : ∀ a, op a id = a

-- Can go from monoid to group by adding inverse operation

end AbstractAlgebra
