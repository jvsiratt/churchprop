#lang typed/racket

(require "formula.rkt")

(provide (rename-out [proof-object Proof])
         (rename-out [proof-object-conclusion proof-conclusion])
         (struct-out assumption)
         (struct-out axiom1)
         (struct-out axiom2)
         (struct-out axiom3)
         (struct-out modus-ponens))

(struct proof-object
  ([conclusion : Formula])
  #:transparent
  #:constructor-name avoid)

(struct assumption proof-object ()
  #:transparent)

(struct axiom1 proof-object ()
  #:transparent
  #:guard
  (λ (concl name)
    (match concl
      [(implication P (implication Q P)) concl]
      [_ (error "Scheme for Axiom 1 is P->(Q->P).")])))

(struct axiom2 proof-object ()
  #:transparent
  #:guard
  (λ (concl name)
    (match concl
      [(implication (implication S (implication P Q))
                    (implication (implication S P)
                                 (implication S Q)))
       concl]
      [_ (error "Scheme for Axiom 2 is (S->(P->Q))->((S->P)->(S->Q)).")])))

(struct axiom3 proof-object ()
  #:transparent
  #:guard
  (λ (concl name)
    (match concl
      [(implication (implication (implication P (falsehood))
                                 (falsehood))
                    P)
       concl]
      [_ (error "Scheme for Axiom 3 is ((P->falsehood)->falsehood)->P.")])))

(struct modus-ponens proof-object
  ([implication : proof-object]
   [evidencse : proof-object])
  #:transparent
  #:guard
  (λ (concl impl evid name)
    (let ([consequent concl]
          [antecedent (proof-object-conclusion evid)]
          [material (proof-object-conclusion impl)])
      (cond [(equal? material (implication antecedent consequent))
             (values concl impl evid)]
            [else (error "Invalid application of Modus Ponens.")]))))