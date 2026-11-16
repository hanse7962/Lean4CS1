/-
Software Development transition
How to implement → specification
    implementation     theorem
    proofs                  - Includes specification and proof of theorem

theorems:

theorem name : parameters :=
  proof object

Curry-Howard:
- Proofs are programs, proofs are implementations
- Proposition/statement of the theorem that is the specification
  - Whatever you write as a theorem statement
- Coding assistants are good at generating proofs

"Spec-driven development"
- Structured English specifications -> too vague
- *Formal specifications* -> where the world is going

Quaternion:
- 3D rotation representation in 3D space
- Vector matrix rotation
- Mathlib
- To formalize and use them as representation as rotations, then have them act upon objects

Formal Specification using Language of Proof Assistant:
- "Know specification because you learned Lean" → No
  - Need to talk about specification on *what kind of thing you are specifying*
    - May need to use vastly different mathematical theories
- Real strength is that you can embed into Lean the *abstract mathematics* of your domain,
  then verify programs against it
  - Specify the systems that you want into it

Database Relational Algebra:
- Embed into Lean the set theory you need
- For databases, they are bag semantic rather than set semantic
  - Ask how many records you have in database
- Whole theory of abstract database relational algebra which are parameterized by
semi-rings; coefficient is placed in front of records
  - If you look down elements in table, and you check if 9 is in the table, if you've
  parameterized database over boolean semi-ring, you get 1 if at least one element is in
  the semi-ring
  - If you parameterize over natural numbers as semi-ring, when you go down table,
  you get the number of matching elements in the table
    - In general, there is no additive inverse in semi-ring
- To be fluent in relational databases, helpful if you understand mathematical abstractions
  - You need to know some mathematics going forward
  - If you have enough strength in this area to not be scared off, you will be much better off
- A lot of abstract algebraic concepts crop up in a lot of places
  - Semi ring Example
    - Abstract theory (parameterized by character α)
    - Semi ring α gives add, subtract, mul, etc. for that theory α
    - Props up i:
      - Database algebra
      -
    - Exact same 3 types of semi-rings prop up when doing fold on a graph

Fold (right):

foldr (. + .) if List α

Ex: [1, 2, 3, 4] 0
  - 0 is accumulator (add everything into)
  - Recurse list backwards, then add everything into same value

- Fold is hugely general
  - Collection of objects and reduce down to one value
- Can abstract within type of elements within container, but can generalize over
different containers
  - Trees, lists, options, etc.
  - As long as the laws are there to make Fold hold

graph Fold
- Slightly different algorithm from what we've implemented
- If you have a graph of nodes with weighted edges, a single fold algorithm:
  -...parameterized by boolean semi-ring, gives you shortest path
  -...parameterized by nat semi-ring, gives you number of shortest paths
  -...parameterized by polynomial semi-ring, gives spectrum of how many of each length
  of each path exists in this network
    - Good for measuring reliability and resistance to failure
- Tropical semi-ring (min-plus algebra)
  - Objects are curves of a circle → show how much traffic is going through nodes
  in a network, and how many backups there are and what the delays are
  - Good for:
    - Airbus: safety-critical networks
    - Path lengths in an ordinary graph traversal algorithm
    - Provenons Polynomials
- Process
  - Start at particular vertex
  - b(v) → Accumulator/initial value
  - Sum over all edges in graph through algebra
  - F(v) → value computed at v
  - u → v: values over all edges
  - F(u): recursion over the rest of the graph
  - Inner plus over all edges aggregates contribution of all incoming edges
  - Outer plus combines answer with initial value (folding into accumulator to get answer)
  - etc.

- Choice of semi-ring determines how you count when you do the fold
  - Need to learn abstract mathematical languages of field you are working in
  - Specified in abstract mathematics embedded in Lean

Ensure that the specifications are correct before creating the implementation.
Just because lean says that all specifications are proven doesn't mean that you
got the system correct.

Verification: "Did I build the program right?"
- Applies to an implementation, check whether it satisfies the specifications
Validation: "Did I build the right thing?"
- Are the specifications correct?
- This is what went wrong with the GraphFold code; autoformalization of formal specification
left out the specifications

The biggest problem now is validation, not verification.
- You can vibe-code a huge amount of code, but if there is a mistake in any of
the statements in the code, the implementation fails.
- If you are not exceedingly cautious, you will deploy an invalid program to user base

Review:
- Embedded a bunch of mathematics into Lean
- Propositional Logic and Syntax (Deep Embedding)
- Predicate Logic (Shallow Embedding)
  - Higher order predicate logic in dependently-typed language
  - Gave enormous expressive power
  - Can bring own interpretation into Lean
- Abstract Algebra (monoid, groups, fields, rings, semi-rings, etc.)
- Formalisms of domain (and verification of formalisms)

Theory of sets and relations
- Operations from set theory: union, split
  - Predicate that is true if you have set A and set B that defines the union of
  those two sets → X is in A OR X is in B
    - Build set theory on top of predicate logic; layer on which you build abstraction of
    set theory
- If you have set S and set T:
  S ∪ T - Union
  S ∩ T - Intersection
  S \ T - Difference
  P(S) - Power Set
  x ∈ S - (X in S, X member of S)
  S ⨯ T - Cartesian Product
  S = T - Set Equality
  Sᶜ - Set compliment
    - Ex: set of all even numbers → Compliment is set of all odd numbers

Build operations on sets using what you've learned about predicate logic:
- Union: x ∈ S ∪ T iff x ∈ S ∨ x ∈ T
- Intersect: x ∈ S ∩ T iff x ∈ S ∧ x ∈ T
  - Proof of X ∈ S and proof of X ∈ T, which can be joined together into proof of intersection
- Compliment: x ∈ Sᶜ iff x ¬∈ S
- Difference: Take away anything in first set that is not in second set
  -{1, 2, 3, 4} \ {3, 4, 5, 6}
  → {1, 2}
  - X ∈ S \ T iff x ∈ S ∧ (x ¬∈ T)
- Power Set: Set of all subsets of S
  - S := {1, 2, 3} → P(S) := {∅, {1}, {2}, {3}, {1, 2}, {2, 3}, {1, 3}, {1, 2, 3}}
- Subset: S ⊆ T: For all X ∈ S, X ∈ T
- Proper Subset: S (prop subset) T, (∀x ∈ S, x ∈ T) ∧ (∃y ∈ T, y ∉ S)

- Represent a set as a predicate
  - If you have a set of all dogs, you have a predicate that dogs are friendly
  - Set of dogs that satisfy predicate is a set
  - Since you've defined set as predicate, all of logic just works


Strategy for proving propositions is to rewrite claims in propositional logic, then put together
proofs in propositional logic.
-/
