--Introduction rules
def m : Nat := Nat.zero
def n : Nat := Nat.succ m

def b : Bool := false
def c : Bool := true

def nb : Nat × Bool := -- \times → ×
Prod.mk n b

-- {} => Prod.mk
-- Derivation of Nat x Bool starts with Nat.mk
-- Nat.intro_zero -> Introduction rule
-- Bool introduction rule -> false
def nb' : Nat × Bool :=
(
  Nat.zero,
  Bool.false
)


-- Function introduction
-- (Arrow introduction)
def NB2Nat : (Nat × Bool) → Nat :=
fun (p : Nat × Bool) =>
Prod.fst p -- Prod.fst (first) -> Reaches into pair, grabs first pair, then returns

-- struct: Special inductive case when you have just one structure
-- Ex: when you define class, list fields, and fields get names
--- Can grab data members by using index/field; if you are dealing with record types,
--- one structure containing multiple arguments, it is familiar

-- Prod:
--- Polymorphic with 2 type arguments, 1 constructor mk,
--- give data members names and types; 1 way to make a pair,
--- (first : a) (second : b)
--- Lean defines functions that project out pair; not just field names,
--- but Lean makes them functions
--- Elimination rule (1 constructor, 2 fields)



#check Prod

---spec
def NB2Nat' : (Nat × Bool) → Nat :=
-- impl
  fun (p : Nat × Bool) =>
    p.fst -- equivalent to p.one; Prod elim_1

#eval NB2Nat nb
#eval NB2Nat' nb

-- Uses derivation and prod elimination to return second field

/- @@@
Boolean AND is commutative → If you flip the order
of the equation, it is still the same

Ex: a && b is true, → b && a is true

Prod (×) is commutative

a × B → B × a

Works for all commutative operations (can verify with identity function)

If you get Nat, Bool pair, and you want Bool, Nat pair:
Need a function that turns a, B value and turns it into B, a
value

Derivation: Arrow introduction (function)
- Assume that you are given a pair a, B
- In body of code, extract a and b (prod elimination twice)
- Prod introduction twice to build new pair

- Proof of function type → there is a function
-/

def NB2Bool : (Nat × Bool) → Bool :=
fun p =>
p.2

/- @@@

Type product (x, times) is commutative
-- If you have any types (a, B), then there is a function (swap)
-- that converts (a, B) into corresponding pair (B, a)

How should swap behave (good way of testing swap function)?
- Testing doesn't show you that it's true in all cases
- Apply swap to itself, see if it equals the original
-- Implementation is wrong if you apply it to swapped result
    and don't get back itself
- Formalizes property that we want swap implementation to have
- If you can prove propositions, then you're sure the code is good

Essential correctness condition:
- For any pair (a, B), swap(swap(a, B)) = (a, b)
- Want it to be true for all types (a, B) and for all values of those types
-- Swap applied twice is the identity function
- Boolean operator with that function: Not (¬)

Take a = Nat, B = Bool
- For two types, if you pick any pair (Nat, Bool), then swap it twice,
you will get back to where you started.
- Total function of type (Nat × Bool) → (Bool × Nat)

-/

-- specification
def swap_nat_bool : (Nat × Bool) → (Bool × Nat)
-- implementation
-- "for all" comes from assumptions that function types in lean are total
-- (Can return output type regardless of value)
:= fun nb => -- Introduction
let n := nb.1 -- × elimination left/1
let b := nb.2 -- × elimination right/2
(b, n)  -- Return value/result

-- "let" -> Binds name to value for use in current context
-- (think variable assignment)

-- Value of type coming in: Single object of (Nat × Bool)
def swap_nat_bool' : (Nat × Bool) → (Bool × Nat)
:= fun (n, b) => (b, n) -- Integral object of Nat × Bool coming in
                        -- *Destructuring* record (open it up, define names, see objects inside)

#eval swap_nat_bool(3, b) = (b, 3)

/- @@@
If you try to put it back in, it will not work,
since the types are now swapped.

In other words, you have overspecialized.  You want completely
polymorphic function by generalizing from *specific* types to *any* type.

-/

-- Specification
def swap'' :
∀ -- For all/every; in this case, comes from same type universe
  (α : Type u) -- for any type a
  (β : Type v), -- for any type b; different universe var here to signify they
                -- they can come from same (or different) type universes
  α × β → β × α -- Higher order predicate logic
-- Implementation; defining swap such that if you have type, type, and pair, you get another pair
:= fun α β (a, b) => (b, a)
-- Warning signals: don't need to use objects to define the return value
--- Will be silenced if you put underscores (_) before var names
--- Can also make variables completely anonymous

-- Derivation:
-- Function introduction
-- Elimination
-- Destructing
-- Introduction/structuring

  /-
   First order: For all x in some set S, some assertion is true
   - Can only quantify over sets

   Higher order: Quantify over all types
  -/

-- Close type definitions in curly braces
def swap' :
∀
{α : Type u} -- Can make arguments implicit with curly braces
{β : Type v},
α × β → β × α
-- Omit explicit α and β arguments, they're inferred
-- Lean knows types since pair is of type α × β
:= fun (a, b) => (b, a)

#eval swap'' Nat Bool (0, false)
#eval swap' (0, false) -- don't need to include implicit types here

-- Declare α and β together, bind both early, α implicit
-- If two args are the same type, can declare them in the same construct
def swap {α β : Type u} : α × β → β × α := fun (a, b) => (b, a)


--- "For all" == "∀" == "assume"
--- Moving arguments before colon binds arguments; last throughout rest of
--- definition
-- If you move args to left of colon, names get bound for rest of construct
-- Lose pattern matching if you move them to right of colon
def swap''' {α : Type u}{β : Type v} : α × β → β × α := fun (a, b) => (b, a)

#eval swap (0, false) -- Alpha must be Nat, Beta must be Bool
#eval swap ("No", "Way")

-- works but Lean can't print function values
--#eval swap(@swap Nat Bool, @swap' Bool Nat)
-- Repr -> Prints values of given type on the screen

/-@@@
Correctness condition

Want to show that × is commutative

For all types α, β, for all a α and b β, swap(swap(a, b)) = (a, b)
-/

-- def swap''' {α : Type u}{β : Type v} : α × β → β × α := fun (a, b) => (b, a)
-- fun (a, b) => (b, a) with x for a and y for b
-- (y, x)

-- Proof that "times" is commutative
-- Same function applied twice gets back same identity function

def swap_comm {α β : Type u} (a : α) (b : β) :
swap (swap (x, y)) = (x, y) := -- swap(swap(a, b)) is a type, but if we can prove it, then it is a type
-- Two identical terms of left and right hand side after reduction
-- If you have two terms equal on left and right-hand side, they are equal
rfl -- Forces evaluation of first swap app, then second swap app, then check assertion
    -- rfl is short for Eq.refl (x, y) : takes 1 arg, returns whether arg equals itself
    -- rfl forces Lean kernel to reduce both sides to lowest common denom.
    -- (reduction to normal form)

-- Want procedures that take expression in random order, then return in normal form

/-
Try to simplify left-hand side
-By definition of swap, left hand side evaluates to (b, a)
- To evaluation function to value of function, grab body of function,
  then apply function swap

Eval function in functional programming language:
- Substitute x for a and y for b, then apply substitution
- Simplify left-hand side by applying functions to arguments
- Substitute the actual parameters for the formal parameters in body of implementation
- Reduce the above

Equality is polymorphic type (polymorphic in two values of the same type)
- Can only ask if two vals of same type are equal
- Polymorphic in one argument (type of arguments), then takes 2 vals
- Can prove that α == β that, if they are of the same type, reduce
  each side (simplify, apply functions you can), then see if you have
  exact same term on both sides

Polymorphic equality type in lean

*inductive*: defining a type

-/


/-
-- Can apply eq by applying α to two values of the same type α
-- Get a proposition (Prop; lowest type universe)
-- Takes type and two args, then gives prop that asserts they are equals
/

  inductive Eq : α → α → Prop where
    | refl (a : α) : Eq a a
-/

-- Example: Eq 3 4 yields a proposition
-- Is there an introduction rule to construct a proof of that?
-- 1 constructor for Eq type, so can only prove if you use Eq for 1 value
-- of type α
-- Get back proof that it equals itself; can't get a proof of 3 = 4; since you
-- can't sneak two args into Eq constructor
#check Eq 3 4 --Can never be proved

/-
When we write down "=", it is the same as
"Eq(swap (swap (x, y))) (x, y)" or "arg1 = arg2"
-/

/-
Would be good to rewrite in terms of identity function

swap ∘ swap = id
^ swap proves identity function
-/


-- Logic example:
-- Bind name to value (proof that 7 > 0 and 7 ≤ 10)
-- ^ == ×, except it's on logical side
-- Val is theorem of proofs

-- From proof of (a, b), you can get a proof of (b, a), as they are commutative
-- Polymorphic type using And.intro
-- Requires pair of proofs

-- Prod.mk is functionally similar to And.intro
def andExample : (7 > 0) ^ (7 ≤ 10) :=
And.intro
(by decide) -- If there is a decision procedure in Lean's library, finds it
(by decide) -- Same as above, but a separate procedure

-- Proof of P implies Q is a function that, if given proof of P, returns proof of Q
-- If P is true, since proof of it, then Q is true (since proof of it)

-- AND operator is commutative
theorem impEx2 {P Q : Prop} : P ∧ Q → Q ∧ P :=
fun ⟨ p, q ⟩ => ⟨ q, p ⟩


/- Is OR commutative?

If you have a proof of P OR Q, can you create proof of Q OR P?
- Yes: Case analysis (two cases)

-/
