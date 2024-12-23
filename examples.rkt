#lang racket

(module example1 typed/racket
  (require "church.rkt")
  (define P1 (apply-axiom1 (form "P") (form ("Q" -> "P"))))
  (define P2 (apply-axiom2 (form "P") (form ("Q" -> "P")) (form "P")))
  (define P3 (apply-modus-ponens P2 P1))
  (define P4 (apply-axiom1 (form "P") (form "Q")))
  (display (print-proof (apply-modus-ponens P3 P4) "[P implies P]"))
  (display "\nQED\n-----\n\n"))

(module example2 typed/racket
  (require "church.rkt")
  
  (: apply-hypothetical-syllogism (-> Proof Proof Proof))
  (define (apply-hypothetical-syllogism
           proof-P->Q
           proof-Q->R)
    (let ([P->Q (proof-conclusion proof-P->Q)]
          [Q->R (proof-conclusion proof-Q->R)])
      (if (not (and (implication? P->Q)
                    (implication? Q->R)))
          (error "Both formula must be implications.")
          (void))
      (let ([P (implication-antecedent P->Q)]
            [Q (implication-antecedent Q->R)]
            [R (implication-consequent Q->R)])
        (define phi-0 (apply-axiom1 Q->R Q))
        (define phi-1 (apply-modus-ponens phi-0 proof-Q->R))
        (define phi-2 (apply-axiom1 (implication Q Q->R) P))
        (define phi-3 (apply-modus-ponens phi-2 phi-1))
        (define phi-4 (apply-axiom2 P Q Q->R))
        (define phi-5 (apply-modus-ponens phi-4 phi-3))
        (define phi-6 (apply-modus-ponens phi-5 proof-P->Q))
        (define phi-7 (apply-axiom2 P Q R))
        (define phi-8 (apply-modus-ponens phi-7 phi-6))
        (apply-modus-ponens phi-8 proof-P->Q))))

  (define A1 (assuming (form ("P" -> "Q"))))
  (define A2 (assuming (form ("Q" -> "R"))))

  (display (print-proof (apply-hypothetical-syllogism A1 A2) "[Hypothetical Syllogism]"))
  (display "\nQED\n-----\n\n"))

(require 'example1)
(require 'example2)