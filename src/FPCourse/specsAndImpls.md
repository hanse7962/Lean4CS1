```lean
import Mathlib.Data.Real.Basic
```


# Introduction

Note: A preliminary note: The types and values we use in this file
without defining them here are defined in implicitly imported Lean
4 library files.

## Specification ≡ Proposition ≡ Type
```lean
#check Empty         -- a type with no values
```

Specification  : Absurd
Types          : Empty, False
## Implementation ≡ Proof ≡ Value

Values         : There are no values of this type
Implementations: There's no way to implement this specification
Proof          : There's no proof of this proposition (so it's false)
```lean
#check Unit
#check Unit.unit

#check Bool          -- the type of binary truth values
#check Bool.true     -- the Bool value representing logical truth
#check Bool.false    -- the Bool value representing logical falsity

#check Nat
#check ℕ
#check (0 : Nat)
#check (1 : ℕ)
#check 2

#check Int
#check Rat
#check Real
#check String
#check List

-- Implementations (Data)

-- some specifications have no implementations at all
-- def e : Empty := _



/--
error: don't know how to synthesize placeholder
context:
⊢ Empty
-/
#guard_msgs in
def e : Empty := _
-- Additional details are at the end of this lesson

-- The definition above cannot succeed, so Lean fills `e`'s body with `sorry`.
-- Both messages are pinned below: the *type* still elaborates, but there is no value
-- behind it.  This is the point of the example, so the output is checked, not leaked.
/-- info: e : Empty -/
#guard_msgs in
#check e

/-- info: sorry -/
#guard_msgs in
#reduce e

def u : Unit := PUnit.unit
def u' : Unit := ()
#check u'
#reduce u'

def b0 : Bool := true
def b1 : Bool := false

def n0 : Nat := 0
def n1 : Nat := 1
-- each value is finite, but they do go on forever

def i : Int := 0

def q : Rat := 0

def r : Real := 0.0

def s : String := ""

/--
error: type expected, got
  (List : Type ?u.2 → Type ?u.2)
-/
#guard_msgs in
def l : List := _

-- Specifications (Total Functions)
-- Let's talk about functions
  -- domain of definition (for us, a type)
  -- codomain (for us, a type)
  -- collection of pairs (i, o) where i ∈ d.o.d. and o ∈ codomain
  -- domain (set of values in d.o.d. for which there are corresponding values in codomain)
  -- range (set of values in codomain for which there are corresponding values in d.o.d.)
-- A function is total if its domain is equal to its domain of definition

#check Empty → Empty
#check Empty → Bool
#check Bool → Empty
#check Bool → Bool
#check Bool → String
#check String → Bool
#check Empty → Bool
#check String → String

-- Implementations (Total Functions)

def e2e : Empty → Empty := fun (e : Empty) => e
```

## If You Assume the Impossible then Anything Goes

An amazing fact.*Anything* is *true of every values* of any
empty (*uninhabited*) type. So, for example, is every pink
elepant an Elvis fan? Yes! And is every pink elephant also
not an Elvis fan? Yes! Each of these statements is true of
every single pink elephant. Of course there are none, so it's
easy for anything to be, and everything actually is, true
of every value of any empty type!
```lean
abbrev PinkElephant := Empty

theorem everyPinkElephantNice :
   ∀  (pe : PinkElephant)              -- assumption
      (nice : PinkElephant → Bool),    -- assumption
    nice pe == true :=                 -- claim
      fun pe _ => nomatch pe           -- proof of ∀ claim

theorem inEmptyAnythingGoes : ∀ (e : Empty), ∀ (P : Empty → Bool), P e == true :=
   fun e => nomatch e
```

There is a special kind of type call Prop. We conventionally
define mathematical specifications as *Prop* types whereas we
define data and function types as inhabiting the type universe,
*Type*. What distinguishes *Prop* most crucially is that all
values of any propositional type are considered to be equal.
After all, these values are intended to be interpreted as proofs
of mathematical statements, the latter expressed as new type
definitions, and for purposes of certifying the *validity* of a
given proposition, any proof will do. The *Prop* type universe
automates the notion that any proof will do, the principle of
so-called *proof irrelevance*.
```lean
theorem ifFalseAnythingGoes :
   ∀  (e : False)
      (p : False → Prop),
   p e :=
      fun e => nomatch e
```

Read this as follows. We show for any proof, *f*, of *False*, and any
predicate
## Additional Details

Some code below is *meant* to fail. We keep it because the failure is the
lesson, but a failing file breaks `lake build` and CI. `#guard_msgs` resolves
this: it runs the command that follows, compares the messages that command
emits against the `/-- ... -/` block immediately above it, and then consumes
them. If they match, the build succeeds and the error never escapes. If they
stop matching -- say a future Lean version reworks the message -- the guard
itself fails, so this stays honest rather than silently rotting.

To determine the precise text to guard upon:

1. Provoke the message. Build the file (`lake build FPCourse.specsAndImpls`),
   or put the cursor on the offending line in VS Code and read the InfoView.
2. Copy the message *verbatim*, but drop the `FPCourse/....lean:LINE:COL: `
   location prefix -- guard blocks carry no file positions.
3. Paste it into a `/-- ... -/` block directly above the command, prefixed by
   its severity: `error: `, `warning: `, or `info: `. Only the first line takes
   the prefix; continuation lines (`context:`, `⊢ ...`) are pasted as-is.
4. Preserve leading whitespace on continuation lines exactly. Lean compares the
   text after normalising trailing whitespace, so indentation inside the
   message is significant.
5. Write `#guard_msgs in` on the line between the block and the command.

Shortcut: write an empty `/-- -/` block, add `#guard_msgs in`, and build. The
mismatch report prints the actual message, which you can paste straight in.

A command may emit several messages; the block must list all of them, in order.
Use `#guard_msgs (error) in` to check only errors and ignore `info`/`warning`
output -- useful next to `#check` and `#reduce`, which are chatty.

One caution: messages containing metavariables, such as the `?u.2` universe in
the `List` guard below, embed numbers Lean assigns during elaboration. Those can
shift when surrounding code changes, and the guard will need updating.

<div class="issue-box">📝 <a href="https://github.com/kevinsullivan/Lean4CS1/issues/new">Report an issue</a> with this section</div>

