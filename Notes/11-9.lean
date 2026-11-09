class Group (α : Type) where
  op      : α → α → α
  id      : α
  assoc   : ∀ a b c, op (op a b) c = op a (op b c)
  idLeft  : ∀ a, op id a = a
  idRight : ∀ a, op a id = a
  inv     : α → α
  invLeft : ∀ a, op (inv a) a = id
  invRight: ∀ a, op a (inv a) = id

/-
## Affine spaces

- Specified points and vectors as points of rationals, but
really want to think of it as points and vectors
- Should replace underlying implementation with Points and Vectors
with backend as Rats

Rat x Rat is implementation detail
- AIs will constantly make up abstractions
-
-/

-- Structure: "inductive", but with 1 constructor
-- Default constructor name is "mk", but can name explicitly with "::"
structure Vector2 where
  ofPair ::  -- Rational affine to space component; name of constructor
  toPair : Rat × Rat -- Pair of rational numbers
deriving DecidableEq

/-
DecidableEq
- Typeclass
- If you have an algorithm for deciding whether two things are equal or not,
can package in DecidableEq typeclass
- Allows equality computation (T or F)
-/

structure Point2 where
  ofPair ::
  toPair : Rat × Rat
deriving DecidableEq

-- Repr: Typeclass where, if instantiated for type, will know how to print
-- values of that type when printing eval or reduce
instance : Repr Vector2 where reprPrec v _ := "Vector2 " ++ repr v.toPair
instance : Repr Point2 where reprPrec p _ := "Point2 " ++ repr p.toPair

instance : Group (Rat × Rat) where
  op : Rat × Rat → Rat × Rat → Rat × Rat := fun (a, b) (c, d) => (a + c, b + d)
  id : Rat × Rat := (0, 0)
  assoc : ∀ a b c : Rat × Rat, ((a.1 + b.1) + c.1, (a.2 + b.2) + c.2) = (a.1 + (b.1 + c.1), a.2 + (b.2 + c.2)) := fun _ _ _ => by simp  [Rat.add_assoc]
  idLeft : ∀ a : Rat × Rat, (0 + a.1, 0 + a.2) = a := fun _ => by simp -- Need to define add for Rat × Rat to simply use the operator
  idRight : ∀ a : Rat × Rat, (a.1 + 0, a.2 + 0) = a := fun _ => by simp
  inv : Rat × Rat → Rat × Rat := fun (a, b) => (-a, -b)
  invLeft : ∀ a : Rat × Rat, (-a.1 + a.1, -a.2 + a.2) = (0, 0) := fun (a, b) => by ext <;> simp
  invRight : ∀ a : Rat × Rat, (a.1 + (-a.1), a.2 + (-a.2)) + (0, 0) := fun (a, b) => by ext <;> simp


/-
Vector typeclass

congrArg →
-/
instance : Group Vector2 where
  op v w : Vector2 := ⟨Group.op v.toPair w.toPair⟩ --Put in explicit type judgements to see what it's doing
  id : Vector2 := ⟨Group.id⟩
  inv v : Vector2 := ⟨Group.inv v.toPair⟩
  assoc a b c := congrArg Vector2.ofPair (Group.assoc a.toPair b.toPair c.toPair) -- Prove equality for associativity
  -- a is a 2D Vector; .toPair will return underlying Rat × Rat value
  -- Applying a proof of associativity to 3 values
  -- Proof of assoc is generalization; for all a, b, c, something is true
    -- To prove ∀, write a function; you get back a proof for that specific value
  -- When applying universal generalization, you get back a proof that, for 3 pairs of
  -- rational numbers, that is true
    -- Have proof that particular elements add up in associative way
  -- congrArg proves that the two ways of making the parentheses are equivalent
    -- Assumed that a b c are arbitrary vectors
    -- Fields of values are inside {}
    -- Show that group operation of both pairs of parens are equivalent
  -- Use the fact that you can inspect types and values to decode what's being asked
  idLeft a := congrArg Vector2.ofPair (Group.idLeft a.toPair)
  -- ^ Applying a proof to some value a
  -- If you apply the identity function to both values of a, you get an equivalent Vector
  idRight a := congrArg Vector2.ofPair (Group.idRight a.toPair)
  invLeft a := congrArg Vector2.ofPair (Group.invLeft a.toPair)
  invRight a := congrArg Vector2.ofPair (Group.invRight a.toPair)

#check congrArg
/-@@@
congrArg.{u, v}
  {α : Sort u}
  {β : Sort v}
  {a₁ a₂ : α}
  (f : α → β)
  (h : a₁ = a₂) :
  f a₁ = f a₂
@@@

Assuming you have fixed arbitrary types α and β,
if a1 and a2 are equivalent values of type α, and you have
a proof that they are equal to each other, applying f onto
a1 is equal to a2.

If you apply a function to two equal values, the result will be the same.
-/

class AffineSpace (V : Type) (P : Type) where
  [groupV : Group V]
  vadd    : V → P → P
  vsub    : P → P → V
  vaddAssoc : ∀ v w : V, ∀ p : P, vadd v (vadd w p) = vadd (groupV.op v w) p
  vaddZero  : ∀ p : P, vadd groupV.id p = p
  vsubAdd   : ∀ p q : P, vadd (vsub q p) p = q
  addVsub   : ∀ v : V, ∀ p : P, vsub (vadd v p) p = v

/-
Once you have abstractions of point and vector, each with
underlying representation, need to overload operations in order to
have an affine space.

Can take a vector and add to point to get new point
Can get vector by subtracting two points, etc.

inferInstance => command to Lean to do *typeclass inferencing*
- Pull in whole group structure into larger affine space structure
- First instance for AffineSpace typeclass is an instance showing that V has the structure of
a Vector space
  - There is a typeclass instance for V
-ᵥ => Subtract two points, one from the other, gets back to V
-/

instance : AffineSpace Vector2 Point2 where
  groupV := inferInstance
  -- Group of Vector2
    -- Typeclass instance of group Vector2
  -- Vector2's need to have a structure of a group
  -- Needs to be an instance of Group Vector2, which is a typeclass instance that provides information
  -- on Vector2 objects
  vadd v p := ⟨Group.op v.toPair p.toPair⟩
  -- Application of constructor constructor
  -- Extract pair of rationals from vector, pair of rationals from point, then add together
  -- Get pair of rationals that you add together for what you need
  vsub q p := ⟨Group.op q.toPair (Group.inv p.toPair)⟩
  vaddAssoc v w p :=
    congrArg Point2.ofPair (Group.assoc v.toPair w.toPair p.toPair).symm

def triangle_A : Point2 := ⟨(1, 2)⟩
-- 2D point on triangle
-- Parens () => Prod.mk, pair constructor
-- ⟨ ⟩ => Constructor for Point2
-- Create pair of rational numbers, then package as point
def triangle_B : Point2 := ⟨(3, 4)⟩


-- Subtract points from one another
def side_AB : Vector2 := triangle_B -ᵥ triangle_A -- (3, 0)
