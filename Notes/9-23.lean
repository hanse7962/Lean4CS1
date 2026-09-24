/-
Project ideas

(Be sure to do a literature review first,
know where it came from and cite authors properly)

(Come in with some literature by Monday, start to think
about math that you're interested in)

- Formalize physics library in lean (physlib)
- Look at formalization of affine spaces
  - 2D plane sitting at Y=1 in 3 space
  - Another kind of mathematics to push into formal space
- Expressions within programming language
  - Need to know mathematics of domain and mathematics of software
  - Imperative programming (sequence of commands; set up state space (declare class))
    - Set up state-based representation of computation, then execute commands sequentially
    - Each command updates the state, eval boolean over state, branch states, etc.
    - Commands compose (1 command with 2 sub-commands); recursively build up commands
    - Start running in certain state (variables run in certain state)
    - If you view whole program with 1 big specification, and satisfy precondition, then
      you want to prove output state satisfies post-condition
    - To prove correct, reason step-by-step through state transformations to
      show that output state is correct
        - Ex: Benjamin Pierce's software foundation series (foundation of fundamental programs)
- Formalizing network protocols (worst-case delay time)
- Fault tolerance
- Proving sorting algorithms
  - Jane street (built on OCamel) decided to use formal verification
- Proving a system to be faithful to theory :
-/


/-
### DeMorgan's Laws:

∀ (P Q : var), ∀ (i : Interp),

¬ (P ∧ Q) → ¬ P ∨ ¬ Q
¬ P ∨ ¬ Q → ¬ (P ∧ Q)

Want a proof of a for-all proposition ( ∀ (P Q : var) ) first
- Assume you have values for types that you are quantifying

For all intro rule: assume you have vars of given types
- "fun P Q =>" - ∀ intro
-   "fun i =>" - ∀ intro
-     "fun h" -- h = Hypothesis; if you have a proof of the left side, so show the right side
              -- → intro
        -- show ¬P ∨ ¬Q  -- Use case analysis (2 cases for P, 2 for Q)
Assume anticedent is true
- Assume premise, so can derive proof from conclusion

-- ¬ (P ∧ Q) will return a proof of false, so P and Q can't be true
  - Ruled out by hypothesis
  - When you see proof of negation in lean, need to understand that h is a function


-/

/-
fun P Q => _
  fun i => _
    fun h => _
      case P is true
        case Q is true =>
        /-
          h: ¬ (P ∧ Q)
          Notation for not (P ∧ Q)
          (P ∧ Q) → False

          hP : P
          hq : Q

          If you can prove that, from assumptions you've made that
          false = true, then assumption is false

          Case is impossible for P=true and Q=true,
          so can rule out case

          Have to show a contradiction

          Make an input variable out of hP and hQ,
          use And.intro hP hQ

          cases
            → h (And.intro hP hQ)
               - Yields False; derives term that proves false
               - Use nomatch to prove negation (false elimination)
                 - No cases to evaluate
        -/
        And.intro P Q

        case Q is false
      case P is false
        case Q is true
        case Q is false
-/

namespace PropLogic

/- Not just literal true/false, but also has variables
- If x is Prop, and y is Prop, then x AND y is Prop
-/
inductive Variable where
| Xvar
| Yvar
| Zvar

/-
Variable expression in propositional logic
- Not true or false (yet), since we haven't bound value to variable

Is proposition satisfiable? (is there a binding of boolean value that makes it true?)
- Yes, just make it mean Boolean true

If you have an expression X and ¬X, that is not satisfiable
- (no expression that makes X and ¬X true)
- Need to assign values to boolean expressions
-/

/-
How to associate var with corresponding boolean?
- Define a new Var eval (usually called an interpretation)
- Function from Var → Bool
-/

open Variable

def varInterp : Type := Variable → Bool

-- How many such functions exist for this example?
-- 8; 8 possible combinations of X, Y, and Z
def i1 : varInterp :=
  fun (v : Variable) =>
    match v with
      | Xvar => true
      | Yvar => true
      | Zvar => true

def i2 : varInterp :=
  fun (v : Variable) =>
    match v with
      | Xvar => false
      | Yvar => true
      | Zvar => true

-- Propositional/Prop logic in Lean:
inductive PropLogic where
| T
| F
| And (p1 p2 : PropLogic) : PropLogic -- Gives term of the same type
| Or (p1 p2 : PropLogic) : PropLogic
| Not (p1 : PropLogic) : PropLogic
-- | implies (p1 p2 : PropLogic) : PropLogic
| Var (v : Variable) : PropLogic -- Term of type PropLogic

-- Deep embedding of language into lean
open PropLogic

-- When you have variant type, always need to do case analysis

def X := Var Xvar
def Y := Var Yvar
def Z := Var Zvar

def eval : PropLogic → varInterp → Bool
  | T, _ => true
  | F, _ => false
  | (PropLogic.And p1 p2), i => (eval p1 i) && (eval p2 i)
  | (PropLogic.Or p1 p2), i => (eval p1 i) || (eval p2 i) -- Maps to Boolean OR function
  | (PropLogic.Not p1), i => !(eval p1 i)
  -- Unless we have interpretation function to return value, can't return value
  -- Need to pass interpretation as an argument
  | PropLogic.Var v, i => i v -- Name of function (i), name of value (v)
  --| _ => false -- Defaults *all undefined terms* to false; can use *any name that's not defined*
-- When lean does case analysis, checks cases from top to bottom in order
-- If variable is previously undefined, can be used to match anything.

scoped notation:max "⊤" => PropLogic.T
scoped notation:min "⊥" => PropLogic.F
scoped infixr:35 "∧" => PropLogic.And
scoped infixr:30 " ∨ " => PropLogic.Or


/-
theorem DM1 : ∀ (P Q : Prop), ¬(P ∧ Q) → ¬P ∨ ¬Q :=
-- Introduce assumptions
  fun P Q =>
    fun h => -- Assume we have a proof of ¬(P ∧ Q), function of "P and Q → False" in the form of a function
      -- Top level connective is ∨ (disjunction), use case analysis to prove an or
      -- Can you derive a proof that P is false?
        -- Can't prove either, so we're stuck here
      Or.inl _ =>
      /-
      match P with
      | true => match Q with
        | true => nomatch false
        | false =>
      -/
-/

theorem DM2 : ∀ (P Q : Prop), ¬P ∨ ¬Q → ¬(P ∧ Q) :=
  fun P Q =>
    fun h => -- Top level connective is a not/negation; assume that something is true, which leads to contradiction
      fun pandq =>
      -- And.elimRight -> Proof of Q out
      -- And.elimLeft -> Proof of P out
      -- From Proof of P and Q, can get a proof of P and a proof of Q
        let p : P := And.left pandq
        let q := pandq.right

        -- Case analysis: either a proof of p or proof or q
        match h with
        | Or.inl np => np p
        | Or.inr nq => nq q
