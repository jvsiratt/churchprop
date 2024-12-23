# churchprop
A short implementation of the propositional proof theory that appeared in Alonzo Church's 1956 *Introduction to Mathematical Logic.*

## Why?
Nine years ago, while I was still an undergradaute, I tried to write a proof checker in Python over my Christmas break. I was still months away from trying out Coq and a year away from teaching myself PVS. I tried to modify it for predicate logic, but I ran out of time during the holiday and reverted it back to propositional calculus.

To sort of commemorate this (and all that's happened since) I thought I'd do something similar this holiday season. This is not a replication of the old project. That was based on a system of natural deduction that we had covered in my first course on formal logic the previous summer. This is something different.

## What?
I chose to use a compact Hilbert-style proof theory with three axioms and modus ponens as the only inference rule. For practical purposes, I included the ability to assume that something is true.

The formula and proofs are defined as structures in Typed Racket, inspired largely by the LCF approach. It should be impossible to construct a formula that is not well-formed or a proof that is invalid -- *if* I didn't screw up. I'm still learning Racket and actively trying new things out, so it's pretty likely I did make some mistakes that I haven't caught.

I also included some functions that make interacting with these kernel objects a bit more palatable. When I was working in Python I spent a lot of effort customizing the way the user would interact with the classes and how everything would appear. One of the things that attracted me to Racket is how easy it is to tailor these interactions, up to making a complete domain specific language if you wanted or needed it.

Finally, I included two examples. The first involves piecing together small proofs into larger proofs. The second defines a higher order inference rule and applies it to a couple of assumptions. Running the example file prints out full derivations of both proofs.

# Next
This was just a fun exercise so I don't expect to do much more on it. I just wanted to do a little project that wasn't related to work and was maybe interesting enough to justify the first real commit to my github in years that wasn't to my private dissertation repository.
