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
{
  Nat.zero,
  Bool.false
}


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
-/
