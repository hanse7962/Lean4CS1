/-
Groups

Monoid:
- Carrier set (objects)
- Identity
- Addition (assoc)
- Zero (id laws)
- All of the above follow laws that you expect

Taking intuition for arithmetic and elevating arithmetic up so it
can be applied to any kinds of objects.

Group Adds:
- Inverses/inv (-)
- Inverse laws

Ring
- Multiplication (laws)
  - Can have multiplicative monoid or additive monoid

Field
- Inverses of multiplication (inv *)
  - Except for the 0

In vector space, you have scalar multiplication of vector space by vectors.
- In monoid, have simple version of scalar multiplication.

A lot comes down to geometry.  Affine spaces give you geometry.
- Vectors have direction and length
- Scalar mult changes the length
- Can't take the inverse of a scalar without respective rules
  - If scalars come from a field, can take multiplicative inverses of scalars
  - Can mult any vector from a field to point in right direction and mult by
    right scalar to get to any point in the plane

Vector space:
- Scalar mul * a * v
  - Algebra of the scalars
- Group of vectors
- Scalars coe from field (+, -, *, etc.)

Module:
- Vector space, except scalars can be from ring and not a field
-

Should be able to point to Lean definition: should at least be able to define value
to be a proof of this proposition
- := and other stuff
- Most important skill is ability to read math (read what it's saying mathematically)
-/

/-
Groups chapter review:

- Proof of classification of all finite groups (4 components):
- Lie group: Finite analogs of continuous Lie groups
  - Not Lie group: rotation by any angle, translation by any distance are infinite
- Will write type class to formalize logic
  - Ex: list of all possible types → pick one
    - Suppose there is no function for adding them → just define typeclass
    - If you create instance of typeclass for type, it's like you've attached extra
    metadata to that type
      - Extra metadata carries all mathematical structure for that type
    - Formalize generic structure as typeclass, then instantiate for every type
    that you want to equip for that additional structure/information
  - Different typeclasses can extend type in different ways
  - Can augment types with this additional structure
- Classes carry generic form of any group, ring, etc.; specifies how generic
structure applies to type

Monoid:
- Assoc: Proof field for an object of type; if you do operations one way vs another
way, you get the same result
- Monoid.mk with fields will give instance


Group Int:
- Provide proofs for relevant laws of group
- Name of law : type of proof/law := proof of law
  - := Separates type/law for which you're trying to give proof from its proof
  - Ex: IdRight: proof of ∀ Int, a + 0 = a
    - Proved by Int.add_zero
  - Ex: IdLeft: proof of ∀ Int, 0 + a = a
- inv : Int → Int := fun n => -n
  - -n is notation for inv

Group (Fin 3)
- Fin 3 => finite in natural numbers (0, 1, 2)
  - *Fin n* => Represents natural numbers from 0 to n - 1
  - Addition is defined on values of this Fin type
  - Type of natural numbers <= n
    - Ex: 2 + 1 in Fin 2 is 0 (wraps around)
- Natural numbers in Mod n is a Group
  - Ex: Points in time; distance between two vectors add up
-/

--Group:
--class Group (α : Type) extends Monoid α where
-- inv: Inverts type
-- invLeft:
-- invRight

class Monoid (α : Type) where
  op      : α → α → α
  id      : α
  assoc   : ∀ a b c : α, op (op a b) c = op a (op b c)
  idLeft  : ∀ a : α, op id a = a
  idRight : ∀ a : α, op a id = a


class Group (α : Type) extends Monoid α where
  inv     : α → α
  invLeft : ∀ a : α, op (inv a) a = id
  invRight: ∀ a : α, op a (inv a) = id

/-
With groups, you get the ability to cancel out group actions:
a * x = b
- Need to undo a to find a
- Can invert a on both sides to get "x = inv(a) * b"
- Can now define operations that work on anything that's a group
-/

def solve {α : Type}[g : Group α] (a b : α) : α :=
  g.op (g.inv a) b
/-
Ex: (Inverse of a) + b

- (inverse of a) (operation) b
- Takes any type, as long as there an instance of the Group typeclass for that
type
- a and b must both be of the same type
- Function has 4 arguments (type, group, values)
  - With [], it tells Lean to do type inference to see if there is an
  instance in its database
  - Lean will infer compositions of typeclass instances
    - If you already have typeclass instances to build bigger typeclass, Lean
    will put them together so you don't have to define each explicitly

#eval (1/2 : Rat) + (1/3 : Rat)
- Operation (+) is defined in "op" field in typeclass group instance
- 0 doesn't mean Nat 0, but a Rat 0
  - Lean already knows that it must be a Rat from knowing a is a Rat
  - Notation comes from "Zero" typeclass

Group on Rat 2D Plane
- Members of group:
  - Additive group on Q x Q => 2D rational plane
  - Can think of members of group as Vectors on 2D plane; group of actions
  - Action picks up 2D rational point, and action moves it by some amount
  - Elements of Rat x Rat form a group
    - Need addition, zero, and additive inverses for a group
    - On Rat x Rat, addition means you are adding on ordered pairs
      - Definition is given in "op" field; give group structure over pairs of
      rationals
  - op takes 2 pairs of rational numbers (Prod Rat Rat) and returns a pair of rats
- Pack definitions into typeclass instance and you have all the laws for that
particular group in your carrier set
-/

/-
Torsors: Free and Transitive Group Actions

When you think of vector space, think of it as collection of actions.
- Apply it to something, and it will do something to it.
- Move the hour hand of the clock from one place to another
- What do vectors move on? -> In vector space, act on other vectors.
  - To represent physics and geometry in vector spaces, you are in trouble
  - Can act on vector point with distance vector to move to any point
    - Gives you geometry
    - Use affine spaces instead of vector spaces when implementing a graphics
    library
- In physics space, you have some origin and you represent points as vectors
  - Gives it to you in type algebra in affine space; don't need notion of coordinates
  - Can subtract one vector from another without coordinates
    - Under the hood, each may be represented by pair of rationals, but is irrelevant
    as long as they are relative to each other and laws hold
- What does V act on? → Acts on some underlying torso on things that get acted on
  - Points on clock are torsor, distance between them are vectors
-/

/-
Takes 2 types
- Can define typeclass on any number of types; can associate with 2 types
- G must be a group
  - [groupG : Group G] enforces it; lean looks it up
- T is what group G acts on

Arrows from one point to another in plane; elements/vectors of G
- You have to satisfy vector laws
- Forces torsor to have certain shape
  - Can add vectors to any point to get any other point in torsor
  - If you have cyclic group, those don't take you to every point in
  cartesian plane
  - Group determines what the underlying group's structure has to be
Should be able to separate vector space from torsor of points
- But torsor needs to be compatible with group
- T is a Torsor; torsor of points and a group of actions; force them into consistency
  - Group actions add onto those points
  - Superimpose additional rules to distinguish between points and vectors
-/

class Torsor (G T : Type) where
  [groupG : Group G] -- Group of actions
  act : G → T → T
  -- Group action (pick any vector/vector-like and any point, then can return a point)
  -- Vector + point = point
  actId : ∀ t : T, act groupG.id t = t
  -- If you pick any point in torsor, applying zero vector of it gives the same point
  -- Laws make the 2 pieces of structure work together properly
  actComp : ∀ g h : G, ∀ t : T, act (groupG.op g h) t = act g (act h t)
  -- Associative law; given any 2 actions/groups g h, if you have a point t, can combine actions
  -- together or apply them individually to get the same result
  actFree : ∀ g : G, ∀ t : T, act g t = t → g = groupG.id
  -- For any action and for any point, if you apply the action to the point, and the result is
  -- just t, then the action must be the identity element of the group.
  actTransititve : ∀ t1 t2 : T, ∃ g : G, act g t1 = t2
  -- Applying group action g to any point t1 yields a new point t2; some action in the group
  -- that takes t1 to t2

instance : Group (Fin 12) where
  op      : Fin 12 → Fin 12 → Fin 12 := (· + ·)
  id      : Fin 12 := 0
  assoc   : ∀ a b c : Fin 12, (a + b) + c = a + (b + c) :=
    fun a b c => by ext; simp [Fin.add_def, Nat.add_assoc]
  idLeft  : ∀ a : Fin 12, 0 + a = a := fun a => by ext; simp [Fin.add_def]
  idRight : ∀ a : Fin 12, a + 0 = a := fun a => by ext; simp [Fin.add_def]
  inv     : Fin 12 → Fin 12 := fun a => -a
  invLeft : ∀ a : Fin 12, (-a) + a = 0 :=
    fun a => by ext; simp [Fin.add_def, Fin.neg_def]
  invRight: ∀ a : Fin 12, a + (-a) = 0 :=
    fun a => by ext; simp [Fin.add_def, Fin.neg_def]

-- Example:
-- When dealing with finite groups, can prove with case analysis
-- "by decide" → Lean gets finite number of cases where you need it
instance : Torsor (Fin 12) (Fin 12) where
  groupG := inferInstance
  act := (. + .)
  actId := by decide
  actComp := by decide
  actFree := by decide
  actTransititve := by decide

/-
Laws follow:
- Applying identity doesn't move anything
- Actions compose consistency
- Every point can reach every other point
- No non-identity element fixes any point
  - Not true for cyclic groups
-/

/-
Affine spaces:
- Torsor over a vector space.
- If you have any vector space, it is the set of points that underlies vector space
- Affine space is a torsor over a module, so you can weaken vector space of actions to
a module of actions, where a module is just like a vector space *without scalar inverses*.
  - Modules also can't impose a sensible coordinate system
-/
