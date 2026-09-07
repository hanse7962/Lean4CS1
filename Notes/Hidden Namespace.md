#check Bool

namespace hidden

-- Introduction rules
inductive Bool : Type where
    | false : Bool
    | true : Bool

-- Case analysis (Elimination rule for variant type with > 1 constructor)
def b2s (b : Bool) : String := 
    match b with
        | Bool.true => "It's true"
        | Bool.false => "It's false"

end hidden

#check Nat

//Nat 
namespace hidden
inductive Nat : Type where
    | Zero : Nat
    | Succ (n : Nat) : Nat

//Opens namespace; may introduce conflicts
open hidden.Nat

// Unary Notation
def zero := Nat.Zero
def one := Nat.Succ zero
def two := Nat.Succ (Nat.Succ Nat.Zero)

def funk (n : Nat) : String :=
    match n with
        | Nat.Zero => ""
        | Nat.Succ (n' : Nat) => "!" ++ funk n'
#eval funk two

end hidden
