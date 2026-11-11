/-
Let G be a 2D Real Vector Space

Rational -> Real
Benefits:
- Generalization
- Performance
- Relations

SQL example (different than normal relational algebra)
7 "..."
8 "..."
7, "..."

- In set theory, an ordinary relation is
just a *set* of tuples
  - With sets, there are *no repeats*
- In database-relational algebra, you can have duplicates/repeats
  - Not the same as normal mathematical relational algebra; talk about "bags" or
  "multisets" of values
  - When you have a set, you can ask booleans about the set (and get back boolean)
  - When you have a multiset, you get back the number of elements in the set
- In SQL, semantics are "bag-based" rather than "set-based"

Sets can be further generalized:
7, "Hi"
7, "Hi"
_______
2 of (7, "Hi")

Adding a coefficient at the beginning of every tuple in database
- If in set semantics, coefficient can be 0 or 1 (T or F)
  - T/F * some tuple T
- In bag/multiset semantics, coefficient can be number of elements matching tuple
  - Integer * some tuple T
- Instead of putting numerical or boolean value as coeff, can put *polynomial* instead
  - Ex: x₁ or x₂ in front of polynomial → feed into operations of algebra
  - Polynomials get added or multiplied together, resulting polynomials are labels
  - Would encode *provenons of data*
    - Ex: Can put security levels, levels of confidentiality -> Would get highest security level
    when accessing tuples
- In database theory, would talk in terms of *k-relational* algebra
  - k is the coefficient you can put in front of every tuple in database
  - What kinds of things qualify to be sources of those coefficients?
  - Some algebraic structure that k-coefficients need to satisfy for everything to work
    - Need a semi-ring
  - Not supported in a lot of commercial databases, but useful
- Can define relational algebra where any data can be from a semi-ring

Structures:
- Monoid
  + Operator (addition) and identity
- Group
  + Inverses
      + Undo multiplications/translations/etc.
      + Solve equations
- Semi-ring
  + Plus (addition) doesn't need to be invertible
  + Times (multiplication) doesn't need to be invertible
- Ring
  + Addition needs to be invertible
  + Second operation (multiplication)
    + Doesn't need to be invertible
  + Distributivity over operators
- Field
  + Invertible multiplication

To get implementations of databases proven correct, need to know this stuff.
- When someone says that we count the elements into a semi-ring, you should not use a
boolean implementation

## Software Verification Formalization:
- Some formal process that greenlights *acceptable vs unacceptable risk*
  - Willing to accept some, not willing to accept some
  - Need to decide what is acceptable and what is not acceptable
- *Hazard Analysis*: Carefully controlled specified social process that determines
what are all the things that produces an unacceptable outcome
  - "Here are all of the things that would be unacceptable"
  - Nuanced in general, but unacceptable vs acceptable is a good way to think about it
- *Assurance case*: For each hazard h, we show h cannot happen (or Pr(h) ≤ k)
  - k is some judgement of it happening
    - Ex: Standard for civilian flight avionic software → prob of software crashing and
    killing people is so low that it will not happen over entire lifespan of fleet
  - Usually is *10^-9 failures/hr*
  - Needs to go to regulator before approved for use
  - Varies between industries
  - Basically says "we have everything covered"
    - There are a lot of different kinds of arguments that go into a real assurance case
    - Ex: hired only qualified engineers, followed specific prescribed processes, done the
    following forms of testing and test coverage analysis, used replicated hardware (other sensors will
    keep plane in the air), etc.
      - Kind of verification we are doing in this class produces evidence that would go into
      a real assurance case
    - Different kinds of verification methods and techniques would go into systems

- "Normal Accidents": Lots of components (technical, social, etc.) that come together to
produce a fault

What we're doing in here (formal verification) is a single component of assurance
cases and hazard analysis.
- Assurance case will argue whether or not we've covered all the hazards

Flight avionics software has to be rigorously engineered before going into the air.
- Automotive software has precious few requirements for self-driving cars before certification
- Regulatory authorities step in when observed with people driving them
  - Will analyze failures and dictate regulatory mediations
- Start thinking at the systems level (hazard level, safety, signoffs, etc.)
-/
