/-


-/

inductive MyOption (α : Type) : Type where
| None
| Some (a : α)

def dec : Nat → MyOption Nat
| 0 => MyOption.None
| (n' + 1) => MyOption.Some n'

/-
Inductively, list is either empty or a list followed by smaller
items.

In the case: [1, 2, 3, 4], it is 1 followed by the list [2, 3, 4]

List shapes can be nil or cons H (α) T (List α)
-/

inductive MyList (α : Type) : Type where
| nil
| cons (h : α)(t : MyList α)

def head {α : Type} : MyList α -> Option α
| MyList.nil => none
| MyList.cons h t => some h

def head' {α : Type} : List α → Option α
| [] => none
| h::t => some h
-- h of type α, t of type List α

/-
Takes binary function over alphas.
- f → function (addition, multiplication, etc.)
- id → list elements

h::t is equivalent to "cons h t"
-/

-- Returns reduced value of list
def myFold {α : Type} (f : α → α → α) (id : α) : List α → α
| [] => id -- Returns the base case with the empty list
| h::t => f h (myFold f id t)  -- Applies function bottom-up

#eval myFold Nat.add 0 []
#eval myFold Nat.add 0 [5, 4, 3, 2, 1]

/-
What can go wrong?
- Cause have the wrong id/base case
- Nothing that forces you to case the right identity value
-/

-- Every product multiplied by 0 (answer for empty list)
-- Need to have a way to know that whatever value is passed is
-- identity element for this operator.
#eval myFold Nat.mul 0 [5, 4, 3, 2, 1]

-- What it would be if correct
#eval myFold Nat.mul 1 [5, 4, 3, 2, 1]

/-
Fold needs a list, a value, and an associative operator
- Ex: add works regardless of where the parentheses are placed
- Division, subtraction, and exponentiation are not associative

What does it mean to be associative?:
- ∀abc, a, f (b c) = f (a b), c
-/

def myFold'
  {α : Type}
  (f : α → α → α)
  (_f_assoc : ∀ (a b c : α), f (f a b) c = f a (f b c)) -- Proof that α is associative
  (id : α)
  (_fid : ∀ a, f id a = a ∧ f a id = a)
  -- ^ Proof that identity is, in fact, the identity for that function
  -- Will never be able to apply fold function unless you provide all args
  : List α → α
| [] => id
| h::t => f h (myFold f id t)

/-
Add and Mul Functions look the same, except for the binary
operator in the identity

Can supply any α, any identity, and any operator to get an answer.
Should also have an enforced constraint.

(. * .) -> Applies mult to two values

Lean's version is List.foldr (. <op> .) <id> <list>

It all type checks, but it's wrong because there is no enforcement for the
arguments to have all the properties for the function to work properly.
- Need to pass all the proof functions.
-/

def isIdentityFor {α : Type} (op : α → α → α) (id : α) : Prop :=
  ∀ a, op id a = a ∧ op a id = a
-- Need proof of left side and proof of right side
-- From lean's libraries, just pull out the required proofs

example : isIdentityFor (α := Nat) (. * .) 1 :=
  fun a => ⟨Nat.one_mul a, Nat.mul_one a⟩

/-@@@
## Monoid
- Pulls all pieces together in a completely generic way.
- Object of a type carries its data
  - Binary operation
  - Identity of type α
  - Proof of the three laws (associativity, left identity, right identity)
- Representation of an abstract algebraic operation
- Pick whatever type you want for α

As long as you have a monoid, it lifts the binary operator and turns it into
an n-ary operator
- Can apply to 0, 10, 1000, etc. args, as long as you have a list
@@@-/

class Monoid (α : Type u) where
    op : α → α → α
    id :α
    assoc : ∀ a b c, op (op a b) c = op a (op b c)
    idLeft: ∀ a, op id a = a
    idRight : ∀ a, op a id = a

/-
Examples:
- Add with 0
- Mul with 1
- String concatenation with ""

Valid proposition → true for all values of type α

If you have a list of all the possible evaluations, and you want a list for
all possible truth values, you would need a truth table.

x ∧ y ∧ z
In our case, we fold with AND with the list of boolean values and T as the identity
- We have a list of interpretations and want a list of correpsonding outputs
- In other words, "#eval"

isValid (p : PropLogicExpression)
- Map eval over the list, which applies eval to each interpretation to
get output
- In other words, Map a function over list to list

- Reduce with OR if you want satisfiability
- Reduce with AND if you want validity
- To get unsatisfiability, reduce with AND, then negate the result

Take incoming list, then turn element of one list to an element of another list

Fold applies operators to reduce to single value
- Map followed by fold is very common operation
- Fold is an ubiquitous operation in computing
-/

def myMap {α β: Type} (f : α → β) : List α → List β
| [] => [] -- Empty list of α to empty list of β
| h::t => (f h)::(myMap f t)
-- Convert the head as front element of new list, followed by map function on
-- remainder of list

#eval myMap (fun n => n*n) [1,2,3,4,5]

/-
Can you define an option to map on option values?
- Map on None is None
- Map on f Some α is Some f α

Can make construction polymorphic in container type
- Option is another type of container (contains 0 or 1)
- Can map a tree of natural numbers to tree of string representations
  - Tree is a container where you can get a map
- Fold can be made parametric in container type, becoming super generic
  - Monoid over any container type
-/
