```lean
-- Specifications

-- A specification with no implementations
#check Empty

-- A specification with one implementation
#check Unit

-- A specification with two implementations
#check Bool

-- A specification with an infinity of implementations
#check Nat

-- Infinite number of values, every one of them finite
#check Int

-- Another example
#check String

-- Any function taking any String and returning any Bool
#check String → Bool

-- Implementations

#check Unit.unit

#check Bool.false
#check false

#check Nat.zero
#check 0

#check (0 : Int)

#check "Hello, World!"

def hw : String := "Hello, World!"

#check hw
#reduce hw

#check (fun (_ : String) => true)
#reduce (fun (_ : String) => true) hw
#check (fun _ => true) hw

def str2true : String → Bool := (fun _ => true)

#reduce str2true hw
```


<div class="issue-box">📝 <a href="https://github.com/kevinsullivan/Lean4CS1/issues/new">Report an issue</a> with this section</div>

