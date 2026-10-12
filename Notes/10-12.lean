/-
*Functions

Define functions that map from type T to something else?
- Ex: Natural numbers
  - Can't just use case analysis; would have to enumerate infinite cases
  - Ex: factorial function would use formal parameter and use inductive reasoning
    - Need a loop or recursion
    - Shape of the recursion mirrors the shape of the type
  - Finite number of constructors; 2 constructors:

inductive Nat where
| zero : Nat
| succ (n': Nat)
  - Also type checks as a Nat

-/

inductive MyNat where
| zero : MyNat
| succ (n': MyNat)  -- (succ zero)
  -- Also type checks as a Nat
  -- succ (succ zero) is also valid; can increment indefinitely

/-
-Can build a Nat of any size by starting at zero
-- Iterate application of successor 20 times
-- Unary notation
- Need to make sure values of Nat type can be interpreted as Nats
- Would need functions for Add, decrement, subtract, exponential, etc.

*Recursion follows the shape of the type
- If you apply factorial to some natural number
- If you are defining a function to return the right answer, you are
  given an arbitrary value of some type with more than one constructor
    - Need to do a case analysis, but only case analysis will not quite be enough
    - Need to have available the answer for n - 1
    - If you are given n and the answer for factorial(n), want to build the answer
      as a "high-rise", so will increment accordingly
    - Need to pick the right base case to return (in factorial's case, return 1)
- If you get something that is not the base case:

factorial 5 -> succ(succ(succ(succ(succ(0)))))
- Pattern match: zero or successor of something
- If the argument you get is the successor of something, you can extract that
- For factorial, you also need a multiply function and factorial of n-1

Think of recursion as *"ground-up constructor"*, where you start with base case and iterate
up to get to argument you want.

Example:
n | n!
....
3 | 3 * 3!
2 | 2 * 1!
1 | 1 * 0!
0 | 1

-/

/-
Need to pass in:
- n
- (n - 1)!

Just need to mult together to get answer for n
-/
def factStepFn (n : Nat)(ansPredN : Nat) :=
  n * ansPredN

/-
When doing proof by induction over the Nats, you have to consider
2 cases:
- Base case: get the answer
- Induction Hypothesis:
  - Either 0 or not 0; if not 0, have access to n - 1 and the answer for n - 1
  - If there is a simple formula to combine, get the answer for n
  - ansPredN is a parameter that you have the answer for n - 1; just need to define
    appropriate step function
When writing recursive function for Nat, stop thinking about descent through all the Nats
- If n == 0, then 1, else n * factorial(n - 1)
  - Just have to write the correct step function implementation that takes information, computes
    answer for n, and you're done
  - When writing recursive functions or inductive proofs, if you have the answer for the next step up,
    you're good
    - Bottom-up, instead of top-down
- If from proof that 0 has property, and want proof of 1, if there's a step function you can write
  to build 1 from proof of 0, can build an inductive proof from steps going to arbitrary n
  - In factorial example, answer is value of type in Type
  - If doing proof by induction, same idea, but defining function from Nat to pn (proof of n)
  - Start with base proof, then use that to build up proofs for next n up until you get to n that
    you want
  - If you have a way to do that for any n, you just have to iterate the step number a finite number
    of times
  - Gives you ability to define total functions for lean with types with infinite number of values
-/

/-
*Strong Induction

-To compute factorial, assume you are given n and answer for n-1
-To compute fibonacci, you need n and answers for n-1 and n-2
  - Would have to modify type of step function
  - Just simply arithmetic to compute answer for n

- Holds when outputs are proof values, rather than strong values
  - Can use proofs to construct proof for n
-/

-- Don't need to use n in function, but still need to define it for step function
def fibonnaciStep (_n : Nat)(ansNPredOne : Nat)(ansNPredTwo : Nat) :=
  ansNPredOne + ansNPredTwo

/-
What gives you right to say/claim that if you have a step function and base case, you will
get a function to answer for any n whatsoever?
- Not And.intro, Exists.intro, etc. -> Don't have axiom yet for base case and step function
- Answer is *principle of induction*

Every single inductively defined data type comes with its own induction principles
- Principle for Nat: if you give answer for base case 0 and inductive case (step function),
  will give back total function that, for any n, will give right answer
- When applying step function to answer for base case, it will come back and give total function
- For recursion/induction on Nats, intuitively, total function will apply the step function n times
  - Starts with base case and iterates step function 5 times
- Goes from finite world to infinite world in very simple way
  - If you define fake factorial case and have infinite recursion, lean will reject it
    - No matter what arguments you give it, it must terminate
    - Functions in lean are, subsequently, not turing complete (no possibility of infinite loops)
- Two cases to consider:
  - Base case
  - If you have term for succ(succ(succ(0)), representing 3, you get 3, extract answer for 2, mult together, etc.
    - You can subtract 1 n times from n; set of values of an inductive type is determined by all of the different ways
      in which you can apply constructors a finite number of times to get value
    - Will never reach infinity
    - When doing recursion, you will always get a smaller term before reaching the base case
    - Known as *structural recursion*; lean can tell when you are passing smaller structures of recursive call
- Example of recursive algorithm that doesn't use structural recursion
  - Merge sort
  - Quick sort → Get a matrix/array coming in, pick some pivot, then reorganize matrix around pivot
    and recurse on two sides
    - Will reorganize entire matrix; won't end up with substructures
    - In generative recursion, lean cannot tell if it cannot terminate
    - Need to supply proof of termination yourself; show that something is getting smaller every time
      you recurse
      - If lean accepts proof, recursion will terminate

How to do proofs on all integers?
- Every inductively defined types has own induction principle
  - Ex: String → length of string is 1 + length of head
  - Ex: Tree → length is length of left subtree + length of right subtree
- To do induction on empty, there is an axiom for that
  - Induction principle/recursor is being used

To prove some program in all programming languages, need to do proof by induction
- Computer programming languages can be defined as types with deep embedding
- Data type that defines programming syntax comes with its own induction principle
  - Need base case and induction for all other base cases with structural recursion
-/

-- Empty.rec is recursor; tells you how to define total function from
-- every value in empty set to type that you want

#check Empty.rec
/-
motive: total function you want to get back
  - Total function from any value of Empty type to any result (have to define)
  - Apply Empty.rec recursor function (axiom of induction for values of this type),
    leave placeholder, then let it assume it is given a value of type empty.  It will then
    return the answer for that value back.
-/

#check PUnit.rec
/-
Here, total function from unit to values of other type.
- Give value of type unit, have the answer for the base case, new value for
  which you want the answer, then get answer for that value t
-/


#check Bool.rec
/-

Bool.rec.{u}
  {motive : Bool → Sort u}
  (false : motive false) -- Value when input is false
  (true : motive true)  -- Value when input is true
  (t : Bool) :
motive t

Want Bool to String in example:
- To provide total function from Bool to String, need:
  - Value when input is false
  - Value when input is true
  - t that you want the answer to
Enough information accepted by induction principle to define total function
from Bool to String.

motive → return value
- More of an output parameter than input parameter
- Pieces of information that you are applying to induction principle
- 1 answer for each possible value
-/

#check Nat
/-

inductive Nat where
  | zero : Nat
  | succ (n : Nat) : Nat

Needs motive as an output, base case, and step function/successor case
-/

#check Nat.rec
/-
Nat.rec.{u}
  {motive : Nat → Sort u}
  (zero : motive Nat.zero)
  (succ : (n : Nat) → motive n → motive n.succ)
  (t : Nat) :
motive t

Can get a total function called "motive" that is applicable to any Nat
- For any t, can get an answer for t provided you apply the function for the
  base case and successor case
- If given non-zero input, "n" is a value for which we have an answer, and "motive"
  will return answer for n + 1
  - If given n and answer for n, will return answer for n + 1
  - If you give an answer for 0, and you give a function that takes any natural number and
    answer for natural number, and returns answer for more than 1 natural number, then, given
    t, will return answer for any t
- Every single data type comes with its own induction principle
  - Can apply Nat.rec to answer for base case and step function, you get back a function that,
    given any natural number t, returns the answer for t
-/

/-
Comes with an induction principle that shows how you get an inductive type on any principle.

Induction principle needs answer for empty and a step function
- Will assume it has the answer for the number of nodes in left tree and number of nodes in right tree
- Will add together to compute size
-/
inductive natTree where
| empty
| node (left right : natTree)


#check natTree.rec
/-
natTree.rec.{u}

{motive : natTree → Sort u}
  (empty : motive natTree.empty)
  (node : (left right : natTree) → motive left → motive right → motive (left.node right))
  ---
  (t : natTree) :
motive t

Just need to apply recursor for step function
- Need to figure out the right step function

If you are given tree using node constructor, this function will compute answer for this tree
- Assumes you have left and right trees, along with answer for left tree and answer for right tree
- Both subtrees can be empty, so motive left will be 0 and motive right will be 0
  - Get an answer for a tree with a node at the top with the left and the right
- (left.node right) → Forcing the left tree to be non-empty
  - Builds a node for the left and the right
-/

/-
*Exists.elim Clarification

When talking about introduction rules, they are given by the constructors for the type
- inl and inr constructors
In lean, constructors of a type correspond to introduction rules (building/proving value of given type)

Elimination rules are the recursor that tells you how to use value of given type
- Tells you how to define total function from values of any type to values of some other type
- Come straight from recursors/induction principles

Exists.elim {u}
{α : Sort u}
{p : α → Prop}
{b : Prop}
  -- Want proof of some proposition p

Two explicit arguments:
(h1 : ∃ x, p x)
  -- Proof that there exists some x with property p
(h2 : ∀ (a : α), p a → b)
  -- Top level constructor is arrow, not ∀
  -- If every object has property p, and b is true as a result, then b is true
  -- No matter which one you look at, you get proof of b
  -- Whenever all objects of type has property p, and b is true, then b is true
  -- If α is empty type, it is not good enough
:
b
-/
