--- #check fun Nat x String

--- Function that assumes it is given some value of type Empty
--- that needs to return it; can never call it, since there is no argument
--- to ever apply it to.
def id_Empty : Empty → Empty := fun n=>n

--- Takes arg n of type Bool, then returns n
def id_Bool : Bool → Bool := fun n => n

def id_ListNat : List Nat → List Nat := fun n => n

--- Tick mark prevents conflict with built-in function

--- Generic function to identify function once and make it
--- parametrically polymorphic

--- Takes 1 arg α of type Sort u, returns itself
def id' (α : Sort u) : α → α := fun n => n

--- Pass type and value, returns value with equivalent type
--- α is parameter that's already given
--- id function returns the function mapped into n
#eval id' Nat 3
#eval id' Bool true
#eval id' (List Nat) [1, 2, 3]

--- Arrow is right associative, takes a Nat, then returns a function Nat → Nat
--- Takes function of Nat → Nat, then returns a Nat → Nat → Nat
#check Nat.add

--- Operation has consumed one of its arguments
--- Function that's returned takes any Nat, then adds 3 to
--- it to return final result
#check Nat.add 3


def myAdd := Nat.add
#eval myAdd 3 4
--- Returns rightmost Nat
#check myAdd

--- 3 of first argument is baked into argument
def add3 := Nat.add 3
#eval add3 7

--- Consumed both arguments 3 4
def sum := Nat.add 3 4
#check sum

--- Function Application Example (3 arguments, then returns final result)
def f' (b1 b2 b3 : Bool) : Bool := true

--- Are these expressions the same? No
--- Gets function that takes 2 more arguments
#check (f' true)

--- Gets function that consumed 2 bool args, takes 1 more
#check (f' true) false
#check (f' true) false true

#eval ((f' true) false) true


def g' : Nat → Nat → Nat → Nat := fun a b c => a + b + c
#check g' 0
#check (g' 0) 1
#check ((g' 0) 1) 2
#eval ((g' 0) 1) 2

--- Right associative version, but makes no sense and not syntactically correct
--- to put arguments afterwards
--- #check (f' 0 (1 2))

--- Arrow is right associative; funcs are left associative

--- Parametric Polymorphic Function
--- Apply function, then type, then value
---
--- Lean knows the types of the 2nd arguments.  However, although Lean already knows the types
--- of the 2nd arguments, it needs the Sort type to fill in the value of the first argument.
--- Whatever argument type the second argument is gets filled in as the value of first

--- Type of 2nd argument depends on the type of the first argument
--- Downstream arguments can have types that depend on upstream values
#eval id' Nat 3

--- Lean does type inference: don't need to give types explicitly
--- Can use "_" to specify type instead
#eval id' _ 3

--- Lean gives way to not have to write underscores:
--- Instead of putting type arg in paren, put in curly braces
--- -> Don't make you write argument at all
--- Lean should figure out value transparently
def id'' {α : Sort u} : α → α := fun n => n

--- Don't need to specify type, yet still strongly typed
--- Same as having function with 2 arguments (type, val of type), then returns
--- value
#eval id'' 3
#eval id'' true
#eval id'' [1, 2, 3]

--- If lean cannot infer type, need to give explicitly

--- Cannot provide explicit type for implicit typed func
--#eval id'' Nat 3 → Returns error

--- Somtimes, need to give explicitly by turning off implicit arguments with @
#eval @id'' Nat 3

--- Takes type level implicitly, then takes type of identity function and returns value
#check id''

--- Leaves out type parameter, so substitutes with meta variable ?m (i.e. some type to some type)
--- Will eventually be bound to Nat, Bool, etc.
#check (id'')

--- Checks implicit types explicitly
#check @id''

--- Arrow function for type notation
#check (@id'')


--- Parametricity

--- If you are writing a function that can take any type whatsover,
--- making it polymorphic, and you get a value of a given type, you can't
--- do anything with it, since you don't know anything about any type.

--- You can only treat them as opaque objects (never try to branch), allowing you
--- to write code just once.  It can only pass it around, since then, you
--- would have to write code for every possible type.

--- If you want to write a polymorphic function, it cannot look into argument values
--- at all.

--- Ex: list of anything, computes length: can write list of polymorphic length objects

--- Single template of parameter for which you can provide any type, but can't write
--- anything that depends on type of object.

--- As soon as you do anything that depends on type of specific type, you need to
--- do ad-hoc polymorphism instead.  Otherwise, must not and cannot do anything.

def id''' {a : Sort u} (a : α) : α := a

--- Ex: polymorphic addition for numbers or matrices
--- To write polymorphically, function takes type as long as there is an implementation of plus
--- for that type (ad-hoc polymorphism)

--- To work, someone needed to provide implementation of ImplementsPlus for type that's coming in
--- If you set to Nat, and you set implementation for ImplementsPlus Nat, check if you
--- have implementation for Nat.  If no one has defined ImplementsPlus for a type, returns
--- and error saying you don't have implementation for that type.
def add''' {α : Sort u} [ImplementsPlus α] (a : α) : α := a
