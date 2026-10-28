/-
Monoid:
- Need type/set (carrier set of monoid/group)
  - Imposes group structure as long as the laws are followed
  - Can be a field, but better to set the monoid class over a single class
    - Bundled: 1 type arg over all members
    - Unbundled: Type arg for each member
- Contains:
  - Binary operator
  - Identity
  - Associativity proof
  - Left and right identity proof
- Can have a monoid over bools
- Gives ability to take binary function and turn it into a function on
any number of arguments given as a list
- Having defined class monoid, can instantiate it by providing arguments

**instance**: create an object of that type, but register it with Lean environment's
registry of typeclass instances
-/

class Monoid (α : Type u) where
    op : α → α → α
    id :α
    assoc : ∀ a b c, op (op a b) c = op a (op b c)
    idLeft: ∀ a, op id a = a
    idRight : ∀ a, op a id = a

instance : Monoid Nat where
  op := (. + .) -- Notation for "plus" operator
  id := 0
  assoc := Nat.add_assoc -- Pull proofs from lean library (proofs by induction)
  idLeft := Nat.zero_add
  idRight := Nat.add_zero

instance : Monoid String where
  op := (. ++ .)
  id := ""
  assoc := fun _ _ _ => String.append_assoc
  idLeft := fun _ => String.empty_append
  idRight := fun _ => String.append_empty

/-
If you create Monoid Nat for 2 instances, both instances are registered into
Lean's database, you will get one or the other.

Almost always a mistake to register more than one instance for a typeclass.
Lean will just pick the first one it finds (indeterminate, but implementation detail)

To deal with this problem:
- Have different typeclasses
- Don't rely upon Lean's ability to look up typeclass instances; create instances
yourself and pass them around explictly
-/

/-
**Fold**, in functional programming, is a higher-order function

A higher-order function takes other functions as arguments and returns
other functions as result.

**Map**

Takes list of arguments and an element-to-element (ex: String to Nat) function
where correspondence between each is given by the function.
-/

/-
List to list, where you transform input list elements to
output list elements.
- Output list is the same length/shape as the input list
- If given list of α's, compute list of β's
- If given empty list, return empty list
- If given non-empty list with head of α, output list is
transformed α ahead of answer for rest of list

How could it be messed up so it doesn't work as you expect?
- Return list with α instead of empty list → shape of returned list is
greater than input list
-/

def map {α β} (f : α → β) : List α → List β
| List.nil => List.nil
| List.cons h t => List.cons (f h) (map f t)

#eval map (. * 2) [1, 2, 3]
#eval map String.length ["ab", "", "xyz"]
-- Can get total length of list of strings
-- by mapping lengths to list of ints, then fold new list

/-
Fold:

Include Monoid α in square brackets:
- Go into type class database and look for instance of this type
  - If you call mfold where list elements are Nat, look up to see if there
  is Monoid α instance in database
  - In body of function, fetch instance and get data it is carrying
- If you fold list of Nats, get monoid instance for Nat, then apply
operator to all elements in list
-/

def mfold {α : Type} [Monoid α] : List α → α
| List.nil => Monoid.id
| List.cons h t => Monoid.op h (mfold t)


def totalLength (strs : List String) : Nat :=
  mfold (map String.length strs)

#eval totalLength ["abc", "de", "f"]

/-
In Lean, AddMonoid is used for additive operations, while Monoid is used
for multiplicative operations

Additive monoid and multiplicative monoid for Nats can coexist in Lean.
'[_root_.Monoid]' takes you out to imported namespace.
-/

/-
def foldMonoid {α : Type} [_root_.Monoid α] (xs : List α) : α :=
  xs.foldr (· * ·) 1

def foldAddMonoid {α : Type} [AddMonoid α] (xs : List α) : α :=
  xs.foldr (. + .) 0
-/

/-
Foldable:
- Generalize type of list elements.
- Collection type can vary between list types
- Once you have this, you have the keys to understanding typeclasses
in functional programming
- Can generalize over container type/data structure
- Can have fold that takes a list/tree/map of objects and return the sum
-/

/-
Binary tree

Left and right node, and value
-/

inductive Tree (α : Type) where
| leaf -- Leaf (empty node)
| node (l : Tree α) (v : α) (r : Tree α) -- Left subtree, value, right subtree

def sampleTree : Tree Nat :=
  Tree.node
    (Tree.node Tree.leaf 1 Tree.leaf)
    2
    (Tree.node Tree.leaf 3 Tree.leaf)

-- Recursive algorithm to get sum of all values
def treeSum : Tree Nat → Nat
| Tree.leaf => 0
| Tree.node l v r => treeSum l + v + treeSum r  -- Assume you have answer for left and right subtree

#eval treeSum sampleTree


/-
Can do this kind of procedure over other container types.
Ex: Option → return real value or none/error as total functions for the object type in lean
-/

-- Precedecessor function
def pred : Nat → Option Nat
| Nat.zero => none
| Nat.succ n => some n

/-
List, tree, and option are not types
- Type of option: **Type → Type**
  - Can be none or some
- When talking about container types, we are talking about Type → Type builders
  - Option is a container for any type of object
  - Type of List: Type → Type
  - Type of Tree: Type → Type
    - Tree Nat: type of Nat Trees
- When we want to generalize over container types, we want an argument of
type function (Type → Type)
- Option is a type constructor/builder
-/

#check (Option)


-- Containers are parameterized by element type
#check (Nat : Type)
#check (List : Type → Type)
#check (Tree : Type → Type)
#check (Option : Type → Type)

-- Don't have a type as data member:
-- Didn't put type parameter in as a field (it is unbundled)
  -- Don't have a value of type "Type" as an option

/-
Further parameterize notion of fold so it works for any container type,
as long as certain rules are followed.

Any function that works on a container of things work on a new kind of
container.
-/

/-
Foldable
- Class that takes any container type
- Runs fold function taking:
  - (α → β → β): Accumulator that takes base value, takes one, then combines it with what's
  already there.
    - Folding each element of list into accumulator (step function)
    - Takes element from container (α) and answer you've accumulated so far (β),
    then returns updated value (β)
  - β: identity (original value you put into function)
  - F α: Generic container of α's
    - Ex: List, Option, Tree
    - Container is polymorphic object that takes objects of different kinds
  - β: Final result
-/
class Foldable (F : Type → Type) where
  foldr {α β : Type} : (α → β → β) → β → F α → β

-- Can now instantiate for any container type

instance : Foldable List where
  foldr := List.foldr

instance : Foldable Option where
  foldr f z
  | none => z
  | some a => f a z


/-
Folding function for trees
- At a leaf, return identity
- At node, return function applied to the right node, then applied to the left

- z : Base case (returned in empty tree)
- Reduce using f (step function), apply to 2 arguments
  - Item you are currently looking at, then merge with accumulator
  - treeFoldr f z r : Apply step function f to z (base case) and r (right node)
    - Gives answer for right side
  - Apply outer f for right-hand side and l (left-hand side)

- If the operator is commutative, then the tree traversal order doesn't matter
  - Have to ask how you want the fold to behave?
    - Want it to not matter
    - Should pass proof that operator is commutative or associative
-/
def treeFoldr {α β : Type} (f : α → β → β) (z : β) : Tree α → β
| Tree.leaf => z
| Tree.node l v r => treeFoldr f (f v (treeFoldr f z r)) l

-- Assign specific function for folding a tree
instance : Foldable Tree where
  foldr := treeFoldr

/-
Takes container type F
- Only if there is an instance of foldable for that F
- xs: Container of α values
- Takes container of values and returns a list of values
  - Could take a tree of alpha values and returns a list
  - Takes an option α and turns it into a List α of length 0 or 1
-/
def toList {F : Type → Type} [Foldable F] {α : Type} (xs : F α) : List α :=
  Foldable.foldr List.cons [] xs


/-
Returns size of container
- Can linearize size of program
-/
def size {F : Type → Type} [Foldable F] {α : Type} (xs : F α) : Nat :=
  Foldable.foldr (fun _ n => n + 1) 0 xs

/-
Fold:
- Takes additional constraint that container is not only foldable, but elements
of the list are a monoid (so they can all be added/multiplied together)

Operator is stored in monoid object
-/
def fold {F : Type → Type} [Foldable F] {α : Type} [Monoid α] (xs : F α) : α :=
  Foldable.foldr Monoid.op Monoid.id xs

-- HW: Read rest of chapter

/-
Lawful map:
- Takes any container, and tells you the correct map function over any
container.

Takes shape coming in, then outputs shape coming out with shape of values.
- Replaces contents of container with transformed contents
- If you apply map to the empty element of a container, you should get
the same thing
  - Appending empty list to same list should return empty list
- Composability Property: take 2 lists of numbers, and you want list of bools
telling if they are even
  - Map conversion over first list, map over second list, then glue together,
  it is the same as mapping over the combined list
-/
